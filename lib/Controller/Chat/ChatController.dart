import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/AppController.dart';
import 'package:live_yoko/Controller/Chat/ChatDetailController.dart';
import 'package:live_yoko/Controller/Chat/MediaChatDetailController.dart';
import 'package:live_yoko/Controller/Chat/ProfileChatDetailController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Chat/Chat.dart';
import 'package:live_yoko/Models/Chat/ChatDetail.dart';
import 'package:live_yoko/Models/Chat/ChatDetailItem.dart';
import 'package:live_yoko/Service/SocketManager.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Service/APICaller.dart';

class ChatController extends GetxController {
  RxBool isSelected = false.obs;
  RxBool isDeleteBot = false.obs;
  RxInt selectedChatIndex = (-1).obs;
  RxInt selectBrightnessMode = 0.obs;
  RxBool isVisible = true.obs;
  final ScrollController scrollController = ScrollController();
  int pageSize = 50;
  int page = 1;
  RxList<Chat> listChat = <Chat>[].obs;
  Rxn<Chat> selectedChatItem = Rxn<Chat>();
  RxBool hasMore = true.obs;
  Rx<bool> isLoading = true.obs;
  final Map<String, Uint8List> thumbnailCache = {};
  late Brightness previousBrightness;
  RxList<String> listChatSelect = <String>[].obs;
  RxString userName = ''.obs;
  RxString userNameAcount = ''.obs;
  ChatDetailItem newMessage = ChatDetailItem();
  RxString avatarUser = ''.obs;
  DateTime timeNow = DateTime.now();
  RxBool isUnPin = false.obs;
  Timer? _timer;
  int pinLength = 0;
  late Timer timer;
  List<Work> listWork = <Work>[];
  RxString fullNameUser = ''.obs;
  ChatDetail forward = ChatDetail();
  final AppController appController = Get.find();
  String uuidRoomnew = '';
  String uuidLastMessageNew = '';
  bool isClickLoading = true;
  RxInt selectedChatItemIndex = (-1).obs;
  Rx<Widget?> widgetFeature = Rx<Widget?>(null);

  final SocketManager _socketManager = SocketManager();

  @override
  void onInit() async {
    // ever(appController.appState, (state) async {
    //   if (state == AppLifecycleState.resumed) {
    //     // await SocketManager().connect();
    //   } else {
    //     readMessage(uuidRoomnew, uuidLastMessageNew);
    //   }
    // });
    // if (await Utils.getIntValueWithKey(Constant.NOTIFICATION) == 0) {
    //   Utils.toggleNotification(1);
    // }
    // avatarUser.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    // avatarUser.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    // avatarUser.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    // userName.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    // fullNameUser.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    // fullNameUser.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    // String checkName = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    //
    // if (checkName.isEmpty) {
    //   userName.value = await Utils.getStringValueWithKey(Constant.USERNAME);
    // }
    // userNameAcount.value = await Utils.getStringValueWithKey(Constant.USERNAME);
    //
    // if (await Utils.getBoolValueWithKey(Constant.AUTO_MODE) == true) {
    //   selectBrightnessMode.value = 2;
    // } else {
    //   if (await Utils.getBoolValueWithKey(Constant.DARK_MODE) == false) {
    //     selectBrightnessMode.value = 0;
    //   } else {
    //     selectBrightnessMode.value = 1;
    //   }
    // }
    // // previousBrightness = MediaQuery.platformBrightnessOf(Get.context!);
    // // WidgetsBinding.instance.addPostFrameCallback((_) {
    // //   checkBrightnessChange();
    // // });
    // await getChat();
    // await sendListOnline();
    // scrollController.addListener(() {
    //   if (scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     if (isVisible == true) {
    //       isVisible.value = false;
    //     }
    //   } else {
    //     if (scrollController.position.userScrollDirection ==
    //         ScrollDirection.forward) {
    //       if (isVisible == false) {
    //         isVisible.value = true;
    //       }
    //     }
    //   }
    //
    //   // if (scrollController.position.pixels ==
    //   //     scrollController.position.maxScrollExtent) {
    //   //   // Thực hiện hành động khi đến cuối danh sách
    //   //   // Ví dụ: Hiển thị một widget
    //   //   isVisible.value = true;
    //   // }
    // });
    //
    // scrollController.addListener(() {
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.offset) {
    //     if (hasMore.value) {
    //       page++;
    //       getChat();
    //     } else {
    //       isVisible.value = true; // hiển thị nút khi vuốt tới cuối cùng
    //     }
    //   }
    // });
    //
    // timer = await Timer.periodic(Duration(seconds: 10),
    //     (timer) => sendListOnline()); // gọi hàm sendState
    super.onInit();
  }


