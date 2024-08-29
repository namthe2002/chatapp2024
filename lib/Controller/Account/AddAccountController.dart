import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/Account/AdminAccountController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Chat/PositionType.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';

class AddAccountController extends GetxController {
  List<PositionType> positionList = [
    PositionType(value: 2, title: TextByNation.getStringByKey('admin')),
    PositionType(value: 1, title: TextByNation.getStringByKey('leader')),
    PositionType(value: 0, title: TextByNation.getStringByKey('user')),
  ];
  Rx<PositionType> selectedPosition = PositionType().obs;
  DateTime timeNow = DateTime.now();
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  RegExp hexEmail = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  void onInit() async {
    super.onInit();
    selectedPosition.value = positionList[0];
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  changeGroupInfo() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    String ipAddress = "";
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        ipAddress = result[0].address;
      }
    } catch (e) {}
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "userName": userName.text,
        "ip": ipAddress,
        "os": "android",
        "deviceId": "",
        "deviceName": "mobile",
        "fcmToken": GlobalValue.getInstance().getFCMToken(),
        "email": email.text,
        "fullName": firstName.text,
        "roleId": selectedPosition.value.value,
        "password": ''
      };
      var data =
          await APICaller.getInstance().post('v1/Account/register', param);
      if (data != null) {
        if (Get.isRegistered<AdminAccountController>()) {
          Get.find<AdminAccountController>().resetFriend();
        }
        Get.close(1);
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }
}
