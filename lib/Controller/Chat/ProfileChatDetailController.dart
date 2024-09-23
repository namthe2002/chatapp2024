import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Controller/Chat/ChatCreateController.dart';
import 'package:live_yoko/Controller/Chat/ChatDetailController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Account/Contact.dart';
import 'package:live_yoko/Models/Chat/ChatDetail.dart';
import 'package:live_yoko/Models/Chat/ChatDetailMember.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:html' as html;

import '../../Models/Chat/Chat.dart';
import '../../Utils/enum.dart';

class ProfileChatDetailController extends GetxController {
  RxInt tabIndex = 3.obs;
  final Map<String, Uint8List> thumbnailCache = {};
  RxList<Metadata> linkPreviewList = RxList();
  final Map<String, String> fileTrafficCache = {};
  var selectedChatDetail = Rxn<Chat>();
  String uuidChat = '';
  RxString chatName = ''.obs;
  int chatType = 1;
  RxBool isLoading = true.obs;
  DateTime timeNow = DateTime.now();
  int pageSize = 16;
  int page = 1;
  RxBool hasMoreData = true.obs;
  RxList<ChatDetailMember> memberList = RxList<ChatDetailMember>();
  String ownerUuid = '';
  RxList<ChatDetail> mediaList = RxList<ChatDetail>();
  ScrollController scrollController = ScrollController();
  int roleId = 0;
  String uuidUser = '';
  TextEditingController textSearchController = TextEditingController();
  RxList<Contact> friendList = RxList<Contact>();
  RxBool isFriendLoading = true.obs;
  RxBool hasMoreDataFriend = true.obs;
  ScrollController friendScrollController = ScrollController();
  Timer? _debounce;
  RxBool isEditGroup = false.obs;
  RxString chatAvatar = ''.obs;
  TextEditingController textNameController = TextEditingController();
  int makeFriendState = 0;
  File file = File('');
  String responseFile = '';
  RxInt memberLength = 0.obs;
  List<int> timeList = [0, 1, 7, 15, 30];
  RxList<String> listImage = RxList<String>();
  int autoDeleteData = 0;
  bool isDialogLoading = true;
  RxBool showButton = true.obs;

  // merge từ nhánh q_p
  RxBool isDeleteMember = false.obs;
  RxBool isDeleteConversation = false.obs;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  Rx<ChatDetailMember> adminChat = Rx<ChatDetailMember>(ChatDetailMember());
  bool? isListMemberLocked;
  RxInt tabSelected = 1.obs;
  RxBool isLockMember = false.obs;
  RxInt isGroupAdmin = 0.obs;