  void onInitData() async {
    ever(appController.appState, (state) async {
      if (state == AppLifecycleState.resumed) {
        // await SocketManager().connect();
      } else {
        readMessage(uuidRoomnew, uuidLastMessageNew);
      }
    });
    if (await Utils.getIntValueWithKey(Constant.NOTIFICATION) == 0) {
      Utils.toggleNotification(1);
    }
    avatarUser.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    avatarUser.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    avatarUser.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    userName.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    fullNameUser.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    fullNameUser.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    String checkName = await Utils.getStringValueWithKey(Constant.FULL_NAME);

    if (checkName.isEmpty) {
      userName.value = await Utils.getStringValueWithKey(Constant.USERNAME);
    }
    userNameAcount.value = await Utils.getStringValueWithKey(Constant.USERNAME);

    if (await Utils.getBoolValueWithKey(Constant.AUTO_MODE) == true) {
      selectBrightnessMode.value = 2;
    } else {
      if (await Utils.getBoolValueWithKey(Constant.DARK_MODE) == false) {
        selectBrightnessMode.value = 0;
      } else {
        selectBrightnessMode.value = 1;
      }
    }
    // previousBrightness = MediaQuery.platformBrightnessOf(Get.context!);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkBrightnessChange();
    // });
    await getChat();
    await sendListOnline();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible == true) {
          isVisible.value = false;
        }
      } else {
        if (scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (isVisible == false) {
            isVisible.value = true;
          }
        }
      }

    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (hasMore.value) {
          page++;
          getChat();
        } else {
          isVisible.value = true; // hiển thị nút khi vuốt tới cuối cùng
        }
      }
    });

    timer = await Timer.periodic(Duration(seconds: 10),
            (timer) => sendListOnline());

  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  sendListOnline() async {
    List<String> listPartnerUuid = [];
    for (var item in listChat) {
      if (item.type == 1 && item.partnerUuid != null) {
        listPartnerUuid.add(item.partnerUuid!);
      }
    }

    await _socketManager.sendOnlineStateRequest(list: listPartnerUuid);
  }

  readMessage(String roomUuid, String mesageLineUuid) async {
    await _socketManager.sendReadRequest(
      roomUuid: roomUuid,
      msgUuid: mesageLineUuid,
    );
  }

  String getTimeMessage(String time) {
    DateFormat originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    final DateTime messageDateTime =
        originalFormat.parse(time.toString(), true).toLocal();
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

  deleteContent(dynamic message) {
    int index = listChat.indexWhere(
        (element) => message['ListMsgUuid'].contains(element.lastMsgLineUuid));
    if (index != -1) {
      listChat[index].status = 4;
      listChat.refresh();
    }
  }

  resetListOnline(dynamic listOnline) async {
    List<dynamic> listItem = listOnline;
    List<Work> listItemWork =
        await listItem.map((dynamic json) => Work.fromJson(json)).toList();
    listWork.addAll(listItemWork);

    for (var itemChat in listChat) {
      for (var itemWork in listWork) {
        if (itemWork.userName == itemChat.partnerUuid &&
            itemWork.onlineState == true) {
          itemChat.isActive = true;
          break; // Thoát vòng lặp khi tìm thấy UUID khớp
        }
      }
    }
    listChat.refresh();
  }

  setRead(dynamic message) {
    int index =
        listChat.indexWhere((element) => element.uuid == message['RoomUuid']);
    if (index != -1) {
      listChat[index].readCounter = 1;
      listChat.refresh();
    }
  }

  setTyping(dynamic message) {
    int index =
        listChat.indexWhere((element) => element.uuid == message['RoomUuid']);

    if (index != -1) {
      String fullNamedecoded = message['FullName'] ?? '';
      try {
        fullNamedecoded =
            utf8.decode(base64Url.decode(message['FullName'] ?? ''));
      } catch (e) {
        fullNamedecoded = message['FullName'] ?? '';
      }
      listChat[index].userTyping = fullNamedecoded;
      listChat.refresh();
      refreshTyping(index);
    }
  }

  refreshTyping(int index) {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(const Duration(milliseconds: 5000), () {
      listChat[index].userTyping = '';
      listChat.refresh();
    });
  }

  remoteChat(dynamic message) async {
    int index = listChat.indexWhere((element) =>
        element.ownerUuid == message['RoomUuid'] ||
        element.uuid == message['RoomUuid']);
    if (index != -1) {
      listChat.removeAt(index);
      // isUnPin.value = true;
      // await refreshListChat();
      listChat.refresh();

      if (Get.isRegistered<ChatDetailController>()) {
        var controllerChatDetail = Get.find<ChatDetailController>();
        if (controllerChatDetail.ownerUuid == message['RoomUuid']) {
          // Get.close(1);
          int isBack = 1;
          if (Get.isRegistered<ProfileChatDetailController>()) {
            Get.delete<ProfileChatDetailController>();
            isBack += 1;
          }
          if (Get.isRegistered<MediaChatDetailController>()) {
            Get.delete<MediaChatDetailController>();
            isBack += 1;
          }

          Get.close(isBack);
          Get.delete<ChatDetailController>();
        }
      } // check thêm cả trường hợp đang ở trong các phần khác nữa trong chi tiểt
    }
  }

  joinChat(dynamic message) async {
    isUnPin.value = true;
    await refreshListChat(); // thông báo khi có nhóm mới
  }

  updateChat(dynamic message) async {
    newMessage = ChatDetailItem.fromJson(message);

    int index = listChat
        .indexWhere((element) => element.uuid == newMessage.msgRoomUuid);
    String decoded = newMessage.content ?? '';
    // String userSentdecode = newMessage.userSent!;
    // String rooomeNamedecode = newMessage.roomName!;
    String fullNamedecode = newMessage.fullName!;
    try {
      decoded = utf8.decode(base64Url.decode(newMessage.content!));
      // userSentdecode = utf8.decode(base64Url.decode(newMessage.userSent!));
      // rooomeNamedecode = utf8.decode(base64Url.decode(newMessage.roomName!));
      fullNamedecode = utf8.decode(base64Url.decode(newMessage.fullName!));
    } catch (e) {
      decoded = newMessage.content ?? '';
      // userSentdecode = newMessage.userSent ?? '';
      // rooomeNamedecode = newMessage.roomName ?? '';
      fullNamedecode = newMessage.fullName ?? '';
    }

    if (index != -1) {
      if (index == 0) {
        listChat[index].type = newMessage.type;
        listChat[index].content = newMessage.type == 5 || newMessage.type == 3
            ? Constant.BASE_URL_IMAGE + decoded.toString()
            : decoded.toString();
        if (userNameAcount.value != newMessage.userSent) {
          if (Get.isRegistered<ChatDetailController>() == false) {
            listChat[index].unreadCount = listChat[index].unreadCount! + 1;
          }
        }

        listChat[index].fullName = fullNamedecode;
        listChat[index].userSent = fullNamedecode;
        listChat[index].contentType = newMessage.contentType;
        listChat[index].lastUpdated = newMessage.timeCreated;
        listChat[index].forwardFrom = newMessage.forwardFrom;
        //listChat[index].ownerName = rooomeNamedecode;
        listChat[index].userTyping = '';
        if (userNameAcount.value == newMessage.userSent) {
          listChat[index].readCounter = 0;
          await readMessage(listChat[index].uuid!, newMessage.uuid!);
        }
        uuidRoomnew = listChat[index].uuid!;
        uuidLastMessageNew = newMessage.uuid!;
        listChat[index].lastMsgLineUuid = newMessage.uuid;
        listChat[index].status = 0;
        listChat.refresh();
      } else {
        Chat itemChat = await listChat[index];

        bool isPin = await listChat[index].pinned ?? false;
        await listChat.removeAt(index);
        listChat.insert(
            isPin == false ? pinLength : 0,
            await Chat(
                fullName: fullNamedecode,
                avatar: itemChat.avatar,
                pinned: isPin,
                uuid: itemChat.uuid,
                userSent: fullNamedecode,
                type: newMessage.type,
                ownerUuid: newMessage.ownerUuid,
                content: decoded,
                contentType: newMessage.contentType,
                timeCreated: itemChat.timeCreated,
                lastUpdated: newMessage.timeCreated,
                status: newMessage.status,
                ownerName: itemChat.ownerName,
                likeCount: itemChat.likeCount,
                unreadCount: userNameAcount.value != newMessage.userSent
                    ? Get.isRegistered<ChatDetailController>() == false
                        ? itemChat.unreadCount! + 1
                        : 0
                    : 0));
        if (newMessage.type == 1) {
          listChat[isPin == false ? pinLength : 0].isActive = itemChat.isActive;
        }
        listChat[isPin == false ? pinLength : 0].userTyping = await '';
        if (userNameAcount.value == newMessage.userSent) {
          listChat[isPin == false ? pinLength : 0].readCounter = 0;
          await readMessage(listChat[index].uuid!, newMessage.uuid!);
        }
        uuidRoomnew = listChat[index].uuid!;
        uuidLastMessageNew = newMessage.uuid!;
        listChat[isPin == false ? pinLength : 0].forwardFrom =
            newMessage.forwardFrom;
        listChat[isPin == false ? pinLength : 0].status = 0;
        listChat[isPin == false ? pinLength : 0].lastMsgLineUuid =
            newMessage.uuid;
        listChat.refresh();
      }
      // update tin nhắn
    } else {
      await Future.delayed(Duration(seconds: 3));
      // isUnPin.value = true;
      await refreshListChat();
      // listChat.insert(
      //     pinLength == 0 ? 0 : pinLength,
      //     await Chat(
      //       ownerUuid: newMessage.ownerUuid,
      //       uuid: newMessage.msgRoomUuid,
      //       content: decoded,
      //       type: newMessage.type,
      //       ownerName: rooomeNamedecode,
      //       userSent: fullNamedecode,
      //       contentType: newMessage.contentType,
      //       unreadCount: userNameAcount.value == newMessage.userSent ? 0 : 1,
      //       lastUpdated: newMessage.timeCreated,
      //     ));
      // if (newMessage.type == 1) {
      //   listChat[pinLength == 0 ? 0 : pinLength].isActive = true;
      // }
    }
  }

  Future refreshListChat() async {
    page = 1;
    hasMore.value = await true;

    if (isUnPin.value) {
      getChat();
      listChat.refresh();
    } else {
      isLoading.value = true;
      listChat.clear();
      getChat();
    }
  }

  void selectItem(int index) {
    selectedChatIndex.value = index;
  }

  checkBrightnessChange() {
    Brightness currentBrightness =
        MediaQuery.platformBrightnessOf(Get.context!);

    if (previousBrightness != currentBrightness) {
      // Chế độ đã thay đổi
      MediaQuery.platformBrightnessOf(Get.context!) == Brightness.light
          ? Get.changeThemeMode(ThemeMode.light)
          : Get.changeThemeMode(ThemeMode.dark);

      // Thực hiện các hành động cần thiết
    }
  }

  changeTheme(int index, BuildContext context) async {
    if (index == 0) // lightmode
    {
      Get.changeThemeMode(ThemeMode.light);
      await Utils.saveBoolWithKey(Constant.DARK_MODE, false);
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, false);
      // isRegime.value = true;
    } else if (index == 1) {
      Get.changeThemeMode(ThemeMode.dark);
      await Utils.saveBoolWithKey(Constant.DARK_MODE, true);
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, false);
      // isRegime.value = true;
    } else {
      MediaQuery.platformBrightnessOf(context) == Brightness.light
          ? Get.changeThemeMode(ThemeMode.light)
          : Get.changeThemeMode(ThemeMode.dark);
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, true);
    }
  }

  Future getChat() async {
    DateTime timeNow = DateTime.now();
    String formattedTime =
        DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow.toLocal());
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": page,
        "type": 0
      };

      var response =
          await APICaller.getInstance().post('v1/Chat/message-room', param);
      print('response is: ${response}');
      if (response != null) {
        List<dynamic> list = response['items'];
        var listItem = list.map((dynamic json) => Chat.fromJson(json)).toList();
        if (isUnPin.value) {
          listChat.clear();
        }
        listChat.addAll(listItem);

        pinLength = listChat.where((element) => element.pinned == true).length;
        if (listItem.length < pageSize) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
      isUnPin.value = await false;
    }
  }

  Future pinMessage(int index, bool isPin) async {
    String formattedTime =
        DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow.toLocal());
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "roomUuid": listChat[index].uuid,
        "state": isPin == true ? 0 : 1
      };
      var response =
          await APICaller.getInstance().post('v1/Chat/pin-message', param);
      if (response != null) {
        if (isPin == false) // pin
        {
          isUnPin.value = true;
          await refreshListChat();
        } else {
          isUnPin.value = true;
          await refreshListChat();
        }
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      // isLoading.value = false;
    }
  }

  Future deleteMessage(int index) async {
    String formattedTime =
        DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow.toLocal());
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": listChat[index].uuid
      };
      var response = await APICaller.getInstance()
          .delete('v1/Chat/delete-message-room', body: param);
      if (response != null) {
        Get.close(1);
        listChat.removeAt(index);
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('delete_message'));
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateFeature(BuildContext context, Widget widget) {
    widgetFeature.value = widget;
  }

  clearMessage({required int index}) async {
    String formattedTime =
        DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow.toLocal());
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": listChat[index].uuid
      };
      var data = await APICaller.getInstance()
          .delete('v1/Chat/delete-history-message-room', body: param);
      if (data != null) {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('delete_message'));
        refreshListChat();
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }

  List<Regime> listNode = [
    Regime(src: 'asset/images/light_mode.svg', title: 'Light Mode'),
    Regime(src: 'asset/images/dark_mode.svg', title: 'Dark Mode'),
    Regime(src: 'asset/images/auto_mode.svg', title: 'Auto - Mode'),
  ];

  forwardMessage({required String uuid}) async {
    await _socketManager.forwardMessage(
        roomUuid: uuid, msgLineUuid: forward.uuid!);
  }

// Khởi tạo với giá trị -1 nghĩa là chưa có icon nào được chọn.

  void selectIcon(int index) {
    selectedChatItemIndex.value = index;
  }

  void selectChatItem(Chat item) {
    selectedChatItem.value = item;
    print('namthe12 ${selectedChatItem.value!.fullName}');
  }
}

class Work {
  String? userName;
  bool? onlineState;

  Work({this.userName, this.onlineState});

  Work.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    onlineState = json['OnlineState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['OnlineState'] = this.onlineState;
    return data;
  }
}

class Regime {
  String? src, title;

  Regime({this.src, this.title});
}
