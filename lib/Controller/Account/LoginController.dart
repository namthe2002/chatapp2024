import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Global/RegularExpressions.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../Navigation/Navigation.dart';

class LoginController extends GetxController {
  TextEditingController textUserName = TextEditingController();
  TextEditingController textPass = TextEditingController();
  TextEditingController phoneNumberForgotpass = TextEditingController();
  TextEditingController otpForgotpass = TextEditingController();
  RxBool isHidePassNewEn = true.obs;
  RxBool isHidePassNew = true.obs;
  TextEditingController passForgotpass = TextEditingController();
  TextEditingController passRetypeForgotpass = TextEditingController();
  RxBool isHidePassword = true.obs;
  RxInt forgotPassState = 0.obs;
  RxBool isLoading = false.obs;
  TextEditingController textPassRegister = TextEditingController();
  TextEditingController textPassConfirmRegister = TextEditingController();
  TextEditingController textPhoneNumberRegister = TextEditingController();
  TextEditingController textFullNameRegister = TextEditingController();
  TextEditingController textOTPRegister = TextEditingController();
  RxBool isHidePasswordRegister = true.obs;
  RxBool isHidePasswordConfirmRegister = true.obs;
  RxBool isOTP = false.obs;
  DateTime timeNow = DateTime.now();
  String otpData = '';


  @override
  void onInit() {
    super.onInit();
    _init();
  }
  void _init() async {
    String accessToken =
    await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
    textUserName.text = '0123456788';
    textPass.text = '12345678';
    // if (accessToken.isNotEmpty) {
    //   await Utils.login();}
  }

  Future forgotpass() async {
    if (phoneNumberForgotpass.text.trim().isEmpty) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('phone_null'));
    } else if (!RegularExpressions.hexPhoneNumber
        .hasMatch(phoneNumberForgotpass.value.text)) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('phone_valid'));
    } else {
      await otpResetPass();
    }
    isLoading.value = false;
  }

  Future resetPassWord() async {
    if (passForgotpass.text != passRetypeForgotpass.text) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('pass_valiate_overlap'));
    } else if (passForgotpass.text.length < 8) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('pass_validate'));
    } else if (passForgotpass.text.trim() == '') {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey(
              'pass_null')); // Vui lòng nhập mật khẩu
    } else if (passRetypeForgotpass.text.trim() == '') {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey(
              'pass_re_null')); // Vui lòng nhập lại mật khẩu
    } else {
      try {
        String formattedTime =
            DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
        var param = {
          "keyCert":
              Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
          "time": formattedTime,
          "userName": phoneNumberForgotpass.text,
          "otpCode": otpForgotpass.text,
          "newPass": await Utils.generateMd5(
              Constant.NEXT_PUBLIC_KEY_PASS + passForgotpass.text),
        };
        var data = await APICaller.getInstance()
            .post('v1/Account/forget-password', param);
        if (data != null) {
          forgotPassState.value = 0;
          Get.close(1);
          Utils.showSnackBar(
              title: TextByNation.getStringByKey('notification'),
              message: TextByNation.getStringByKey('pass_reset_ss'));
        }
      } catch (e) {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'), message: '$e');
      }
    }
    isLoading.value = false;
  }

  register() async {
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
        "userName": textPhoneNumberRegister.text.trim(),
        "ip": ipAddress,
        "os": "android",
        "deviceId": "",
        "deviceName": "mobile",
        "fcmToken": GlobalValue.getInstance().getFCMToken(),
        "fullName": textFullNameRegister.text.trim(),
        "roleId": 0,
        "password": Utils.generateMd5(
            Constant.NEXT_PUBLIC_KEY_PASS + textPassConfirmRegister.text),
        "otpCode": otpData,
        "email": ""
      };
      var data =
          await APICaller.getInstance().post('v1/Account/register', param);
      if (data != null) {
        Get.close(1);
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('resgiter_ss'));
        Utils.login(
            userName: textPhoneNumberRegister.text,
            password: textPassConfirmRegister.text);
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }

  otpResetPass() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "phoneNumber": phoneNumberForgotpass.text.trim(),
      };
      var data =
          await APICaller.getInstance().post('v1/Account/request-otp', param);
      if (data != null) {
        forgotPassState.value = 1;
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      isLoading.value = false;
    }
  }

  otp() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "phoneNumber": textPhoneNumberRegister.text.trim()
      };
      var data = await APICaller.getInstance()
          .post('v1/Account/request-register-otp', param);
      if (data != null) {
        isOTP.value = !isOTP.value;
        otpData = '123456';
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }
}

class QrController extends GetxController {
  final String message;

  String get hashStr => getSHA256(message);

  // String get concatMsg => "$message ${hashStr.substring(32)}";
  String get concatMsg => "$message ";
  Uint8List? qrImage;

  QrController({required this.message});

  String getSHA256(String input) {
    final timeString = DateTime.now().year.toString() +
        DateTime.now().month.toString().padLeft(2, '0') +
        DateTime.now().day.toString().padLeft(2, '0') +
        DateTime.now().hour.toString().padLeft(2, '0');
    return sha256.convert(utf8.encode(timeString + "888" + input)).toString();
  }

  // String getHMACSHA256(String input) {
  //   String base64Key = 'CDMobApp scrt key';
  //   List<int> messageBytes = utf8.encode(input);
  //   List<int> key = base64.decode(base64Key);
  //   Hmac hmac = Hmac(sha256, key);
  //   Digest digest = hmac.convert(messageBytes);
  //   return base64.encode(digest.bytes);
  // }

  void loadOverlayImage() async {
    final completer = Completer<ui.Image>();
    final byteData = await rootBundle.load('asset/images/icon_carrot.png');
    qrImage = byteData.buffer.asUint8List();
  }

  Future<void> loadQrCode() async {
    loadOverlayImage();
  }
}
