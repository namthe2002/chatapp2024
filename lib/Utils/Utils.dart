import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Chat/Chat.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Service/SocketManager.dart';
import 'package:live_yoko/Utils/DeviceInfo.dart';
import 'package:live_yoko/View/Account/Splash.dart';
import 'package:mime/mime.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Global/ColorValue.dart';
import '../Global/Constant.dart';
import '../Global/StyleSheet.dart';
import '../Service/PushNotification/PushNotification.dart';

class Utils {
  static bool isFirstApp = false;
  static final Future<SharedPreferences> _prefs =
  SharedPreferences.getInstance();

  static bool isEmpty(Object? text) {
    if (text is String) return text.isEmpty;
    if (text is List) return text.isEmpty;
    return text == null;
  }

  static Future saveStringWithKey(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future saveIntWithKey(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(key, value);
  }

  static Future getStringValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future getIntValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future getBoolValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key) ?? false;
  }

  static Future saveBoolWithKey(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
  }

  static String getTimeMessage(String time) {
    DateFormat originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    final DateTime messageDateTime =
    originalFormat.parse(time.toString(), true);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    String timeUpadte;
    if (messageDateTime.year == today.year) {
      if (messageDateTime.isAfter(today)) {
        timeUpadte = DateFormat.Hm().format(messageDateTime);
      } else {
        // Hiển thị ngày
        timeUpadte = DateFormat('dd/MM').format(messageDateTime);
      }
    } else {
      timeUpadte = DateFormat('dd/MM/yy').format(messageDateTime);
    }

    return timeUpadte;
  }

  static String formatCurrency(double value) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    String price = value.toString().replaceAll(regex, '');
    String priceInText = "";
    int counter = 0;
    for (int i = (price.length - 1); i >= 0; i--) {
      counter++;
      String str = price[i];
      if ((counter % 3) != 0 && i != 0) {
        priceInText = "$str$priceInText";
      } else if (i == 0) {
        priceInText = "$str$priceInText";
      } else {
        priceInText = ",$str$priceInText";
      }
    }
    return priceInText.trim() + 'đ';
  }

  static String convertMetToKm(double met) {
    return (met / 1000).toStringAsFixed(2);
  }

  static String formatViewCount(int viewCount) {
    if (viewCount < 1000) {
      // Trường hợp nhỏ hơn 1000, không cần chuyển đổi, trả về số lượt xem như cũ.
      return viewCount.toStringAsFixed(0);
    } else if (viewCount < 1000000) {
      // Nếu lượt xem từ 1000 đến 999999, quy đổi thành đơn vị "K" (ngàn).
      double count = viewCount / 1000.0;
      return '${count.toStringAsFixed(1)}K';
    } else {
      // Nếu lượt xem từ 1 triệu trở lên, quy đổi thành đơn vị "M" (triệu).
      double count = viewCount / 1000000.0;
      return '${count.toStringAsFixed(1)}M';
    }
  }

  static void showSnackBar({required String title,
    required String message,
    Color? colorText = Colors.white,
    Widget? icon,
    bool isDismissible = true,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(seconds: 1),
    Color? backgroundColor = Colors.black,
    SnackPosition? direction = SnackPosition.TOP,
    Curve? animation}) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor!.withOpacity(0.3),
      snackPosition: direction,
      forwardAnimationCurve: animation,
    );
  }

  static void showDialog({String title = '',
    TextStyle? titleStyle,
    Widget? content,
    String? textCancel,
    String? textConfirm,
    Color? backgroundColor,
    Color? cancelTextColor,
    Color? confirmTextColor,
    Color? buttonColor,
    Widget? customCancel,
    Widget? customConfirm,
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    bool barrierDismissible = true,
    double radius = 10.0}) {
    Get.defaultDialog(
        title: title,
        titleStyle: titleStyle,
        content: content,
        textCancel: textCancel,
        textConfirm: textConfirm,
        backgroundColor: backgroundColor,
        cancel: customCancel,
        confirm: customConfirm,
        onCancel: onCancel,
        onConfirm: onConfirm,
        cancelTextColor: cancelTextColor,
        confirmTextColor: confirmTextColor,
        buttonColor: buttonColor,
        radius: radius);
  }

  static Future<List<File>> getMedia({required bool isCamera}) async {
    ImagePicker _picker = ImagePicker();
    List<File> files = List.empty(growable: true);
    bool containsVideo = false;
    bool containsImage = false;
    bool containsFile = false;
    try {
      if (!isCamera) {
        List<XFile> media = await _picker.pickMultipleMedia();
        for (var file in media) {
          String mediaType = getFileType(file.path);
          if (mediaType == 'Video') {
            containsVideo = true;
          }
          if (mediaType == 'Image') {
            containsImage = true;
          }
          if (mediaType != 'Image' && mediaType != 'Video') {
            containsFile = true;
          }
          if (mediaType == 'Unknown') {
            files.clear();
            showSnackBar(
                title: TextByNation.getStringByKey('file_notification'),
                message: TextByNation.getStringByKey('file_not_supported'));
            break;
          }
          if (containsVideo && containsImage && containsFile) {
            files.clear();
            showSnackBar(
                title: TextByNation.getStringByKey('file_notification'),
                message: TextByNation.getStringByKey('only_photo_video_file'));
            break;
          }
          if (mediaType == 'Video' && files.isNotEmpty) {
            files.clear();
            showSnackBar(
                title: TextByNation.getStringByKey('file_notification'),
                message: TextByNation.getStringByKey('only_video'));
            break;
          }
          if (mediaType != 'Image' &&
              mediaType != 'Video' &&
              files.isNotEmpty) {
            files.clear();
            showSnackBar(
                title: TextByNation.getStringByKey('file_notification'),
                message: TextByNation.getStringByKey('only_file'));
            break;
          }
          files.add(File(file.path));
        }
      } else {
        await _picker.pickImage(source: ImageSource.camera).then((value) {
          if (value != null) {
            files.add(File(value.path));
          }
        });
      }
    } catch (e) {
      print(e);
    }
    return files;
  }

  static Future<File> getImage() async {
    ImagePicker _picker = ImagePicker();
    File fileData = File('');
    try {
      XFile? media = await _picker.pickImage(source: ImageSource.gallery);
      if (media != null) {
        fileData = File(media.path);
      }
    } catch (e) {
      print(e);
    }
    return fileData;
  }

  static Future<List<File>> getMediaPicker(bool isImage) async {
    bool containsVideo = false;
    bool containsImage = false;

    ImagePicker _picker = ImagePicker();
    List<File> files = List.empty(growable: true);
    try {
      List<XFile> lst = isImage
          ? await _picker.pickMultiImage()
          : await _picker.pickMultipleMedia();
      for (var file in lst) {
        String mediaType = getFileType(file.path);
        if (mediaType == 'Video') {
          containsVideo = true;
        }
        if (mediaType == 'Image') {
          containsImage = true;
        }
        if (containsVideo && containsImage) {
          files.clear();
          showSnackBar(
              title: 'Thông báo file',
              message: 'Chỉ thêm được ảnh hoặc video riêng biệt');
          break;
        }
        if (mediaType == 'Video' && files.isNotEmpty) {
          files.clear();
          showSnackBar(
              title: 'Thông báo file', message: 'Chỉ thêm được 1 video');
          break;
        }
        files.add(File(file.path));
      }
    } catch (e) {
      print(e);
    }
    return files;
  }

  static String getFileType(String url) {
    String? mimeType = lookupMimeType(url);
    switch (mimeType) {
      case 'image/jpeg':
      case 'image/png':
      case 'image/gif':
      case 'image/svg+xml':
        return 'Image';
      case 'video/mp4':
      case 'video/mpeg':
      case 'video/quicktime':
        return 'Video';
      case 'audio/mpeg':
      case 'audio/mp3':
      case 'audio/wav':
        return 'Audio';
      case 'application/pdf':
        return 'PDF';
      case 'application/msword':
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return 'Microsoft Word';
      case 'application/vnd.ms-excel':
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return 'Microsoft Excel';
      case 'application/vnd.ms-powerpoint':
      case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
        return 'Microsoft PowerPoint';
      case 'text/plain':
        return 'Text';
      case 'application/zip':
        return 'ZIP';
      case 'application/x-rar-compressed':
        return 'RAR';
      default:
        return 'Unknown';
    }
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static backLogin(bool isRun) async {
    if (!isRun) {
      return;
    }

    await Utils.saveListToSharedPreferences([]);
    await Utils.saveStringWithKey(Constant.ACCESS_TOKEN, '');
    await Utils.saveStringWithKey(Constant.UUID_USER, '');
    await Utils.saveStringWithKey(Constant.USERNAME, '');
    await Utils.saveStringWithKey(Constant.PASSWORD, '');
    GlobalValue.getInstance().setToken('');
    GlobalValue.getInstance().setUuid('');
    if (Get.isRegistered<ChatController>()) {
      Get.delete<ChatController>();
      SocketManager().closeSocket();
    }

    isFirstApp = false;
    Navigation.navigateGetOffAll(page: 'Login');
  }

  //Chat
  static List<Gradient> gradientList = [
    LinearGradient(colors: [Color(0xff39EFA2), Color(0xff48C6D7)]),
    LinearGradient(colors: [Color(0xffD1E028), Color(0xff1AC9E1)]),
    LinearGradient(colors: [Color(0xff5CCEFF), Color(0xff0582F6)]),
    LinearGradient(colors: [Color(0xffFDCB1B), Color(0xffFF8C21)]),
    LinearGradient(colors: [Color(0xff8793FF), Color(0xff5969F9)]),
    LinearGradient(colors: [Color(0xffFF95F4), Color(0xffFF46B5)]),
    LinearGradient(colors: [Color(0xffFF9595), Color(0xffFF4646)]),
    LinearGradient(colors: [Color(0xff05EBA6), Color(0xff1FB8CD)]),
    LinearGradient(colors: [Color(0xff8D98FF), Color(0xff3B37FF)]),
    LinearGradient(colors: [Color(0xff8DFF9F), Color(0xff009B3E)]),
    LinearGradient(colors: [Color(0xffFFD600), Color(0xffE5A500)]),
    LinearGradient(colors: [Color(0xffD2D9FF), Color(0xff6288B6)]),
    LinearGradient(colors: [Color(0xffD2D9FF), Color(0xff1AC9E1)]),
  ];

  Gradient getRandomGradient() {
    // Lấy một số ngẫu nhiên trong phạm vi danh sách màu gradient
    int randomIndex = Random().nextInt(gradientList.length);

    // Trả về màu gradient ngẫu nhiên
    return gradientList[randomIndex];
  }

  static dynamic getGradientForLetter(String letter) {
    if (letter.isNotEmpty) {
      final Map<String, Gradient> alphabetColors = {
        'ab': gradientList[0],
        'cd': gradientList[1],
        'ef': gradientList[2],
        'gh': gradientList[3],
        'ij': gradientList[4],
        'kl': gradientList[5],
        'mn': gradientList[6],
        'op': gradientList[7],
        'qr': gradientList[8],
        'st': gradientList[9],
        'uv': gradientList[10],
        'wx': gradientList[11],
        'yz': gradientList[12],
      };
      String firstChar = letter.substring(0, 1).toLowerCase();

      String key = alphabetColors.keys
          .firstWhere((k) => k.contains(firstChar), orElse: () => '');
      if (key != '') {
        return alphabetColors[key]!;
      } else {
        return alphabetColors['ab']!;
      }
    }
  }

  static String getInitialsName(String name) {
    if (name
        .trim()
        .isNotEmpty) {
      List<String> nameParts = name.trim().split(' ');

      if (nameParts.isNotEmpty) {
        if (nameParts.length == 1) {
          return nameParts[0][0].toUpperCase();
        }

        String firstInitial = nameParts[0][0].toUpperCase();
        String lastInitial = nameParts[nameParts.length - 1][0].toUpperCase();

        return firstInitial + lastInitial;
      }
    }

    return '';
  }

  static Future<void> saveListToSharedPreferences(List<Chat> chatList) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> chatJsonList =
    chatList.map((chat) => jsonEncode(chat.toJson())).toList();
    prefs.setStringList(Constant.CHAT_LIST, chatJsonList);
  }

  static Future<List<Chat>> getListFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? chatJsonList = prefs.getStringList(Constant.CHAT_LIST);
    if (chatJsonList != null) {
      return chatJsonList
          .map((chatJson) => Chat.fromJson(jsonDecode(chatJson)))
          .toList();
    }
    return [];
  }

  static login({String? userName, String? password}) async {
    DateTime timeNow = DateTime.now();
    String ipAddress = "";
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ipAddress = result[0].address;
      }
    } catch (e) {}
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

    String userNamePreferences = await getStringValueWithKey(Constant.USERNAME);
    String passwordPreferences = await getStringValueWithKey(Constant.PASSWORD);

    var param = {
      "keyCert":
      Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "username": userName != null ? userName : userNamePreferences,
      "password": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_PASS +
          (password != null ? password : passwordPreferences)),
      "ip": ipAddress,
      "deviceName": "mobile",
      "os": "android",
      "address": "",
      "fcmToken": GlobalValue.getInstance().getFCMToken(),
      "deviceId": "",
    };

    try {
      var data = await APICaller.getInstance().post('v1/Account/login', param);
      if (data != null) {
        if (Get.isRegistered<ChatController>()) {
          Get.delete<ChatController>();
          // SocketManager().closeSocket();
        }
        GlobalValue.getInstance().setToken('Bearer ${data['data']['token']}');
        if (data['data']['roleId'] == 2) {
          Navigation.navigateTo(page: 'AdminAccount');
        } else {
          GlobalValue.getInstance().setUuid(data['data']['uuid'] ?? '');
          Utils.saveStringWithKey(Constant.ACCESS_TOKEN, data['data']['token']);
          Utils.saveStringWithKey(
              Constant.EMAIL_USER, data['data']['email'] ?? '');
          Utils.saveStringWithKey(
              Constant.UUID_USER, data['data']['uuid'] ?? '');
          Utils.saveStringWithKey(
              Constant.USERNAME, data['data']['userName'] ?? '');
          Utils.saveStringWithKey(
              Constant.FULL_NAME, data['data']['fullName'] ?? '');
          Utils.saveStringWithKey(
              Constant.AVATAR_USER, data['data']['avatar'] ?? '');
          Utils.saveIntWithKey(Constant.ROLE_ID,
              data['data']['roleId'] == null ? 0 : data['data']['roleId']);
          Utils.saveStringWithKey(Constant.PASSWORD,
              password != null ? password : passwordPreferences);

          Utils.saveStringWithKey(
              Constant.session_uuid, data['data']['sessionUuid']);
          String abcd = await Utils.getStringValueWithKey(Constant.session_uuid);
              print('namthe1234 $abcd');
          await SocketManager().connect();
          Navigation.navigateGetOffAll(page: 'Chat');
          Timer(Duration(seconds: 5), () {
            updateFCMToken();
          });
        }
        isFirstApp = true;
      } else {
        if (userNamePreferences.isNotEmpty) {
          Navigation.navigateGetOffAll(page: 'Login');
        }
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('error_login'), message: '$e');
    }
  }

  static Future<void> updateFCMToken() async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "token": GlobalValue.getInstance().getFCMToken(),
        "uuid": GlobalValue.getInstance().getUuid()
      };

      APICaller.getInstance().post('v1/Account/update-fcm-token', param);
    } catch (e) {} finally {}
  }

  static toggleNotification(int state) async {
    DateTime timeNow = DateTime.now();
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "state": state
      };
      var data = await APICaller.getInstance()
          .post('v1/Account/toggle-notification-receive', param);
      if (data != null) {
        if (state == 0) {
          Utils.saveIntWithKey(Constant.NOTIFICATION, 2);
        } else {
          Utils.saveIntWithKey(Constant.NOTIFICATION, 1);
        }
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }

  static setTranslate() async {
    String code =
    await Utils.getStringValueWithKey(Constant.LANGUAGE_TRANSLATE_CODE);
    if (code.isEmpty) {
      if (TextByNation.nationCode.value == 'US') {
        code = 'en';
      } else if (TextByNation.nationCode.value == 'VN') {
        code = 'vi';
      } else {
        code = 'zh-CN';
      }
    }
    GlobalValue.getInstance().setCountryCode(code);
  }

  static bool isDesktopWeb(BuildContext context) =>
      kIsWeb && ResponsiveWrapper
          .of(context)
          .isDesktop;
}
