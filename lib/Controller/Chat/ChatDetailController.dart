import 'dart:async';
import 'dart:convert' hide Codec;
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/AppController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/GlobalValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Chat/ChatDetail.dart';
import 'package:live_yoko/Models/Chat/ChatDetailItem.dart' as cdi;
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Service/SocketManager.dart';
import 'package:live_yoko/Utils/Speech2Text.dart';
import 'package:live_yoko/Utils/Translator.dart';
import 'package:live_yoko/Utils/Utils.dart';
import "dart:html" as html;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../Models/Chat/Chat.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;

class ChatDetailController extends GetxController {
  String uuidUser = '';
  String userName = '';
  var selectedChatDetail = Rxn<Chat>();
  RxList<ChatDetail> chatList = RxList<ChatDetail>();
  RxBool isChatLoading = true.obs;
  RxInt totalPageChat = 1.obs;
  int pageSize = 24;
  int page = 1;
  final Map<String, Uint8List> thumbnailCache = {};
  RxString isDownload = ''.obs;
  ReceivePort receivePort = ReceivePort();
  RxInt progress = 0.obs;
  RxList<String> selectedItems = RxList();
  RxBool isShowMultiselect = false.obs;
  final focusNode = FocusNode();

  // RxList<Emojis> emojiList = RxList<Emojis>();
  RxBool isTextFieldFocused = false.obs;
  RxBool isVisible = true.obs;
  TextEditingController textMessageController = TextEditingController();
  final Map<String, Duration> timeVideoCache = {};
  final Map<String, String> fileTrafficCache = {};
  DateTime timeNow = DateTime.now();
  RxBool isRecording = false.obs;
  late RecorderController recorderController;
  String? pathRecording;
  Translator translator = Translator();
  cdi.ChatDetailItem newMessage = cdi.ChatDetailItem();
  RxBool hasMoreData = true.obs;
  List<File> file = [];
  String uuidChat = '';
  Rx<ChatDetail> replyChat = ChatDetail().obs;
  int backgroundColor = 0xffc9fad9;
  int textColor = 0xff11B991;
  int sizeText = 14;
  List<String> responseFile = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();

  // final focusNode = FocusNode();
  RxBool isSearch = false.obs;
  TextEditingController textSearchController = TextEditingController();
  RxString chatName = ''.obs;
  int chatType = 1;
  String ownerUuid = '';
  Speech2Text speech2text = Speech2Text();
  Timer? _debounce;
  String countryCode = '';
  RxString chatAvatar = ''.obs;
  RxBool isNewMessage = false.obs;
  bool isAddNewMessage = false;
  String lastMsgLineUuid = '';
  int readState = 0;
  RxString userTyping = ''.obs;
  Timer? _timer;
  RxList<ChatDetail> pinList = RxList<ChatDetail>();
  RxBool isPinLoading = true.obs;
  RxInt memberLength = 0.obs;
  RxInt isEdit = 0.obs; //0:chat - 1:edit - 2:rep
  static String nameChanelDownload = 'fileDownloading';
  final AppController appController = Get.find();
  bool isClickLoading = true;
  bool isAppResume = false;
  RxBool isShowGroupInfo = false.obs;
  var chatRoomData = {}.obs;
  final SocketManager _socketManager = SocketManager();
  var capturedImage = Rxn<XFile>();
  List<html.File> files = [];
  RxBool isShowEmoji = false.obs;
  RxBool isDeleteOwnOrMulti = false.obs;
  RxBool isBlockMemberCheck = false.obs;
  RxBool isDeleteConversation = false.obs;
  RxBool isBlockMember = false.obs;
  int roleId = 0;
  RxBool isExtendShowEmoji = false.obs;
  late AudioRecorder recorder;
  bool _recorderIsInited = false;

