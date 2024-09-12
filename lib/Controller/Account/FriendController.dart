import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Controller/Chat/ChatDetailController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Account/Contact.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Models/Chat/Chat.dart';
import '../Chat/ProfileChatDetailController.dart';

class FriendController extends GetxController {
  Rx<TextEditingController> filterController = TextEditingController().obs;
  RxBool isSearch = false.obs;
  RxBool isLoangding = true.obs;
  RxBool hasMore = true.obs;
  int pageSize = 20;
  int page = 1;
  ScrollController scrollController = ScrollController();
  RxList<Contact> listContact = <Contact>[].obs;
  Timer? debounce;
  RxInt roleId = 0.obs;
  Rx<String> keyword = ''.obs;
  String uuidAcount = '';
  bool requestDone = true;
  Rx<int> isSelectedButton = 1.obs;
  var selectedChatDetail = Chat();

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
        "ownerUuid": listContact[index].uuid
      };
      var response = await APICaller.getInstance()
          .post('v1/Chat/create-message-room', param);
      if (response != null) {

        selectedChatDetail.uuid = response['data'];
        selectedChatDetail.ownerUuid =
            await Utils.getStringValueWithKey(Constant.UUID_USER);
        selectedChatDetail.ownerName =
            listContact[index].fullName ?? listContact[index].userName ?? '';
        selectedChatDetail.type = 1;
        selectedChatDetail.avatar = listContact[index].avatar ?? '';
        Get.delete<ChatDetailController>();
        Get.delete<ProfileChatDetailController>();
        Get.find<ChatController>().selectChatItem(selectedChatDetail);
        Get.appUpdate();
        // Get.put(ChatController()).selectedChatItem = selectedChatDetail;
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      isLoangding.value = false;
    }
  }

  Future getFriend() async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": page,
        "keyword": filterController.value.text
        // "uuid": await Utils.getStringValueWithKey(Constant.UUID_USER),

      };

      var response =
          await APICaller.getInstance().post('v1/Member/find-member', param);

      print('checkresponse ${response}');
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
      isLoangding.value = false;
    }
  }

  Future cancelFriend(int index) async {
    // từ chối
    requestDone = false;
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": listContact[index].userName,
        "type": 2 // hủy kb
      };

      var response =
          await APICaller.getInstance().post('v1/Friend/refuse-friend', param);
      if (response != null) {
        listContact.removeAt(index);
        listContact.refresh();
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('cancal_friend_ss'));
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      requestDone = true;
    }
  }
}
