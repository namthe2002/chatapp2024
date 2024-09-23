import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Account/Friend.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Utils/enum.dart';

class ManageFriendsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<TextEditingController> filterController = TextEditingController().obs;
  RxBool isSearch = false.obs;
  RxBool hasMore = true.obs;
  RxBool hasMoreSend = true.obs;
  late TabController tabController;
  RxList<Friend> listReceivedFriend = <Friend>[].obs;
  RxList<Friend> listSendFriend = <Friend>[].obs;
  int statusFriend = 2;
  int pageSize = 10;
  int page = 1;
  int pageSend = 1;
  RxBool isLoading = true.obs;
  RxBool isLoadingSend = true.obs;
  ScrollController receivedScroll = ScrollController();
  ScrollController sendScroll = ScrollController();
  Timer? debounce;
  RxString keyword = ''.obs;
  bool isAcceptFriendLoading = true;
  RxInt totalReceived = 0.obs;
  RxInt totalSend = 0.obs;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: this);
    receivedScroll.addListener(() {
      if (receivedScroll.position.maxScrollExtent == receivedScroll.offset) {
        if (hasMore.value) {
          page++;
          getManageFriend(2);
        }
      }
    });
    sendScroll.addListener(() {
      if (sendScroll.position.maxScrollExtent == sendScroll.offset) {
        if (hasMoreSend.value) {
          pageSend++;
          getManageFriend(1);
        }
      }
    });

    await getManageFriend(2); // yêu cầu nhận được
    await getManageFriend(1); // yêu cầu gửi đi

    tabController.addListener(() {
      if (tabController.index == 0) {
        statusFriend = 2;
      } else {
        statusFriend = 1;
        // if (listSendFriend.length == 0) {
        //   getManageFriend(0);
        // }
      }
    });
    super.onInit();
  }

  refreshData() async {
    if (statusFriend == 2) {
      page = 1;
      hasMore.value = true;
      listReceivedFriend.value = await [];
    } else {
      pageSend = 1;
      hasMoreSend.value = true;
      listSendFriend.value = await [];
    }

    await getManageFriend(statusFriend);
  }

  Future getManageFriend(int statusFriend) async {
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": statusFriend == 2 ? page : pageSend,
        "keyword": filterController.value.text,
        "status": statusFriend
      };

      var response =
          await APICaller.getInstance().post('v1/Friend/find-friend', param);
      if (response != null) {
        List<dynamic> list = response['items'];
        var listItem =
            list.map((dynamic json) => Friend.fromJson(json)).toList();

        if (statusFriend == 2) {
          totalReceived.value = response['count'];
          listReceivedFriend.addAll(listItem);
          if (listReceivedFriend.length >= totalReceived.value) {
            hasMore.value = false;
          }
        } else {
          totalSend.value = response['count'];
          listSendFriend.addAll(listItem);
          if (listSendFriend.length >= totalSend.value) {
            hasMoreSend.value = false;
          }
        }
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      if (statusFriend == 2) {
        isLoading.value = await false;
      } else {
        isLoadingSend.value = await false;
      }
    }
  }

  Future acceptFriend(int index) async {
    // chấp nhận
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": listReceivedFriend[index].friendUserName,
      };

      var response =
          await APICaller.getInstance().post('v1/Friend/accept-friend', param);
      if (response != null) {

        Utils.showToast(
          Get.overlayContext!,
          TextByNation.getStringByKey('add_friend_ss') +
              ' ' +
              listReceivedFriend[index].friendFullName.toString(),
          type: ToastType.SUCCESS,
        );
        // Utils.showSnackBar(
        //     title: TextByNation.getStringByKey('notification'),
        //     message: TextByNation.getStringByKey('add_friend_ss') +
        //         ' ' +
        //         listReceivedFriend[index].friendFullName.toString());
        listReceivedFriend.removeAt(index);
        listReceivedFriend.refresh();
      }
    } catch (e) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'), message: '$e');
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  Future cancelFriend(int index, bool isRequired) async {
    // từ chối
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": isRequired == true
            ? listReceivedFriend[index].friendUserName
            : listSendFriend[index].friendUserName,
        "type": 1 // hủy lời mời // từ chối kết bạn
      };

      var response =
          await APICaller.getInstance().post('v1/Friend/refuse-friend', param);

      if (response != null) {
        if (isRequired == true) {
          // Utils.showSnackBar(
          //     title: TextByNation.getStringByKey('notification'),
          //     message: TextByNation.getStringByKey('no_add_friend') +
          //         ' ' +
          //         listReceivedFriend[index].friendFullName.toString());

          Utils.showToast(
            Get.overlayContext!,
            TextByNation.getStringByKey('no_add_friend') +
                ' ' +
                listReceivedFriend[index].friendFullName.toString(),
            type: ToastType.ERROR,
          );
          listReceivedFriend.removeAt(index);
          listReceivedFriend.refresh();
        } else {


          Utils.showToast(
            Get.overlayContext!,
            TextByNation.getStringByKey('cancel_friend_send') +
                ' ' +
                listSendFriend[index].friendFullName.toString(),
            type: ToastType.INFORM,
          );
          // Utils.showSnackBar(
          //     title: TextByNation.getStringByKey('notification'),
          //     message: TextByNation.getStringByKey('cancel_friend_send') +
          //         ' ' +
          //         listSendFriend[index].friendFullName.toString());
          listSendFriend.removeAt(index);
          listSendFriend.refresh();
        }
      }
    } catch (e) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'), message: '$e');
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.INFORM,
      );
    }
  }
}
