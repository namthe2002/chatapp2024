import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Account/Contact.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Service/APICaller.dart';

import '../../Utils/Utils.dart';

class ChatCreateController extends GetxController {
  Rx<TextEditingController> filterController = TextEditingController().obs;
  RxBool isSearch = false.obs;
  RxList<Contact> listContact = <Contact>[].obs;
  RxBool isLoangding = true.obs;
  RxBool hasMore = true.obs;
  int pageSize = 20;
  int page = 1;
  ScrollController scrollController = ScrollController();
  Timer? debounce;
  RxInt roleId = 0.obs;
  RxString keyword = ''.obs;
  String uuidAcount = '';
  @override
  void onInit() async {
    roleId.value = await Utils.getIntValueWithKey(Constant.ROLE_ID);
    uuidAcount = await Utils.getStringValueWithKey(Constant.UUID_USER);
    getFriend();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (hasMore.value) {
          page++;
          getFriend();
        }
      }
    });
    super.onInit();
  }

  Future resetFriend() async {
    isLoangding.value = true;
    page = 1;
    hasMore.value = true;
    listContact.value = await [];
    if (listContact.length == 0) {
      await getFriend();
    }
  }

  Future createRoom(int index) async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "type": 1,
        "ownerUuid": listContact[index].uuid,
      };

      var response = await APICaller.getInstance()
          .post('v1/Chat/create-message-room', param);
      if (response != null) {
        Get.close(1);
        Navigation.navigateTo(page: 'ChatDetail', arguments: {
          'uuid': response['data'], // uuid phòng gọi api tạo phòng trước
          'name': listContact[index].fullName ?? listContact[index].userName,
          'type': 1,
          'ownerUuid': await Utils.getStringValueWithKey(
              Constant.UUID_USER), // uu đăng nhập
          'avatar': listContact[index].avatar ?? ''
        });
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      isLoangding.value = await false;
    }
  }

  Future getFriend() async {
    // chấp nhận
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": await Utils.getStringValueWithKey(Constant.UUID_USER),
        "pageSize": pageSize,
        "page": page,
        "keyword": filterController.value.text
      };

      var response =
          await APICaller.getInstance().post('v1/Member/find-member', param);
      if (response != null) {
        List<dynamic> list = response['items'];
        var listItem =
            list.map((dynamic json) => Contact.fromJson(json)).toList();
        for (Contact constant in listItem) {
          if (constant.uuid != uuidAcount) listContact.add(constant);
        }
        if (listItem.length < pageSize) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      isLoangding.value = await false;
    }
  }
}
