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
import '../../Utils/enum.dart';

class ThemeControler extends GetxController {
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
    super.onInit();
  }

  void initData() async {

    ever(appController.appState, (state) async {
      if (state == AppLifecycleState.resumed) {
        // await SocketManager().connect();
      } else {
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



  }

  @override
  void onClose() {
    super.onClose();
  }


  checkBrightnessChange() {
    Brightness currentBrightness = MediaQuery.platformBrightnessOf(Get.context!);
    if (previousBrightness != currentBrightness) {
      MediaQuery.platformBrightnessOf(Get.context!) == Brightness.light ? Get.changeThemeMode(ThemeMode.light) : Get.changeThemeMode(ThemeMode.dark);
    }
  }

  changeTheme(int index, BuildContext context, Function refreshUI) async {
    if (index == 0) {
      await Utils.saveBoolWithKey(Constant.DARK_MODE, false);
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, false);
      Get.changeThemeMode(ThemeMode.light);
    } else if (index == 1) {
      await Utils.saveBoolWithKey(Constant.DARK_MODE, true);
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, false);
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, true);
      MediaQuery.platformBrightnessOf(context) == Brightness.light
          ? Get.changeThemeMode(ThemeMode.light)
          : Get.changeThemeMode(ThemeMode.dark);
    }
    refreshUI(); // Ensure UI is updated
  }


  List<Regime> listNode = [
    Regime(src: 'asset/images/light_mode.svg', title: 'Light Mode'),
    Regime(src: 'asset/images/dark_mode.svg', title: 'Dark Mode'),
    Regime(src: 'asset/images/auto_mode.svg', title: 'Auto - Mode'),
  ];

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