  @override
  void onInit() async {
    super.onInit();
    ever(appController.appState, (state) async {
      if (state == AppLifecycleState.resumed) {
        // Ứng dụng đang chạy
        isAppResume = true;

        // SocketManager().connect();
      } else {
        // Ứng dụng không chạy
        readMessage();
      }
    });
    recorder = AudioRecorder();
    itemPositionsListener.itemPositions.addListener(loadMoreItems);
    textMessageController.addListener(() {
      if (textMessageController.text
          .trim()
          .isNotEmpty) {
        isTextFieldFocused.value = true;
        isVisible.value = false;
        _socketManager.sendTypingRequest(
          roomUuid: uuidChat,
        );
      } else {
        isTextFieldFocused.value = false;
        // Future.delayed(Duration(milliseconds: 200), () {
        isVisible.value = true;
        // });
      }
    });

    textSearchController.addListener(() {
      onSearchChanged();
    });

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, nameChanelDownload);
    receivePort.listen((message) {
      progress.value = message;
      if (message == 100 || message == -1) {
        progress.value = 0;
        isDownload.value = '';
      }
    });

    uuidUser = GlobalValue.getInstance().getUuid();
    userName = await Utils.getStringValueWithKey(Constant.USERNAME);
    countryCode = GlobalValue.getInstance().getCountryCode();