  RxList<ChatDetailMember> memberListLocked = RxList<ChatDetailMember>();
  RxInt memberLockedLength = 0.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  void initData() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print(hasMoreData.value);
        linkPreviewList.refresh();
        memberList.refresh();
        if (!isLoading.value && hasMoreData.value) {
          page++;
          if (chatType == 2 && tabIndex.value == 5) {
            getMember();
          } else {
            getMedia();
          }
        }
      }

      if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (showButton.value) {
          showButton.value = false;
        }
      } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!showButton.value) {
          showButton.value = true;
        }
      }
    });
    friendScrollController.addListener(() {
      if (friendScrollController.position.pixels == friendScrollController.position.maxScrollExtent) {
        if (!isFriendLoading.value && hasMoreDataFriend.value) {
          page++;
          getFriend();
        }
      }
    });
    textSearchController.addListener(() {
      onSearchChanged();
    });
    roleId = await Utils.getIntValueWithKey(Constant.ROLE_ID);
    uuidUser = await Utils.getStringValueWithKey(Constant.UUID_USER);
  }

  @override
  void onReady() async {
    super.onReady();

    uuidChat = selectedChatDetail.value?.uuid ?? '';
    chatName.value = selectedChatDetail.value?.ownerName ?? '';
    chatType = selectedChatDetail.value?.type ?? 0;
    ownerUuid = selectedChatDetail.value?.uuid ?? '';
    chatAvatar.value = selectedChatDetail.value?.avatar ?? '';
    // uuidChat = Get.arguments['uuid'];
    // chatName.value = Get.arguments['name'];
    // chatType = Get.arguments['type'];
    // ownerUuid = Get.arguments['ownerUuid'];
    // chatAvatar.value = Get.arguments['avatar'] ?? '';
    tabIndex.value = chatType == 2 ? 5 : 3;
    textNameController.text = chatName.value;
    print('textNameController ${textNameController}');
    await groupInfo();
    if (chatType == 2) {
      isListMemberLocked = false;
      await getMember();
    } else {
      await getMedia();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  bool isLink(String text) {
    RegExp urlRegex = RegExp(
      r'http(s)?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegex.hasMatch(text);
  }

  Future<String?> fetchFileSize(String url) async {
    String? fileSize;
    try {
      http.Response response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        String? contentLength = response.headers['content-length'];
        if (contentLength != null) {
          int bytes = int.parse(contentLength);
          if (bytes < 1024) {
            fileSize = '${bytes.toString()} B';
          } else if (bytes < 1024 * 1024) {
            double kb = bytes / 1024;
            fileSize = '${kb.toStringAsFixed(2)} KB';
          } else if (bytes < 1024 * 1024 * 1024) {
            double mb = bytes / (1024 * 1024);
            fileSize = '${mb.toStringAsFixed(2)} MB';
          } else {
            double gb = bytes / (1024 * 1024 * 1024);
            fileSize = '${gb.toStringAsFixed(2)} GB';
          }
        }
      }
    } catch (e) {
      print('Error fetching file size: $e');
    }
    return fileSize;
  }

  // deleteChat() async {
  //   String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
  //   try {
  //     var param = {
  //       "keyCert":
  //       Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
  //       "time": formattedTime,
  //       "uuid": uuidChat
  //     };
  //     var data =
  //     await APICaller.delete(ApiAddress.delete_conversation, body: param);
  //     if (data != null) {
  //       //Get.close(2);
  //       if (Get.isRegistered<ChatDetailController>()) {
  //         Get.delete<ChatDetailController>();
  //         _listMessageLocal.deleteListMessage([uuidChat]);
  //       }
  //       if (Get.isRegistered<ChatController>()) {
  //         final controllerChat = Get.find<ChatController>();
  //         int index = controllerChat.listChat
  //             .indexWhere((element) => element.uuid! == uuidChat);
  //         if (index != -1) {
  //           controllerChat.listChat.removeAt(index);
  //           _listConversationLocal.deleteConversation(uuidChat);
  //         }
  //       }
  //       Utils.showSnackBar(
  //           title: TextByNation.getStringByKey(KeyByNation.notification),
  //           message: TextByNation.getStringByKey(KeyByNation.delete_message));
  //       Get.delete<ProfileChatDetailController>();
  //     }
  //   } catch (e) {
  //     Utils.showSnackBar(
  //         title: TextByNation.getStringByKey(KeyByNation.notification),
  //         message: '$e');
  //   }
  // }

  String getLink(String text) {
    String link = '';
    RegExp linkRegExp = RegExp(r'http(s)?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
    Iterable<Match> matches = linkRegExp.allMatches(text);

    for (Match match in matches) {
      link = match.group(0)!;
    }
    return link;
  }

  Future<void> saveFile({required String url, required String fileName}) async {
    final status = await Permission.storage.request();
    Directory pathIos = await getApplicationDocumentsDirectory();
    if (status.isGranted) {
      try {
        // // final id = await FlutterDownloader.enqueue(
        //   url: url,
        //   savedDir: Platform.isAndroid
        //       ? '/storage/emulated/0/Download/'
        //       : pathIos.path,
        //   fileName: fileName.replaceAll(' ', '_'),
        // );
      } catch (e) {
        print('$e');
      }
    } else {
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('no_access'),
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('no_access'));
    }
  }

  resetData() async {
    page = 1;
    hasMoreData.value = true;
    memberList.clear();
    mediaList.clear();
    if (chatType == 2 && tabIndex.value == 5) {
      await getMember();
    } else {
      await getMedia();
    }
  }

  resetDataFriend() async {
    page = 1;
    friendList.clear();
    await getFriend();
  }

  onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      resetDataFriend();
    });
  }

  getMember() async {
    try {
      if (page == 1) {
        isLoading.value = true;
      }
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param;
      if (isListMemberLocked == true) {
        param = {
          "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
          "time": formattedTime,
          "pageSize": pageSize,
          "page": page,
          "keyword": "",
          "uuid": ownerUuid,
          "IsLock": 1
        };
      } else {
        param = {
          "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
          "time": formattedTime,
          "pageSize": pageSize,
          "page": page,
          "keyword": "",
          "uuid": ownerUuid
        };
      }
      var data;
      if (isListMemberLocked == true && memberLockedLength.value == 0) {
      } else {
        if (memberList.isNotEmpty && page == 1) {}
        data = await APICaller.getInstance().post('v1/Group/list-member', param);
      }
      debugPrint('---------------------------- $data');
      if (data != null) {
        makeFriendState = data['makeFriendState'];
        isGroupAdmin.value = data['isGroupAdmin'];
        List<dynamic> list = data['items'];

        var listItem = list.map((dynamic json) => ChatDetailMember.fromJson(json)).toList();
        if (listItem.isNotEmpty) {
          var myName = await Utils.getStringValueWithKey(Constant.USERNAME);
          for (var mem in listItem) {
            if (mem.userName == myName) {
              roleId = mem.roleId!;
              break;
            }
          }
          if (adminChat.value.uuid == null) {
            adminChat = ChatDetailMember.fromJson(data['leader']).obs;
          }

          if (isListMemberLocked == true) {
            if (memberListLocked.isEmpty) {
              memberListLocked.addAll(listItem);
            } else {
              for (var item in listItem) {
                for (var it in memberListLocked) {
                  if (it.uuid != item.uuid) {
                    memberListLocked.add(item);
                  }
                }
              }
            }
          } else {
            if (memberList.isEmpty) {
              memberList.addAll(listItem);
            } else {
              for (var item in listItem) {
                for (var it in memberList) {
                  if (it.uuid != item.uuid && item.uuid != adminChat.value.uuid) {
                    memberList.add(item);
                  }
                }
              }
            }
          }
          memberLength.value = data['totalCount'];
          memberLockedLength.value = data['totalBlock'];
          var index = memberList.indexWhere((e) => e.uuid == adminChat.value.uuid);
          if (index != -1) {
            memberList.removeWhere((e) => e.uuid == adminChat.value.uuid);
          }
        } else {
          hasMoreData.value = false;
        }
        if (page == 1) {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(title: 'Error Message: ', message: '$e');
      isLoading.value = false;
    }
  }

  getMedia() async {
    try {
      if (page == 1) {
        isLoading.value = true;
      }
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": page,
        "type": tabIndex.value,
        "uuid": uuidChat
      };
      var data = await APICaller.getInstance().post('v1/Group/list-media', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list.map((dynamic json) => ChatDetail.fromJson(json)).toList();
        if (listItem.isNotEmpty) {
          mediaList.addAll(listItem);

          if (tabIndex.value == 2) {
            linkPreviewList.clear();
            for (ChatDetail link in mediaList) {
              Metadata? _metadata = await AnyLinkPreview.getMetadata(
                link: getLink(link.content!),
              );
              if (_metadata != null) {
                linkPreviewList.add(_metadata);
              }
            }
          }

          if (tabIndex.value == 3) {
            listImage.clear();
            for (ChatDetail media in mediaList) {
              List<dynamic> array = jsonDecode(media.content!);
              for (String link in array) {
                listImage.add(link);
              }
            }
          }
        } else {
          hasMoreData.value = false;
        }
        if (page == 1) {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(title: TextByNation.getStringByKey('error_message'), message: '$e');
      isLoading.value = false;
    }
  }

  deleteMessage() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {"keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime), "time": formattedTime, "uuid": uuidChat};
      var data = await APICaller.getInstance().delete('v1/Chat/delete-message-room', body: param);
      if (data != null) {
        //Get.close(2);
        if (Get.isRegistered<ChatDetailController>()) {
          Get.delete<ChatDetailController>();
        }
        if (Get.isRegistered<ChatController>()) {
          final controllerChat = Get.find<ChatController>();
          int index = controllerChat.listChat.indexWhere((element) => element.uuid! == uuidChat);
          if (index != -1) {
            controllerChat.listChat.removeAt(index);
          }
        }
        Utils.showToast(
          Get.overlayContext!,
          TextByNation.getStringByKey('delete_message'),
          type: ToastType.SUCCESS,
        );
        // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('delete_message'));
        Get.delete<ProfileChatDetailController>();
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  clearMessage() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {"keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime), "time": formattedTime, "uuid": uuidChat};
      var data = await APICaller.getInstance().delete('v1/Chat/delete-history-message-room', body: param);
      if (data != null) {
        //Get.close(2);
        if (Get.isRegistered<ChatDetailController>()) {
          Get.delete<ChatDetailController>();
        }
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().refreshListChat();
        }
        Utils.showToast(
          Get.overlayContext!,
          TextByNation.getStringByKey('delete_message'),
          type: ToastType.SUCCESS,
        );
        // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('delete_message'));
        Get.delete<ProfileChatDetailController>();
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  leaveGroup({String uuid = '', int? index, bool isAddMember = false}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "groupUuid": ownerUuid,
        "newMemberUuid": uuid.isNotEmpty ? uuid : uuidUser,
        "roleId": 0,
        "Type": isAddMember == true ? 1 : 0
      };
      var data = await APICaller.getInstance().post('v1/Group/upsert-group-member', param);
      if (data != null) {
        if (uuid.isNotEmpty) {
          if (!isAddMember) {
            memberList.removeAt(index!);
            memberLength.value--;
            if (Get.isRegistered<ChatDetailController>()) {
              ChatDetailController controller = Get.find<ChatDetailController>();
              controller.memberLength.value--;
            }
          } else {
            Get.close(1);
            resetData();
            memberLength.value++;
            if (Get.isRegistered<ChatDetailController>()) {
              ChatDetailController controller = Get.find<ChatDetailController>();
              controller.memberLength.value++;
            }
          }
        } else {
          //Get.close(2);
          if (Get.isRegistered<ChatDetailController>()) {
            Get.delete<ChatDetailController>();
          }
          if (Get.isRegistered<ChatController>()) {
            final controllerChat = Get.find<ChatController>();
            controllerChat.refreshListChat();
          }

          Utils.showToast(
            Get.overlayContext!,
            TextByNation.getStringByKey('leave_group'),
            type: ToastType.SUCCESS,
          );

          // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('leave_group'));
          Get.delete<ProfileChatDetailController>();
        }
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  addFriend({required String uuid}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": uuid,
      };
      print(param);
      var data = await APICaller.getInstance().post('v1/Friend/request-add-friend', param);
      if (data != null) {
        Utils.showToast(Get.overlayContext!, TextByNation.getStringByKey('friend_sent'), type: ToastType.SUCCESS);
        // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('friend_sent'));
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  changeStateFriend({required int index}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    int status = 0;
    if (memberList[index].canMakeFriend == 0) {
      status = 1;
    }
    try {
      var param = {
        "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": ownerUuid,
        "memberUuid": memberList[index].uuid,
        "state": status
      };
      print(param);
      var data = await APICaller.getInstance().post('v1/Group/change-make-friend-state', param);
      if (data != null) {
        memberList[index].canMakeFriend = status;
        memberList.refresh();
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  getFriend() async {
    Set<String> uuidSet = memberList.map((item) => item.uuid!).toSet();
    try {
      if (page == 1) {
        isFriendLoading.value = true;
      }
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": page,
        "keyword": textSearchController.text
      };
      var data = await APICaller.getInstance().post('v1/Member/find-member', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list.map((dynamic json) => Contact.fromJson(json)).toList();
        if (listItem.isNotEmpty) {
          // List<Contact> listItem2 =
          //     listItem.where((item) => !uuidSet.contains(item.uuid)).toList();
          friendList.addAll(listItem);
        } else {
          hasMoreDataFriend.value = false;
        }
        if (page == 1) {
          isFriendLoading.value = false;
        }
      } else {
        isFriendLoading.value = false;
      }
    } catch (e) {
      Utils.showToast(Get.overlayContext!, '$e', type: ToastType.ERROR);
      Utils.showSnackBar(title: TextByNation.getStringByKey('error_message'), message: '$e');
      isFriendLoading.value = false;
    }
  }

  changeGroupInfo() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": ownerUuid,
        "groupName": textNameController.text,
        "groupAvatar": responseFile.isNotEmpty ? responseFile : chatAvatar.value
      };
      var data = await APICaller.getInstance().post('v1/Group/change-group-info', param);
      if (data != null) {
        chatName.value = textNameController.text;
        chatAvatar.value = chatAvatar.value.isNotEmpty && responseFile.isEmpty
            ? chatAvatar.value
            : responseFile.isNotEmpty
                ? responseFile
                : '';
        if (Get.isRegistered<ChatDetailController>()) {
          ChatDetailController controller = Get.find<ChatDetailController>();
          controller.chatName.value = textNameController.text;
          controller.chatAvatar.value = chatAvatar.value.isNotEmpty && responseFile.isEmpty
              ? chatAvatar.value
              : responseFile.isNotEmpty
                  ? responseFile
                  : '';
        }
        if (Get.isRegistered<ChatController>()) {
          ChatController controller = Get.find<ChatController>();
          int index = controller.listChat.indexWhere((element) => element.uuid! == uuidChat);
          if (index != -1) {
            controller.listChat[index].ownerName = textNameController.text;
            controller.listChat[index].avatar = chatAvatar.value.isNotEmpty && responseFile.isEmpty
                ? chatAvatar.value
                : responseFile.isNotEmpty
                    ? responseFile
                    : '';
            controller.listChat.refresh();
          }
        }
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  getImageFiles({required bool isCamera}) async {
    if (!Get.isRegistered<ProfileChatDetailController>()) {
      Get.put(ProfileChatDetailController());
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
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('file_size'),
        type: ToastType.INFORM,
      );
      // Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('file_size'));
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
        chatAvatar.value = jsonDecode(listItem[0]);
        chatAvatar.refresh();
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

  groupInfo() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {"keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime), "time": formattedTime, "uuid": uuidChat};
    try {
      var response = await APICaller.getInstance().post('v1/Chat/group-info', param);
      if (response != null) {
        memberLength.value = response['data']['memCount'];
        autoDeleteData = response['data']['autoDelete'];
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }

  autoDelete({required int day}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "roomUuid": uuidChat,
      "period": day
    };
    print(param);
    try {
      var response = await APICaller.getInstance().post('v1/Chat/auto-delete-message', param);
      if (response != null) {
        autoDeleteData = day;
      }
    } catch (e) {
      Utils.showToast(
        Get.overlayContext!,
        '$e',
        type: ToastType.ERROR,
      );
    }
  }
}
