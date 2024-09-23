import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Controller/Chat/ChatDetailController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:http/http.dart' as http;
import "dart:html" as html;

import '../../Utils/enum.dart';

class UpdateProfileController extends GetxController {
  DateTime timeNow = DateTime.now();
  TextEditingController firstName = TextEditingController();
  RxBool isLoading = false.obs;
  late Brightness previousBrightness;
  RxString avatarUser = ''.obs;
  RxString userName = ''.obs;
  Rx<File> imageAvatar = File('').obs;
  RxBool isCheckNull = false.obs;
  ValueNotifier<Uint8List?> imageAvatarWeb = ValueNotifier<Uint8List?>(null);
  ValueNotifier<File?> imageAvatarFile = ValueNotifier<File?>(null);

  void onInit() async {
    firstName.text = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    avatarUser.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    userName.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);

    if (firstName.text.trim() != '') {
      isCheckNull.value = true;
    }

    String checkName = await Utils.getStringValueWithKey(Constant.FULL_NAME);

    if (checkName.isEmpty) {
      userName.value = await Utils.getStringValueWithKey(Constant.USERNAME);
    }
    firstName.addListener(() {
      if (firstName.text == '') {
        isCheckNull.value = false;
      } else {
        isCheckNull.value = true;
      }
    });

    previousBrightness = MediaQuery.platformBrightnessOf(Get.context!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkBrightnessChange();
    });

    super.onInit();
  }

  checkBrightnessChange() {
    Brightness currentBrightness = MediaQuery.platformBrightnessOf(Get.context!);

    if (previousBrightness != currentBrightness) {
      // Chế độ đã thay đổi
      MediaQuery.platformBrightnessOf(Get.context!) == Brightness.light ? Get.changeThemeMode(ThemeMode.light) : Get.changeThemeMode(ThemeMode.dark);

      // Thực hiện các hành động cần thiết
    }
  }

  pushFileWeb({required int type, required List<html.File> fileData}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now());
    try {
      var data = await APICaller.getInstance().putFilesWeb(
        endpoint: 'v1/Upload/upload-image',
        fileData: fileData,
        type: 1,
        keyCert: Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        time: formattedTime,
      );
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list.map((dynamic json) => '"$json"').toList();
        avatarUser.value = jsonDecode(listItem[0]);
        avatarUser.refresh();
        await updateAvatar(avatarUser.value);

        print('avataruser ${avatarUser.value}');
      } else {
        // isImageLoading.value = false;
      }
    } catch (e) {
      // Utils.showSnackBar(title: TextByNation.getStringByKey('error_file'), message: '$e');
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('file_size'),
        type: ToastType.INFORM,
      );
    }
  }

  getImageFiles({required bool isCamera}) async {
    final html.File? images = await ImagePickerWeb.getImageAsFile();
    if (images != null) {
      List<html.File> fileData = [];
      fileData.add(images);
      await pushFileWeb(type: 1, fileData: fileData);
    } else {
      // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('file_size'));
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('file_size'),
        type: ToastType.INFORM,
      );
    }
  }

  pushFile() async {
    if (imageAvatar.value.path != '') {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      try {
        // isImageLoading.value = true;
        var data = await APICaller.getInstance().putFile(
            endpoint: 'v1/Upload/upload-image',
            filePath: imageAvatar.value,
            type: 1,
            keyCert: Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
            time: formattedTime);
        if (data != null) {
          List<dynamic> list = data['items'];
          var listItem = list.map((dynamic json) => '"$json"').toList();

          avatarUser.value = jsonDecode(listItem[0]);

          avatarUser.refresh();
          await updateAvatar(avatarUser.value);
        } else {
          // isImageLoading.value = false;
        }
      } catch (e) {
        // Utils.showSnackBar(title: TextByNation.getStringByKey('error_file'), message: '$e');

        Utils.showToast(
          Get.overlayContext!,
          '$e',
          type: ToastType.ERROR,
        );
        // isImageLoading.value = false;
      }
    }
  }

  updateAvatar(String pathAvatar) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {"keyCert": await Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime), "time": formattedTime, "avatarPath": pathAvatar};
    try {
      var data = await APICaller.getInstance().post('v1/Account/update-avatar', param);
      if (data != null) {
        await Utils.saveStringWithKey(Constant.AVATAR_USER, pathAvatar);
        if (Get.isRegistered<ChatController>()) {
          var controller = await Get.find<ChatController>();
          controller.avatarUser.value = await pathAvatar;
          avatarUser.refresh();
        }
        // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('name_ss'));
        Utils.showToast(
          Get.overlayContext!,
          TextByNation.getStringByKey('name_ss'),
          type: ToastType.SUCCESS,
        );
      }
    } catch (e) {
     Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  updateName() async {
    isLoading.value = true;
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert": await Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "fullName": firstName.text,
    };
    try {
      var data = await APICaller.getInstance().post('v1/Account/update-fullname', param);
      if (data != null) {
        Utils.saveStringWithKey(Constant.FULL_NAME, firstName.text);
        isLoading.value = false;
        if (Get.isRegistered<ChatController>()) {
          var controller = Get.find<ChatController>();
          controller.userName.value = firstName.text;
          controller.refresh();
          controller.update();
        }
        if (Get.isRegistered<ChatDetailController>()) {
          var controller = Get.find<ChatDetailController>();
          controller.userName = firstName.text;
          controller.refresh();
        }

        // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('name_ss'));
        Utils.showToast(
          Get.overlayContext!,
          TextByNation.getStringByKey('name_ss'),
          type: ToastType.SUCCESS,
        );
        Get.find<ChatController>().refresh();
      }
    } catch (e) {
     Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }
}