    int sizeText = await Utils.getIntValueWithKey(Constant.SIZE_TEXT);
    String backgroundColor =
    await Utils.getStringValueWithKey(Constant.BR_COLOR);
    String textColor = await Utils.getStringValueWithKey(Constant.TEXT_COLOR);
    if (sizeText != 0) {
      this.sizeText = sizeText;
    }
    if (backgroundColor.isNotEmpty) {
      this.backgroundColor = int.parse(backgroundColor);
    }
    if (textColor.isNotEmpty) {
      this.textColor = int.parse(textColor);
    }
    // await SocketManager().connect();
    await translator.init();
    await speech2text.init();

  }

  @override
  @override
  @override
  void onReady() async {
    super.onReady();
    // uuidChat = Get.arguments['uuid'];
    // chatName.value = Get.arguments['name'];
    // chatType = Get.arguments['type'];
    // ownerUuid = Get.arguments['ownerUuid'];
    // chatAvatar.value = Get.arguments['avatar'];
    // lastMsgLineUuid = Get.arguments['lastMsgLineUuid'] ?? '';
    uuidChat = selectedChatDetail.value?.uuid ?? '';
    chatName.value = selectedChatDetail.value?.ownerName ?? '';
    chatType = selectedChatDetail.value?.type ?? 0;
    ownerUuid = selectedChatDetail.value?.ownerUuid ?? '';
    chatAvatar.value = selectedChatDetail.value?.avatar ?? '';
    lastMsgLineUuid = selectedChatDetail.value?.lastMsgLineUuid ?? '';
    await messageState();
    if (chatType == 2) {
      await groupInfo();
    }
    await getMessage();
    await readMessage();
    await getMessagePin();
  }

  @override
  void onClose() async {
    super.onClose();
    itemPositionsListener.itemPositions.removeListener(loadMoreItems);
    await readMessage();
    FlutterDownloader.cancelAll();
    FlutterDownloader.remove(taskId: nameChanelDownload);
    receivePort.close();
    IsolateNameServer.removePortNameMapping(nameChanelDownload);
    recorder.dispose();
  }

  loadMoreItems() async {
    final itemPositions = itemPositionsListener.itemPositions.value.toList();
    final lastItemPosition =
    itemPositions.isNotEmpty ? itemPositions.last : null;

    bool isIndexZeroVisible =
    itemPositions.any((position) => position.index <= 1);
    if (isIndexZeroVisible) {
      isAddNewMessage = false;
    } else {
      isAddNewMessage = true;
    }

    if (lastItemPosition != null &&
        lastItemPosition.index == chatList.length - 1) {
      if (!isChatLoading.value && hasMoreData.value) {
        page++;
        await getMessage();
      }
    }
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName(nameChanelDownload);
    sendPort!.send(progress);
  }

  Future<Duration> timePlayer(String url) async {
    Completer<Duration> completer = Completer<Duration>();

    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      completer.complete(duration);
    });

    await audioPlayer.setSourceUrl(url);
    await audioPlayer.getDuration();
    return completer.future;
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String result = '$twoDigitMinutes:$twoDigitSeconds';

    if (duration.inHours > 0) {
      String twoDigitHours = twoDigits(duration.inHours);
      result = '$twoDigitHours:$result';
    }

    return result;
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

  Future<void> saveFile({required String url, required String fileName}) async {
    isDownload.value = '${TextByNation.getStringByKey('downloading')} $url';
    if (kIsWeb) {
      try {
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', fileName.replaceAll(' ', '_'))
          ..style.display = 'none';
        html.document.body?.append(anchor);
        js.context.callMethod('eval', [
          'document.querySelector("a[download=\'${fileName.replaceAll(
              ' ', '_')}\']").click()'
        ]);
        anchor.remove();
      } catch (e) {
        print('Download exception (web): $e');
      }
      return;
    } else {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('no_access'));
    }
  }

  bool isJson(String str) {
    try {
      if (str.startsWith('{') && str.endsWith('}')) {
        json.decode(str);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  bool isLink(String text) {
    RegExp urlRegex = RegExp(
      r'http(s)?://(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(?:[/?#]|$)',
      caseSensitive: false,
      multiLine: false,
    );
    if (urlRegex.hasMatch(text)) {
      RegExp imageUrlRegex = RegExp(
        r'\.(jpg|jpeg|png|gif|bmp|webp|tiff|tif|svg)$',
        caseSensitive: false,
        multiLine: false,
      );
      return !imageUrlRegex.hasMatch(text); // Trả về false nếu là link ảnh
    }
    return false;
  }

  bool isImageLink(String text) {
    RegExp imageUrlRegex = RegExp(
      r'http(s)?://(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(?:[/?#]|$).*\.(jpg|jpeg|png|gif|bmp|webp|tiff|tif|svg)$',
      caseSensitive: false,
      multiLine: false,
    );

    return imageUrlRegex.hasMatch(text);
  }

  String getLink(String text) {
    String link = '';
    RegExp linkRegExp = RegExp(
        r'http(s)?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+');
    Iterable<Match> matches = linkRegExp.allMatches(text);

    for (Match match in matches) {
      link = match.group(0)!;
    }
    return link;
  }

  refreshData() async {
    page = 1;
    chatList.clear();
    await getMessage();
  }

  refreshTyping() {
    if (_timer?.isActive ?? false) _timer!.cancel();
    _timer = Timer(const Duration(milliseconds: 5000), () {
      userTyping.value = '';
    });
  }

  onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  getMessage() async {
    try {
      if (page == 1) {
        isChatLoading.value = true;
      }
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": page,
        "keyword": textSearchController.text,
        "msgGroupUuid": uuidChat
      };
      var data =
      await APICaller.getInstance().post('v1/Chat/message-line', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem =
        list.map((dynamic json) => ChatDetail.fromJson(json)).toList();
        bool reached = false;
        if (listItem.isNotEmpty) {
          for (int i = 0; i < listItem.length; i++) {
            if (listItem[0].userSent != userName ||
                listItem[i].uuid == data['lastMsgRead']) {
              reached = true;
            }
            if (reached || page != 1) {
              listItem[i].readState = 1;
            }
          }
          chatList.addAll(listItem);
        } else {
          hasMoreData.value = false;
        }
        if (page == 1) {
          isChatLoading.value = false;
        }
      } else {
        isChatLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('error_message'), message: '$e');
      isChatLoading.value = false;
    }
  }

  sendMessage({required String content, int type = 1}) async {
    if (isAppResume) {
      isAppResume = false;
      // await SocketManager().connect();
    }
    await _socketManager.sendMessage(
        type: chatType,
        receiver: uuidChat,
        content: content,
        contentType: type,
        replyMsgUuid: replyChat.value.uuid,
        CountryCode: GlobalValue.getInstance().getCountryCode());
    print('thecoicb $type');
    textMessageController.clear();
    replyChat.value = ChatDetail();
    responseFile.clear();
  }

  setNewMessage(int msgType, dynamic message) {
    String uuidChatCache = '';
    newMessage = cdi.ChatDetailItem.fromJson(message);
    if (newMessage.msgRoomUuid == uuidChat) {
      // check duplicate socket
      if (newMessage.uuid == uuidChatCache) {
        return;
      }
      uuidChatCache = newMessage.uuid!;

      if (isAddNewMessage) {
        isNewMessage.value = true;
      }
      chatList.insert(
          0,
          ChatDetail(
            replyMsgUuid: newMessage.replyMsgUuid,
            userSent: newMessage.userSent,
            contentType: newMessage.contentType,
            content: newMessage.content,
            uuid: newMessage.uuid,
            timeCreated: newMessage.timeCreated,
            status: newMessage.status,
            lastEdited: newMessage.lastEdited,
            msgRoomUuid: newMessage.msgRoomUuid,
            readState: newMessage.readState,
            likeCount: newMessage.likeCount,
            countryCode: newMessage.countryCode,
            roomName: newMessage.roomName,
            fullName: newMessage.fullName,
            type: newMessage.type,
            avatar: newMessage.avatar,
            forwardFrom: newMessage.forwardFrom,
            mediaName: newMessage.mediaName,
            replyMsgUu: newMessage.replyMsgUu == null
                ? null
                : ReplyMsgUu(
              userSent: newMessage.replyMsgUu!.userSent,
              contentType: newMessage.replyMsgUu!.contentType,
              content: newMessage.replyMsgUu!.content,
              uuid: newMessage.replyMsgUu!.uuid,
              timeCreated: newMessage.replyMsgUu!.timeCreated,
              status: newMessage.replyMsgUu!.status,
              lastEdited: newMessage.replyMsgUu!.lastEdited,
              msgRoomUuid: newMessage.replyMsgUu!.msgRoomUuid,
              readState: newMessage.replyMsgUu!.readState,
              likeCount: newMessage.replyMsgUu!.likeCount,
              countryCode: newMessage.replyMsgUu!.countryCode,
              roomName: newMessage.replyMsgUu!.roomName,
              fullName: newMessage.replyMsgUu!.fullName,
              type: newMessage.replyMsgUu!.type,
              avatar: newMessage.replyMsgUu!.avatar,
              mediaName: newMessage.replyMsgUu!.mediaName,
            ),
          ));
      if (newMessage.userSent != userName) {
        // readMessage();
        for (int i = 0; i < chatList.length; i++) {
          if (chatList[i].readState == 1) break;
          chatList[i].readState = 1;
        }
      } else {
        if (msgType == 0) {
          if (chatList.length > 1) {
            itemScrollController.jumpTo(index: 0);
          }
        }
      }
      userTyping.value = '';
      chatList.refresh();
    } else {
      if (msgType == 0) {
        String decoded = newMessage.content ?? '';
        String decodedFullName = newMessage.fullName ?? '';
        try {
          decoded = utf8.decode(base64Url.decode(newMessage.content!));
        } catch (e) {
          decoded = newMessage.content ?? '';
        }
        try {
          decodedFullName = utf8.decode(base64Url.decode(newMessage.fullName!));
        } catch (e) {
          decodedFullName = newMessage.fullName ?? '';
        }
        switch (newMessage.contentType) {
          case 3:
            List<dynamic> array = jsonDecode(decoded);
            decoded = Utils.getFileType(array[0]) == 'Image'
                ? TextByNation.getStringByKey('image')
                : TextByNation.getStringByKey('video');
            break;
          case 4:
            decoded = TextByNation.getStringByKey('file');
            break;
          case 5:
            decoded = TextByNation.getStringByKey('audio');
            break;
        }
        Utils.showSnackBar(title: decodedFullName, message: decoded);
      }
    }
  }

  Future<void> getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt',
        'zip',
        'rar'
      ],
    );
    if (result != null && result.files.isNotEmpty) {
      Uint8List? bytes = result.files.single.bytes;
      String fileName = result.files.single.name;
      List<Uint8List> filePath = [];
      if (bytes != null) {
        filePath.add(bytes);
      }
      await pushFileWeb2(type: 4, fileData: filePath, fileName: fileName);
      if (responseFile.isNotEmpty) {
        await sendMessage(content: responseFile.toString(), type: 4);
      } else {
        Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('unable_send'),
        );
      }
    }
  }

  pushFileWeb2({required int type,
    required List<Uint8List> fileData,
    required fileName}) async {
    String formattedTime =
    DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now());
    try {
      var data = await APICaller.getInstance().putFilesWeb2(
        endpoint: 'v1/Upload/upload-image',
        fileData: fileData,
        type: type,
        keyCert:
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        time: formattedTime,
        fileName: fileName,
      );

      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list.map((dynamic json) => '"$json"').toList();
        responseFile = listItem;
        fileData.clear();
      } else {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('error_file'),
            message: 'Upload file failed');
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('error_file'), message: '$e');
    }
  }

  getImageFiles({required bool isCamera}) async {
    if (!Get.isRegistered<ChatDetailController>()) {
      Get.put(ChatDetailController());
    }
    final List<html.File>? images = await ImagePickerWeb.getMultiImagesAsFile();
    if (images != null && images.isNotEmpty) {
      List<html.File> fileData = [];
      for (var img in images) {
        fileData.add(img);
      }
      String type = 'Image';
      await pushFileWeb(
          type: type == 'Image' || type == 'Video' ? 1 : 4, fileData: fileData);
      if (responseFile.isNotEmpty) {
        await sendMessage(
            content: responseFile.toString(),
            type: type == 'Image' || type == 'Video' ? 3 : 4);
      } else {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('unable_send'));
      }
    } else {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('file_size'));
    }
  }

  getVideoFiles({required bool isCamera}) async {
    if (!Get.isRegistered<ChatDetailController>()) {
      Get.put(ChatDetailController());
    }
    final List<html.File>? videos = await ImagePickerWeb.getMultiVideosAsFile();
    if (videos != null && videos.isNotEmpty) {
      List<html.File> fileData = [];
      for (var img in videos) {
        fileData.add(img);
      }
      String type = 'Video';
      await pushFileWeb(
          type: type == 'Image' || type == 'Video' ? 1 : 4, fileData: fileData);
      if (responseFile.isNotEmpty) {
        await sendMessage(
            content: responseFile.toString(),
            type: type == 'Image' || type == 'Video' ? 3 : 4);
      } else {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('unable_send'));
      }
    } else {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('file_size'));
    }
  }

  pushFileWeb({required int type, required List<html.File> fileData}) async {
    String formattedTime =
    DateFormat('MM/dd/yyyy HH:mm:ss').format(DateTime.now());
    try {
      var data = await APICaller.getInstance().putFilesWeb(
        endpoint: 'v1/Upload/upload-image',
        fileData: fileData,
        type: type,
        keyCert:
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        time: formattedTime,
      );

      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem = list.map((dynamic json) => '"$json"').toList();
        responseFile = listItem;
        fileData.clear();
      } else {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('error_file'),
            message: 'Upload file failed');
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('error_file'), message: '$e');
    }
  }

  deleteMessage() async {
    // String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    // var param = {
    //   "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
    //   "time": formattedTime,
    //   "uuidList": selectedItems
    // };
    //
    // try {
    //   var response = await APICaller.getInstance().delete('v1/Chat/delete-list-message-line', body: param);
    //   if (response != null) {
    //     chatList.removeWhere((element) => selectedItems.contains(element.uuid));
    //     chatList.refresh();
    //     selectedItems.clear();
    //     if (Get.isRegistered<ChatContrller>()) {
    //       Get.find<ChatContrller>().refreshListChat();
    //     }
    //   }
    // } catch (e) {
    //   Utils.showSnackBar(title: TextByNation.getStringByKey('error_delete_message'), message: '$e');
    // }
    bool isDelete = true;
    for (String uuid in selectedItems) {
      int index = chatList.indexWhere((element) => element.uuid! == uuid);
      if (chatList[index].userSent != userName) {
        isDelete = false;
        break;
      }
    }
    if (isDelete) {
      if (isAppResume) {
        isAppResume = false;
      }

      await _socketManager.deleteMessage(
          roomUuid: uuidChat, listMsgUuid: selectedItems);
      selectedItems.clear();
    } else {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: 'Chỉ được xóa tin nhắn của mình');
    }
    // chatList.removeWhere((element) => selectedItems.contains(element.uuid));
    // chatList.refresh();
    // selectedItems.clear();
    // if (Get.isRegistered<ChatContrller>()) {
    //   Get.find<ChatContrller>().refreshListChat();
    // }
  }

  List<TextSpan> searchText(String text) {
    final matches =
    textSearchController.text.allMatches(text.toLowerCase()).toList();
    final spans = <TextSpan>[];

    if (matches.isEmpty) {
      spans.add(TextSpan(text: text));
    } else {
      for (var i = 0; i < matches.length; i++) {
        final strStart = i == 0 ? 0 : matches[i - 1].end;
        final match = matches[i];
        spans.add(
          TextSpan(
            text: text.substring(
              strStart,
              match.start,
            ),
          ),
        );
        spans.add(
          TextSpan(
            text: text.substring(
              match.start,
              match.end,
            ),
            style: const TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
          ),
        );
      }
      spans.add(TextSpan(text: text.substring(matches.last.end)));
    }
    return spans;
  }

  Future<void> saveImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String fileName = Uri
          .parse(imageUrl)
          .pathSegments
          .last;
      String filePath = '$tempPath/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Lưu ảnh vào thư viện ảnh
      final result = await ImageGallerySaver.saveFile(filePath);

      if (result['isSuccess']) {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('photo_saved_successfully'));
      } else {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('photo_saved_error'));
      }
    } else {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'),
          message: TextByNation.getStringByKey('error_delete_message'));
    }
  }

  readMessage() async {
    // String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    // var param = {
    //   "keyCert": Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
    //   "time": formattedTime,
    //   "roomUuid": uuidChat,
    //   "messageLineUuid": lastMsgLineUuid
    // };
    //
    // try {
    //   var response = await APICaller.getInstance().post('v1/Chat/read-message', param);
    //   if (response != null) {
    //
    //   }
    // } catch (e) {
    //   Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: '$e');
    // }

    if (chatList.isNotEmpty)
      await _socketManager.sendReadRequest(
        roomUuid: uuidChat,
        msgUuid: chatList[0].uuid!,
      );
  }

  messageState() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
      Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uuid": lastMsgLineUuid
    };

    if (lastMsgLineUuid.isNotEmpty)
      try {
        var response = await APICaller.getInstance()
            .post('v1/Chat/check-message-read-state', param);
        if (response != null) {
          readState = response['data'];
        }
      } catch (e) {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'), message: '$e');
      }
  }

  getMessagePin() async {
    try {
      isPinLoading.value = true;
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      var param = {
        "keyCert":
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "uuid": uuidChat
      };
      var data = await APICaller.getInstance()
          .post('v1/Chat/list-messageline-pinned', param);
      if (data != null) {
        List<dynamic> list = data['items'];
        var listItem =
        list.map((dynamic json) => ChatDetail.fromJson(json)).toList();
        pinList.addAll(listItem);
        isPinLoading.value = false;
      } else {
        isPinLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('error_message'), message: '$e');
      isPinLoading.value = false;
    }
  }



  Future<void> _initRecorder() async {
    // Check if the recorder is already initialized
    if (_recorderIsInited) return;

    // Request microphone permission using the Permissions API
    final permissionStatus = await html.window.navigator.permissions?.query({'name': 'microphone'});

    if (permissionStatus?.state == 'granted') {
      // Permission granted, initialize the recorder
      _recorderIsInited = true;
      print("Microphone permission granted.");
    } else if (permissionStatus?.state == 'denied') {
      // Permission denied, prompt user to allow microphone access
      print("Microphone permission denied. Please enable it in your browser settings.");
    } else {
      // If permission is not granted or denied (prompt status), request permission
      await _requestMicrophonePermission();
    }
  }

