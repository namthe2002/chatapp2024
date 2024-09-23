import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Models/Chat/Chat.dart';
import 'package:live_yoko/Models/Chat/ChatDetail.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Service/SocketManager.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Utils/enum.dart';

class SearchChatController extends GetxController {
  Rx<TextEditingController> filterController = TextEditingController().obs;
  RxBool isSearch = false.obs;
  RxList<Chat> listUserRecent = <Chat>[].obs;
  final ScrollController scrollController = ScrollController();
  int pageSize = 20;
  int page = 1;
  RxList<Chat> listChat = <Chat>[].obs;
  RxBool hasMore = true.obs;
  Rx<bool> isLoading = true.obs;
  Timer? debounce;
  ChatDetail forward = ChatDetail();
  RxBool isLoadState = true.obs;

  @override
  void onInit() async {
    listUserRecent.value = await Utils.getListFromSharedPreferences();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (hasMore.value) {
          page++;
          getSearchChat();
        }
      }
    });
    super.onInit();
  }


  @override
  void onReady() {
    super.onReady();
    if (Get.arguments != null) {
      forward = Get.arguments;
    }
    isLoadState.value = false;
  }

  refreshData() async {
    isLoading.value = await true;
    page = await 1;
    hasMore.value = await true;
    listChat.clear();
    await getSearchChat();
  }

  Future getSearchChat() async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": page,
        "keyword": filterController.value.text,
        "type": 1
      };

      var response =
          await APICaller.getInstance().post('v1/Chat/message-room', param);
      if (response != null) {
        List<dynamic> list = response['items'];
        var listItem = list.map((dynamic json) => Chat.fromJson(json)).toList();
        listChat.addAll(listItem);
        if (listItem.length < pageSize) {
          hasMore.value = false;
        }
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(title: 'Thông báo', message: '$e');
    } finally {
      isLoading.value = await false;
    }
  }

  forwardMessage({required String uuid}) async {
    await SocketManager().forwardMessage(
      roomUuid: uuid,
      msgLineUuid: forward.uuid!
    );
    Navigation.goBack();
  }
}
