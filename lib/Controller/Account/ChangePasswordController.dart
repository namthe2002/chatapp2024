import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Utils/enum.dart';


class ChangePasswordController extends GetxController {
  Rx<TextEditingController> passOld = TextEditingController().obs;
  Rx<TextEditingController> passNew = TextEditingController().obs;
  Rx<TextEditingController> passNewRe = TextEditingController().obs;
  RxString isCheckNull = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isHidePass = true.obs;
  RxBool isHidePassNew = true.obs;
  RxBool isHidePassNewEn = true.obs;
  DateTime timeNow = DateTime.now();
  RxBool isActive = false.obs;


  void initData() async {
    passOld.value.addListener(() {
      if (passOld.value.text.trim().isNotEmpty &&
          passNew.value.text.trim().isNotEmpty &&
          passNewRe.value.text.trim().isNotEmpty) {
        isActive.value = true;
      } else {
        isActive.value = false;
      }
    });
    passNew.value.addListener(() {
      if (passOld.value.text.trim().isNotEmpty &&
          passNew.value.text.trim().isNotEmpty &&
          passNewRe.value.text.trim().isNotEmpty) {
        isActive.value = true;
      } else {
        isActive.value = false;
      }
    });
    passNewRe.value.addListener(() {
      if (passOld.value.text.trim().isNotEmpty &&
          passNew.value.text.trim().isNotEmpty &&
          passNewRe.value.text.trim().isNotEmpty) {
        isActive.value = true;
      } else {
        isActive.value = false;
      }
    });


  }
  void onInit() async {

    super.onInit();
  }

  changePassWord() async {
    if (passOld.value.text == passNew.value.text) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: TextByNation.getStringByKey('pass_valiate_distinctive'));
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('pass_valiate_distinctive'),
        type: ToastType.WARNING,
      );
      return;
    } else if (passNewRe.value.text != passNew.value.text) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: TextByNation.getStringByKey('pass_valiate_overlap'));
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('pass_valiate_overlap'),
        type: ToastType.ERROR,
      );
      return;
    } else if (passNew.value.text.length < 8) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: TextByNation.getStringByKey('pass_validate'));
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('pass_validate'),
        type: ToastType.ERROR,
      );
      return;
    } else {
      isLoading.value = true;
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert": await Utils.generateMd5(
            Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "userName": await Utils.getStringValueWithKey(Constant.USERNAME),
        "oldPass": Utils.generateMd5(
            Constant.NEXT_PUBLIC_KEY_PASS + passOld.value.text),
        "newPass": Utils.generateMd5(
            Constant.NEXT_PUBLIC_KEY_PASS + passNew.value.text),
      };
      try {
        var data = await APICaller.getInstance()
            .post('v1/Account/change-password', param);
        if (data != null) {
          await Utils.saveStringWithKey(Constant.PASSWORD, passNew.value.text);
          // Utils.showSnackBar(
          //     title: TextByNation.getStringByKey('notification'),
          //     message: TextByNation.getStringByKey('pass_ss'));
          Utils.showToast(
            Get.overlayContext!,
            TextByNation.getStringByKey('pass_ss'),
            type: ToastType.SUCCESS,
          );
          Get.close(1);
        }
      } catch (e) {
        //
        // Utils.showSnackBar(
        //     title: TextByNation.getStringByKey('notification'), message: '$e');
        Utils.showToast(
          Get.overlayContext!,
          '$e',
          type: ToastType.ERROR,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
