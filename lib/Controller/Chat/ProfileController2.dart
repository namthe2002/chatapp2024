// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:any_link_preview/any_link_preview.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// // import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// // import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class ProfileChatDetailController extends BaseController {
//   RxInt tabIndex = 3.obs;
//   RxInt tabSelected = 1.obs;
//   final Map<String, Uint8List> thumbnailCache = {};
//   RxList<Metadata> linkPreviewList = RxList();
//   final Map<String, String> fileTrafficCache = {};
//   String uuidChat = '';
//   RxString chatName = ''.obs;
//   int chatType = 1;
//   RxBool isLoading = true.obs;
//   RxBool isDeleteMember = false.obs;
//   RxBool isLockMember = false.obs;
//   DateTime timeNow = DateTime.now();
//   int pageSize = 16;
//   int page = 1;
//   RxBool hasMoreData = true.obs;
//   Rx<ChatDetailMember> adminChat = Rx<ChatDetailMember>(ChatDetailMember());
//   RxList<ChatDetailMember> memberList = RxList<ChatDetailMember>();
//   RxList<ChatDetailMember> memberListLocked = RxList<ChatDetailMember>();
//   String ownerUuid = '';
//   RxList<ChatDetail> mediaList = RxList<ChatDetail>();
//   ScrollController scrollController = ScrollController();
//   int roleId = 0;
//   String uuidUser = '';
//   TextEditingController textSearchController = TextEditingController();
//   RxList<ChatDetailMember> friendList = RxList<ChatDetailMember>();
//   RxList<ChatDetailMember> listMemberSelected = RxList<ChatDetailMember>();
//   RxBool isFriendLoading = true.obs;
//   RxBool hasMoreDataFriend = true.obs;
//   ScrollController friendScrollController = ScrollController();
//   Timer? _debounce;
//   // RxBool isEditGroup = false.obs;
//   RxString chatAvatar = ''.obs;
//   TextEditingController textNameController = TextEditingController();
//   int makeFriendState = 0;
//   RxInt isGroupAdmin = 0.obs;
//   File file = File('');
//   String responseFile = '';
//   RxInt memberLength = 0.obs;
//   RxInt memberLockedLength = 0.obs;
//   List<int> timeList = [0, 1, 7, 15, 30];
//   RxList<String> listImage = RxList<String>();
//   int autoDeleteData = 0;
//   bool isDialogLoading = true;
//   RxBool showButton = true.obs;
//   RxBool isDeleteConversation = false.obs;
//   RxBool isChangeTypeKeyboard = false.obs;
//   GlobalKey<FormState> formState = GlobalKey<FormState>();
//   bool? isListMemberLocked;
//
//   final ListConversationLocal _listConversationLocal = ListConversationLocal();
//   final ListMessageLocal _listMessageLocal = ListMessageLocal();
//
//   @override
//   void onInit() async {
//     super.onInit();
//     scrollController.addListener(_listenLoadMoreProfileChat);
//     friendScrollController.addListener(_listenLoadMoreAddMember);
//     textSearchController.addListener(() => onSearchChanged());
//     roleId = await Utils.getIntValueWithKey(Constant.ROLE_ID);
//     uuidUser = await Utils.getStringValueWithKey(Constant.UUID_USER);
//   }
//
//   @override
//   void onReady() async {
//     super.onReady();
//     uuidChat = Get.arguments['uuid'];
//     chatName.value = Get.arguments['name'];
//     textNameController.text = chatName.value;
//     chatType = Get.arguments['type'];
//     ownerUuid = Get.arguments['ownerUuid'];
//     chatAvatar.value = Get.arguments['avatar'] ?? '';
//     autoDeleteData = Get.arguments['autoDeleteData'];
//     tabIndex.value = chatType == 2 ? 5 : 3;
//     // await groupInfo();
//     if (chatType == 2) {
//       isListMemberLocked = false;
//       await getMember();
//     } else {
//       await getMedia();
//     }
//   }
//
//   _listenLoadMoreProfileChat() {
//     if (scrollController.position.pixels ==
//         scrollController.position.maxScrollExtent) {
//       debugPrint(hasMoreData.value.toString());
//       linkPreviewList.refresh();
//       if (!isLoading.value && hasMoreData.value) {
//         page++;
//         if (chatType == 2 && tabIndex.value == 5) {
//           getMember();
//         } else {
//           getMedia();
//         }
//       }
//     }
//
//     if (scrollController.position.userScrollDirection ==
//         ScrollDirection.reverse) {
//       if (showButton.value) {
//         showButton.value = false;
//       }
//     } else if (scrollController.position.userScrollDirection ==
//         ScrollDirection.forward) {
//       if (!showButton.value) {
//         showButton.value = true;
//       }
//     }
//   }
//
//   _listenLoadMoreAddMember() {
//     if (friendScrollController.position.pixels ==
//         friendScrollController.position.maxScrollExtent) {
//       if (!isFriendLoading.value && hasMoreDataFriend.value) {
//         page++;
//         getFriend();
//       }
//     }
//   }
//
//   @override
//   void onClose() async {
//     scrollController.removeListener(_listenLoadMoreProfileChat);
//     friendScrollController.removeListener(_listenLoadMoreAddMember);
//     textSearchController.removeListener(onSearchChanged);
//     textNameController.dispose();
//     textSearchController.dispose();
//     super.onClose();
//   }
//
//   bool isLink(String text) {
//     RegExp urlRegex = RegExp(
//       r'http(s)?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
//       caseSensitive: false,
//       multiLine: false,
//     );
//     return urlRegex.hasMatch(text);
//   }
//
//   Future<String?> fetchFileSize(String url) async {
//     String? fileSize;
//     try {
//       http.Response response = await http.head(Uri.parse(url));
//       if (response.statusCode == 200) {
//         String? contentLength = response.headers['content-length'];
//         if (contentLength != null) {
//           int bytes = int.parse(contentLength);
//           if (bytes < 1024) {
//             fileSize = '${bytes.toString()} B';
//           } else if (bytes < 1024 * 1024) {
//             double kb = bytes / 1024;
//             fileSize = '${kb.toStringAsFixed(2)} KB';
//           } else if (bytes < 1024 * 1024 * 1024) {
//             double mb = bytes / (1024 * 1024);
//             fileSize = '${mb.toStringAsFixed(2)} MB';
//           } else {
//             double gb = bytes / (1024 * 1024 * 1024);
//             fileSize = '${gb.toStringAsFixed(2)} GB';
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('Error fetching file size: $e');
//     }
//     return fileSize;
//   }
//
//   String getLink(String text) {
//     String link = '';
//     RegExp linkRegExp = RegExp(
//         r'http(s)?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
//     Iterable<Match> matches = linkRegExp.allMatches(text);
//
//     for (Match match in matches) {
//       link = match.group(0)!;
//     }
//     return link;
//   }
//
//   Future<void> saveFile({required String url, required String fileName}) async {
//     final status = await Permission.storage.request();
//     // Directory pathIos = await getApplicationDocumentsDirectory();
//     if (status.isGranted) {
//       try {
//         // final id = await FlutterDownloader.enqueue(
//         //   url: url,
//         //   savedDir: Platform.isAndroid
//         //       ? '/storage/emulated/0/Download/'
//         //       : pathIos.path,
//         //   fileName: fileName.replaceAll(' ', '_'),
//         // );
//       } catch (e) {
//         debugPrint('$e');
//       }
//     } else {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: TextByNation.getStringByKey(KeyByNation.no_access));
//     }
//   }
//
//   resetData() async {
//     page = 1;
//     hasMoreData.value = true;
//     mediaList.clear();
//     if (chatType == 2 && tabIndex.value == 5) {
//       isListMemberLocked = false;
//       await getMember();
//     } else {
//       await getMedia();
//     }
//   }
//
//   resetDataFriend() async {
//     page = 1;
//     await getFriend();
//   }
//
//   onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       resetDataFriend();
//     });
//   }
//
//   getMember() async {
//     try {
//       if (page == 1) {
//         isLoading.value = true;
//       }
//       String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//       var param;
//       if (isListMemberLocked == true) {
//         param = {
//           "keyCert":
//           Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//           "time": formattedTime,
//           "pageSize": pageSize,
//           "page": page,
//           "keyword": "",
//           "uuid": ownerUuid,
//           "IsLock": 1
//         };
//       } else {
//         param = {
//           "keyCert":
//           Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//           "time": formattedTime,
//           "pageSize": pageSize,
//           "page": page,
//           "keyword": "",
//           "uuid": ownerUuid
//         };
//       }
//       var data;
//       if (isListMemberLocked == true && memberLockedLength.value == 0) {
//       } else {
//         if (memberList.isNotEmpty && page == 1) {}
//         data = await APICaller.post(ApiAddress.list_member, param);
//       }
//       debugPrint('---------------------------- $data');
//       if (data != null) {
//         makeFriendState = data['makeFriendState'];
//         isGroupAdmin.value = data['isGroupAdmin'];
//         List<dynamic> list = data['items'];
//
//         var listItem = list
//             .map((dynamic json) => ChatDetailMember.fromJson(json))
//             .toList();
//         if (listItem.isNotEmpty) {
//           var myName = await Utils.getStringValueWithKey(Constant.USERNAME);
//           for (var mem in listItem) {
//             if (mem.userName == myName) {
//               roleId = mem.roleId!;
//               break;
//             }
//           }
//           if (adminChat.value.uuid == null) {
//             adminChat = ChatDetailMember.fromJson(data['leader']).obs;
//           }
//
//           if (isListMemberLocked == true) {
//             if (memberListLocked.isEmpty) {
//               memberListLocked.addAll(listItem);
//             } else {
//               for (var item in listItem) {
//                 for (var it in memberListLocked) {
//                   if (it.uuid != item.uuid) {
//                     memberListLocked.add(item);
//                   }
//                 }
//               }
//             }
//           } else {
//             if (memberList.isEmpty) {
//               memberList.addAll(listItem);
//             } else {
//               for (var item in listItem) {
//                 for (var it in memberList) {
//                   if (it.uuid != item.uuid &&
//                       item.uuid != adminChat.value.uuid) {
//                     memberList.add(item);
//                   }
//                 }
//               }
//             }
//           }
//           memberLength.value = data['totalCount'];
//           memberLockedLength.value = data['totalBlock'];
//           var index =
//           memberList.indexWhere((e) => e.uuid == adminChat.value.uuid);
//           if (index != -1) {
//             memberList.removeWhere((e) => e.uuid == adminChat.value.uuid);
//           }
//         } else {
//           hasMoreData.value = false;
//         }
//         if (page == 1) {
//           isLoading.value = false;
//         }
//       } else {
//         isLoading.value = false;
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.error_message),
//           message: '$e');
//       isLoading.value = false;
//     }
//   }
//
//   getMedia() async {
//     try {
//       if (page == 1) {
//         isLoading.value = true;
//       }
//       String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "pageSize": pageSize,
//         "page": page,
//         "type": tabIndex.value,
//         "uuid": uuidChat
//       };
//
//       var data = await APICaller.post(ApiAddress.list_media, param);
//       if (data != null) {
//         List<dynamic> list = data['items'];
//         var listItem =
//         list.map((dynamic json) => ChatDetail.fromJson(json)).toList();
//         if (listItem.isNotEmpty) {
//           mediaList.addAll(listItem);
//
//           if (tabIndex.value == 2) {
//             for (ChatDetail link in mediaList) {
//               if (!linkPreviewList.value.any((e) => e.url == link.content)) {
//                 Metadata? metadata = await AnyLinkPreview.getMetadata(
//                     link: getLink(link.content!));
//                 if (metadata != null) {
//                   linkPreviewList.add(metadata);
//                 } else {
//                   var meta = Metadata();
//                   meta.url = link.content;
//                   linkPreviewList.add(meta);
//                 }
//               }
//             }
//           }
//
//           if (tabIndex.value == 3) {
//             // listImage.clear();
//             for (ChatDetail media in mediaList) {
//               List<dynamic> array = jsonDecode(media.content!);
//               for (String link in array) {
//                 if (!listImage.contains(link)) {
//                   listImage.add(link);
//                 }
//               }
//             }
//           }
//         } else {
//           hasMoreData.value = false;
//         }
//         if (page == 1) {
//           isLoading.value = false;
//         }
//       } else {
//         isLoading.value = false;
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.error_message),
//           message: '$e');
//       isLoading.value = false;
//     }
//   }
//
//   deleteChat() async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     try {
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "uuid": uuidChat
//       };
//       var data =
//       await APICaller.delete(ApiAddress.delete_conversation, body: param);
//       if (data != null) {
//         //Get.close(2);
//         if (Get.isRegistered<ChatDetailController>()) {
//           Get.delete<ChatDetailController>();
//           _listMessageLocal.deleteListMessage([uuidChat]);
//         }
//         if (Get.isRegistered<ChatController>()) {
//           final controllerChat = Get.find<ChatController>();
//           int index = controllerChat.listChat
//               .indexWhere((element) => element.uuid! == uuidChat);
//           if (index != -1) {
//             controllerChat.listChat.removeAt(index);
//             _listConversationLocal.deleteConversation(uuidChat);
//           }
//         }
//         Utils.showSnackBar(
//             title: TextByNation.getStringByKey(KeyByNation.notification),
//             message: TextByNation.getStringByKey(KeyByNation.delete_message));
//         Get.delete<ProfileChatDetailController>();
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
//
//   clearMessage() async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     try {
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "uuid": uuidChat
//       };
//       var data = await APICaller.delete(ApiAddress.delete_history_conversation,
//           body: param);
//       if (data != null) {
//         mediaList.clear();
//         mediaList.refresh();
//         //Get.close(2);
//         if (Get.isRegistered<ChatDetailController>()) {
//           var controller = Get.find<ChatDetailController>();
//           controller.chatList.clear();
//           controller.chatList.refresh();
//           _listMessageLocal.deleteListMessage([uuidChat]);
//         }
//         if (Get.isRegistered<ChatController>()) {
//           Get.find<ChatController>().refreshListChat();
//         }
//         // await _listConversationLocal.updateNewMessageConversation(ChatDetail(
//         //   type: 1,
//         //   userSent: null,
//         //
//         // ));
//         Utils.showSnackBar(
//             title: TextByNation.getStringByKey(KeyByNation.notification),
//             message: TextByNation.getStringByKey(KeyByNation.delete_message));
//         Get.delete<ProfileChatDetailController>();
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
//
//   leaveGroup({String uuid = '', int? index}) async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     try {
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "groupUuid": ownerUuid,
//         "newMemberUuid": uuid.isNotEmpty ? uuid : uuidUser,
//         "roleId": 0,
//         "Type": 0
//       };
//       var data = await APICaller.post(ApiAddress.upsert_group_member, param);
//       if (data != null) {
//         _listConversationLocal.deleteConversation(uuidChat);
//         if (uuid.isNotEmpty) {
//           memberList.removeAt(index!);
//           memberLength.value--;
//           if (Get.isRegistered<ChatDetailController>()) {
//             ChatDetailController controller = Get.find<ChatDetailController>();
//             controller.memberLength.value--;
//           }
//         } else {
//           //Get.close(2);
//           if (Get.isRegistered<ChatDetailController>()) {
//             Get.delete<ChatDetailController>();
//           }
//           if (Get.isRegistered<ChatController>()) {
//             final controllerChat = Get.find<ChatController>();
//             controllerChat.refreshListChat();
//           }
//           Utils.showSnackBar(
//               title: TextByNation.getStringByKey(KeyByNation.notification),
//               message: TextByNation.getStringByKey(KeyByNation.leave_group));
//           Get.delete<ProfileChatDetailController>();
//         }
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
//
//   Future addMemberGroup() async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     try {
//       for (var item in listMemberSelected.value) {
//         var param = {
//           "keyCert":
//           Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//           "time": formattedTime,
//           "groupUuid": ownerUuid,
//           "newMemberUuid": item.uuid,
//           "roleId": 0,
//           "Type": 1
//         };
//         var data = await APICaller.post(ApiAddress.upsert_group_member, param);
//         if (data != null) {
//           memberLength.value++;
//           memberList.add(item);
//         }
//       }
//       if (Get.isRegistered<ChatDetailController>()) {
//         ChatDetailController controller = Get.find<ChatDetailController>();
//         controller.memberLength.value = memberLength.value;
//       }
//       memberList.refresh();
//       listMemberSelected.clear();
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
//
//   addFriend({required String uuid}) async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     try {
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "uuid": uuid,
//       };
//       debugPrint(param.toString());
//       var data = await APICaller.post(ApiAddress.request_add_friend, param);
//       if (data != null) {
//         Utils.showSnackBar(
//             title: TextByNation.getStringByKey(KeyByNation.notification),
//             message: TextByNation.getStringByKey(KeyByNation.friend_sent));
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
//
//   Future<int> changeStateFriend({required int index}) async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     int status = 0;
//     if (memberList[index].canMakeFriend == 0) {
//       status = 1;
//     }
//     try {
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "uuid": ownerUuid,
//         "memberUuid": memberList[index].uuid,
//         "state": status
//       };
//       debugPrint(param.toString());
//       await APICaller.post(ApiAddress.change_make_friend_state, param);
//       memberList[index].canMakeFriend = status;
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//     return status;
//   }
//
//   getFriend() async {
//     // Set<String> uuidSet = memberList.map((item) => item.uuid!).toSet();
//     try {
//       if (page == 1) {
//         isFriendLoading.value = true;
//       }
//       String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "pageSize": pageSize,
//         "page": page,
//         "keyword": textSearchController.text
//       };
//       var data = await APICaller.post(ApiAddress.find_member, param);
//       if (data != null) {
//         List<dynamic> list = data['items'];
//         var listItem = list
//             .map((dynamic json) => ChatDetailMember.fromJson(json))
//             .toList();
//         if (listItem.isNotEmpty) {
//           var list = listItem;
//           if (memberList.isNotEmpty) {
//             for (var item in memberList.value) {
//               if (list.indexWhere((e) => e.uuid == item.uuid) != -1) {
//                 list.removeWhere((e) => e.uuid == item.uuid);
//               }
//             }
//           }
//           if (list.isNotEmpty) {
//             if (friendList.isEmpty) {
//               friendList.value.addAll(list);
//             }
//             for (var item in list) {
//               if (!friendList.value.contains(item.uuid)) {
//                 friendList.value.add(item);
//               }
//             }
//           }
//         } else {
//           hasMoreDataFriend.value = false;
//         }
//         if (page == 1) {
//           isFriendLoading.value = false;
//         }
//       } else {
//         isFriendLoading.value = false;
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.error_message),
//           message: '$e');
//       isFriendLoading.value = false;
//     }
//   }
//
//   changeGroupInfo() async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     try {
//       var param = {
//         "keyCert":
//         Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//         "time": formattedTime,
//         "uuid": ownerUuid,
//         "groupName": textNameController.text,
//         "groupAvatar": responseFile.isNotEmpty ? responseFile : chatAvatar.value
//       };
//       var data = await APICaller.post(ApiAddress.change_group_info, param);
//       if (data != null) {
//         chatName.value = textNameController.text;
//         chatAvatar.value = chatAvatar.value.isNotEmpty && responseFile.isEmpty
//             ? chatAvatar.value
//             : responseFile.isNotEmpty
//             ? responseFile
//             : '';
//         if (Get.isRegistered<ChatDetailController>()) {
//           ChatDetailController controller = Get.find<ChatDetailController>();
//           controller.chatName.value = textNameController.text;
//           controller.chatAvatar.value =
//           chatAvatar.value.isNotEmpty && responseFile.isEmpty
//               ? chatAvatar.value
//               : responseFile.isNotEmpty
//               ? responseFile
//               : '';
//         }
//         if (Get.isRegistered<ChatController>()) {
//           ChatController controller = Get.find<ChatController>();
//           int index = controller.listChat
//               .indexWhere((element) => element.uuid! == uuidChat);
//           if (index != -1) {
//             controller.listChat[index].ownerName = textNameController.text;
//             controller.listChat[index].avatar =
//             chatAvatar.value.isNotEmpty && responseFile.isEmpty
//                 ? chatAvatar.value
//                 : responseFile.isNotEmpty
//                 ? responseFile
//                 : '';
//             controller.listChat.refresh();
//           }
//         }
//         _listConversationLocal.updateConversationInfo(
//             textNameController.text,
//             chatAvatar.value.isNotEmpty && responseFile.isEmpty
//                 ? chatAvatar.value
//                 : responseFile.isNotEmpty
//                 ? responseFile
//                 : '',
//             uuidChat);
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
//
//   pushFile() async {
//     if (file.path != '') {
//       String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//       try {
//         var data = await APICaller.putFile(
//             endpoint: ApiAddress.upload_image,
//             filePath: file,
//             type: 1,
//             keyCert: Utils.generateMd5(
//                 Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//             time: formattedTime);
//         if (data != null) {
//           List<dynamic> list = data['items'];
//           var listItem = list.map((dynamic json) => '"$json"').toList();
//           responseFile = jsonDecode(listItem[0]);
//         } else {}
//       } catch (e) {
//         Utils.showSnackBar(
//             title: TextByNation.getStringByKey(KeyByNation.error_file),
//             message: '$e');
//       }
//     }
//   }
//
//   getImage() async {
//     file = await Utils.getImage();
//     if (file.path != '') {
//       await pushFile();
//       await changeGroupInfo();
//       // isEditGroup.value = !isEditGroup.value;
//     }
//   }
//
//   groupInfo() async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     var param = {
//       "keyCert":
//       Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//       "time": formattedTime,
//       "uuid": uuidChat
//     };
//     try {
//       var response = await APICaller.post(ApiAddress.group_info, param);
//       if (response != null) {
//         memberLength.value = response['data']['memCount'];
//         autoDeleteData = response['data']['autoDelete'];
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
//
//   autoDelete({required int day}) async {
//     String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
//     var param = {
//       "keyCert":
//       Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
//       "time": formattedTime,
//       "roomUuid": uuidChat,
//       "period": day
//     };
//     debugPrint(param.toString());
//     try {
//       var response =
//       await APICaller.post(ApiAddress.auto_delete_message, param);
//       if (response != null) {
//         autoDeleteData = timeList.indexWhere((e) => e == day);
//       }
//     } catch (e) {
//       Utils.showSnackBar(
//           title: TextByNation.getStringByKey(KeyByNation.notification),
//           message: '$e');
//     }
//   }
// }
