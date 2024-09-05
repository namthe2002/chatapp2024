import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Account/Account.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';

class AdminAccountController extends GetxController {
  Rx<TextEditingController> filterController = TextEditingController().obs;
  RxBool isSearch = false.obs;
  RxBool isLoangding = true.obs;
  RxBool hasMore = true.obs;
  int pageSize = 50;
  int page = 1;
  ScrollController scrollController = ScrollController();
  RxList<Account> listContact = <Account>[].obs;
  Timer? debounce;
  RxInt roleId = 0.obs;
  List<String> listPosition = [
    TextByNation.getStringByKey('user'),
    TextByNation.getStringByKey('leader'),
    TextByNation.getStringByKey('admin')
  ];
  List<String> listStatus = [
    TextByNation.getStringByKey('status_active'),
    TextByNation.getStringByKey('status_deactive')
  ];
  RxInt selectPosition = (0).obs;
  RxInt selectStatus = (0).obs;
  RxBool isBack = false.obs;
  Rx<String> keyword = ''.obs;

  @override
  void onInit() async {
    roleId.value = await Utils.getIntValueWithKey(Constant.ROLE_ID);
    getFriend(0, 1);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (hasMore.value) {
          page++;
          getFriend(selectPosition.value, selectStatus.value + 1);
        }
      }
    });
    super.onInit();
  }

  Future resetFriend() async {
    isLoangding.value = true;
    page = 1;
    hasMore.value = true;
    listContact.clear();
    await getFriend(selectPosition.value, selectStatus.value + 1);
  }

  Future getFriend(int roleId, int status) async {
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
        "roleId": roleId,
        "lockState": status - 1 == 0 ? 1 : 0
      };

      var response =
          await APICaller.getInstance().post('v1/Account/list-account', param);
      if (response != null) {
        List<dynamic> list = response['items'];
        var listItem =
            list.map((dynamic json) => Account.fromJson(json)).toList();
        listContact.addAll(listItem);
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