// Function to request microphone permission
  Future<void> _requestMicrophonePermission() async {
    try {
      // Attempt to get microphone access again
      final stream = await html.window.navigator.getUserMedia(audio: true);

      if (stream != null) {
        // Permission granted
        _recorderIsInited = true;
        stream.getTracks().forEach((track) => track.stop()); // Stop the stream after getting permission
        print("Microphone permission re-requested and granted.");
      }
    } catch (e) {
      // Handle the error when the user denies the permission request again
      print("Error requesting microphone permission: $e");
      // Show a user-friendly message or prompt them to change settings manually
    }
  }



  Future<void> startOrStopRecording({bool isSend = false}) async {
    if (!_recorderIsInited) await _initRecorder();
    try {
      if (isRecording.value) {
        isRecording.value = !isRecording.value;
        final path = await recorder.stop();
        print('Stopped recording: $path');
        if (isSend && path != null) {
          if (path.startsWith('blob:')) {
            final blob = await html.window.fetch(path).then((response) => response.blob());
            final reader = html.FileReader();
            reader.readAsArrayBuffer(blob);
            await reader.onLoadEnd.first;
            final bytes = reader.result as Uint8List;
            final file = html.File([bytes], 'audio.wav');
            List<html.File> fileData = [file];
            await pushFileWeb(type: 3, fileData: fileData);
            await sendMessage(content: responseFile.toString(), type: 5);
          } else {
            print('Invalid blob URL: $path');
          }
        }
      } else {
        await recorder.start(
          RecordConfig(encoder: AudioEncoder.wav),
          path: 'temp_audio_${DateTime.now().millisecondsSinceEpoch}.wav',
        );
        print('Started recording');
        isRecording.value = !isRecording.value;
      }
    } catch (e) {
      debugPrint('Recording error: $e');
    }
  }







  groupInfo() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
      Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "uuid": uuidChat
    };
    try {
      var response =
      await APICaller.getInstance().post('v1/Chat/group-info', param);
      if (response != null) {
        memberLength.value = response['data']['memCount'];
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }

  pinMessage({required int state}) async {
    if (isAppResume) {
      isAppResume = false;
      // await SocketManager().connect();
    }
    await _socketManager.pinMessage(
        roomUuid: uuidChat, listMsgUuid: selectedItems, state: state);
    selectedItems.clear();
  }

  editMessage() async {
    if (isAppResume) {
      isAppResume = false;
      // await SocketManager().connect();
    }
    await _socketManager.editMessage(
      msgLineUuid: replyChat.value.uuid!,
      content: textMessageController.text,
    );
    textMessageController.clear();
    replyChat.value = ChatDetail();
  }

  likeMessage({required String uuid,
    required int type,
    required int status,
    required String uuidUser}) async {
    if (isAppResume) {
      isAppResume = false;
    }
    //status
    /// 1: liked - 0: remove like
    await _socketManager.likeMessage(
        msgLineUuid: uuid, type: type, status: status, uuidUser: uuidUser);
  }


  setRead(dynamic message) {
    if (message['RoomUuid'] == uuidChat) {
      for (int i = 0; i < chatList.length; i++) {
        if (chatList[i].readState == 1) break;
        chatList[i].readState = 1;
      }
      chatList.refresh();
    }
  }

  setTyping(dynamic message) {
    if (message['RoomUuid'] == uuidChat) {
      userTyping.value = message['FullName'] ?? '';
      refreshTyping();
    }
  }

  setDeleteMessage(dynamic message) async {
    if (message['RoomUuid'] == uuidChat) {
      chatList.removeWhere(
              (element) => message['ListMsgUuid'].contains(element.uuid));
      chatList.refresh();

      pinList.removeWhere(
              (element) => message['ListMsgUuid'].contains(element.uuid));
      pinList.refresh();
    }
  }

  setPinMessage(dynamic message) async {
    if (message['RoomUuid'] == uuidChat) {
      if (message['State'] == 0) {
        for (int i = 0; i < message['LstMsgUuid'].length; i++) {
          int index = pinList.indexWhere(
                  (element) => element.uuid! == message['LstMsgUuid'][i]);
          pinList.removeAt(index);
        }
      } else {
        for (int i = 0; i < message['LstMsgUuid'].length; i++) {
          int index = chatList.indexWhere(
                  (element) => element.uuid! == message['LstMsgUuid'][i]);
          if (!pinList.any((item) => item.uuid == message['LstMsgUuid'][i])) {
            chatList[index].fullName = decodedName(chatList[index].fullName!);
            pinList.insert(0, chatList[index]);
          }
        }
      }
      pinList.refresh();
    }
  }

  setEditMessage(dynamic message) async {
    int index = chatList
        .indexWhere((element) => element.uuid! == message['MsgLineUuid']);
    if (index != -1) {
      chatList[index].content = message['Content'];
      chatList[index].status = 2;
      chatList.refresh();
    }
  }

  setLikeMessage(dynamic message) async {
    int index = chatList
        .indexWhere((element) => element.uuid! == message['MsgLineUuid']);
    if (index != -1) {
      chatList[index].likeCount = chatList[index].likeCount! + 1;
      chatList.refresh();
    }
  }


  blockMember(int type, String roomUuid, String userName) {
    //socket
    _socketManager.blockMember(
        roomUuid: roomUuid, type: type, userName: userName);
  }

  void showGroupInfoMode() {
    if (isShowGroupInfo.value == true) {
      isShowGroupInfo.value = !isShowGroupInfo.value;
    } else {
      isShowGroupInfo.value = !isShowGroupInfo.value;
    }
  }

  String decodedName(String name) {
    String decoded = name;
    try {
      decoded = utf8.decode(base64Url.decode(name));
    } catch (e) {
      decoded = name;
    }
    return decoded;
  }

  @override
  void dispose() {
    recorder.cancel();
    recorder.dispose();
    super.dispose();
  }
}
