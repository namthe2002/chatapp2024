import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Account/Contact.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';
import "dart:html" as html;
import '../../Navigation/RouteDefine.dart';
import '../../Utils/enum.dart';
import '../../View/Chat/home_chat.dart';

class GroupCreateController extends GetxController {
  Rx<TextEditingController> filterController = TextEditingController().obs;
  RxList<Contact> selectedItems = <Contact>[].obs;
  RxBool isSearch = false.obs;
  RxList<Contact> listContact = <Contact>[].obs;
  RxBool isLoangding = true.obs;
  RxBool hasMore = true.obs;
  int pageSize = 20;
  int page = 1;
  ScrollController scrollController = ScrollController();
  Timer? debounce;
  Rx<File> imageAvatar = File('').obs;
  Rx<TextEditingController> filterControllerName = TextEditingController(text: '').obs;
  List<String> itemList = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  RxString keyword = ''.obs;
  DateTime timeNow = DateTime.now();
  List<int> listTime = [0, 1, 7, 15, 30];
  RxInt selectTimeDelete = 0.obs;
  RxInt selectDayOff = 0.obs;
  RxString avatarUser = ''.obs;
  String uuidAcount = '';
  RxBool isClick = false.obs;

  @override
  void initData() async {
    uuidAcount = await Utils.getStringValueWithKey(Constant.UUID_USER);
    getFriend();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        if (hasMore.value) {
          page++;
          getFriend();
        }
      }
    });
  }

  void onInit() async {
    // uuidAcount = await Utils.getStringValueWithKey(Constant.UUID_USER);
    // getFriend();
    // scrollController.addListener(() {
    //   if (scrollController.position.maxScrollExtent ==
    //       scrollController.offset) {
    //     if (hasMore.value) {
    //       page++;
    //       getFriend();
    //     }
    //   }
    // });
    super.onInit();
  }

  bool isUuidInSelectedItems(String uuid) {
    return selectedItems.map((item) => item.uuid).contains(uuid);
  }

  getImageFiles({required bool isCamera}) async {
    if (!Get.isRegistered<GroupCreateController>()) {
      Get.put(GroupCreateController());
    }
    final List<html.File>? images = await ImagePickerWeb.getMultiImagesAsFile();
    if (images != null && images.isNotEmpty) {
      List<html.File> fileData = [];
      for (var img in images) {
        fileData.add(img);
      }
      String type = 'Image';
      await pushFileWeb(type: type == 'Image' || type == 'Video' ? 1 : 4, fileData: fileData);
    } else {
      // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('file_size'));
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('file_size'),
        type: ToastType.INFORM,
      );
    }
  }

  pushFileWeb({required int type, required List<html.File> fileData}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now());
    try {
      var data = await APICaller.getInstance().putFilesWeb(
        endpoint: 'v1/Upload/upload-image',
        fileData: fileData,
        type: type,
        keyCert: Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        time: formattedTime,
      );

      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list.map((dynamic json) => '"$json"').toList();
        avatarUser.value = jsonDecode(listItem[0]);
        avatarUser.refresh();
      } else {
        Utils.showToast(
          Get.overlayContext!,
          'Upload file failed',
          type: ToastType.ERROR,
        );
        // Utils.showSnackBar(title: TextByNation.getStringByKey('error_file'), message: 'Upload file failed');
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(title: TextByNation.getStringByKey('error_file'), message: '$e');
    }
  }

  Future createGroup() async {
    if (filterControllerName.value.text.trim() != '') {
      isClick.value = true;
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      try {
        List<String> listGrounpUuid = [];
        selectedItems.forEach((element) {
          listGrounpUuid.add(element.uuid!);
        });
        // listGrounpUuid.add(uuidAcount); // add chính mình
        var param = {
          "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
          "time": formattedTime,
          "groupName": filterControllerName.value.text,
          "memberUuids": listGrounpUuid,
          "groupAvatar": avatarUser.value == "" ? "" : avatarUser.value,
        };

        var response = await APICaller.getInstance().post('v1/Group/create-group', param);
        if (response != null) {
          // Get.close(3);

          // await Navigation.navigateTo(page: 'ChatDetail', arguments: {
          //   'uuid': response['data']
          //       ['roomUuid'], // uuid phòng gọi api tạo phòng trước
          //   'name': filterControllerName.value.text,
          //   'type': 2,
          //   'ownerUuid': response['data']['ownerUuid'],
          //   'avatar': avatarUser.value == ""
          //       ? ""
          //       : avatarUser.value, // chưa có avatar có thì truyền sang  chat
          //   'lastMsgLineUuid': ''
          // });
          //
          Get.find<ChatController>().update();
          Get.find<ChatController>().refresh();
          Get.find<ChatController>().updateFeature(widget: null);
          Get.find<ChatController>().refresh();
          if (Get.isRegistered<ChatController>()) {
            var controller = await Get.find<ChatController>();
            controller.isUnPin.value = await true;
            await controller.refreshListChat();
          }
          // goto new group
        }
      } catch (e) {
        Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );} finally {
        isClick.value = await false;
        // isLoangding.value = false;
      }
    } else {
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('error_name'),
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('error_name'));
    }
  }

  Future resetFriend() async {
    isLoangding.value = true;
    page = 1;
    hasMore.value = true;
    listContact.clear();
    await getFriend();
  }

  Future createGroundStep2() async {
    await Navigation.navigateTo(page: RouteDefine.groupCreateStep2);
  }

  Future getFriend() async {
    // chấp nhận
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": await Utils.getStringValueWithKey(Constant.UUID_USER),
        "pageSize": pageSize,
        "page": page,
        "keyword": filterController.value.text
      };

      var response = await APICaller.getInstance().post('v1/Member/find-member', param);
      if (response != null) {
        List<dynamic> list = response['items'];
        var listItem = list.map((dynamic json) => Contact.fromJson(json)).toList();
        for (Contact constant in listItem) {
          if (constant.uuid != uuidAcount) listContact.add(constant);
        }
        listContact.refresh();
        selectedItems.refresh();

        print(listContact.length.toString() + 'jasdjsajs');
        print(selectedItems.length.toString() + 'jasdjsajs');
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
    } finally {
      isLoangding.value = false;
    }
  }
}
