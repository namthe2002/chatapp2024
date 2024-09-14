import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Controller/Chat/ChatDetailController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SocketManager {
  static WebSocketChannel? _channel;
  static SocketManager? _instance;

  SocketManager._();

  factory SocketManager() => _instance ??= SocketManager._();
  static late Timer pingAction;

  connect() async {
    String sessionUuid =
        await Utils.getStringValueWithKey(Constant.session_uuid);
    final wsUrl = Uri.parse('wss://tw-apimaster-v2.anbeteam.io.vn/ws?session='
        '$sessionUuid');
    _channel = WebSocketChannel.connect(wsUrl);
    if (_channel == null) {
      print('WebSocket connection failed.');
      return;
    }
    _channel?.stream.listen((message) {
      print('---------------- response ---------- ' + message);
      if (message.toString() == 'pong') return;
      dynamic data = json.decode(message.toString());
      print('dadada $data');
      if (data['MsgType'] == 20) {
        if (data['Data'].length > 0)
          Utils.showSnackBar(
              title: '',
              message: utf8.decode(base64Url.decode(data['Data'])));
          return;
      } else if (data['MsgType'] == 11) {
        Utils.backLogin(true);
        // Utils.showSnackBar(
        //     title: TextByNation.getStringByKey('notification'),
        //     message: TextByNation.getStringByKey('back_lg'));
        return;
      }

      if (Get.isRegistered<ChatDetailController>()) {
        if (data['MsgType'] == 1) {
          Get.find<ChatDetailController>().setTyping(json.decode(data['Data']));
        } else if (data['MsgType'] == 2) {
          Get.find<ChatDetailController>().setRead(json.decode(data['Data']));
        } else if (data['MsgType'] == 3) {
          Get.find<ChatDetailController>()
              .setDeleteMessage(json.decode(data['Data']));
        } else if (data['MsgType'] == 4) {
          Get.find<ChatDetailController>()
              .setPinMessage(json.decode(data['Data']));
        } else if (data['MsgType'] == 5) {
          // online
        } else if (data['MsgType'] == 6) {
          Get.find<ChatDetailController>()
              .setNewMessage(6, json.decode(data['Data']));
        } else if (data['MsgType'] == 7) {
          Get.find<ChatDetailController>()
              .setEditMessage(json.decode(data['Data']));
        } else if (data['MsgType'] == 8) {
          Get.find<ChatDetailController>()
              .setLikeMessage(json.decode(data['Data']));
        } else if (data['MsgType'] == 0) {
          Get.find<ChatDetailController>()
              .setNewMessage(0, json.decode(data['Data']));
        }
      }
      if (Get.isRegistered<ChatController>()) {
        if (data['MsgType'] == 1) {
          Get.find<ChatController>().setTyping(json.decode(data['Data']));
        } else if (data['MsgType'] == 2) {
          Get.find<ChatController>().setRead(json.decode(data['Data']));
        } else if (data['MsgType'] == 6) {
          Get.find<ChatController>().updateChat(json.decode(data['Data']));
        } else if (data['MsgType'] == 0) {
          Get.find<ChatController>().updateChat(json.decode(data['Data']));
        } else if (data['MsgType'] == 5) {
          Get.find<ChatController>().resetListOnline(json.decode(data['Data']));
        } else if (data['MsgType'] == 9) {
        Get.find<ChatController>().remoteChat(json.decode(data['Data']));
        print('daxoachat ${json.decode(data['Data'])}');
        } else if (data['MsgType'] == 10) {
          Get.find<ChatController>().joinChat(json.decode(data['Data']));
        } else if (data['MsgType'] == 3) {
          Get.find<ChatController>().deleteContent(json.decode(data['Data']));
        }
      }
    });
  }

  Future<void> closeSocket() async {
    //pingAction.cancel();
    await _channel?.sink.close();
  }

  sendMessage(
      {required int type,
      required String receiver,
      required String content,
      required int contentType,
      required String CountryCode,
      String? replyMsgUuid}) async {
    var body = {
      'Type': type,
      'Receiver': receiver,
      'Content': content,
      'ContentType': contentType,
      'ReplyMsgUuid': replyMsgUuid,
      'CountryCode': CountryCode
    };
    var data = {'MsgType': 0, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  sendTypingRequest({required String roomUuid}) async {
    var body = {'RoomUuid': roomUuid};
    var data = {'MsgType': 1, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  sendReadRequest({required String roomUuid, required String msgUuid}) async {
    var body = {'RoomUuid': roomUuid, 'MsgUuid': msgUuid};
    var data = {'MsgType': 2, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  deleteMessage(
      {required String roomUuid, required List<String> listMsgUuid}) async {
    var body = {'RoomUuid': roomUuid, 'ListMsgUuid': listMsgUuid};
    var data = {'MsgType': 3, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  sendOnlineStateRequest({required List<String> list}) async {
    var body = {'LstUser': list};
    var data = {'MsgType': 5, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  pinMessage(
      {required String roomUuid,
      required List<String> listMsgUuid,
      required int state}) async {
    var body = {
      'RoomUuid': roomUuid,
      'LstMsgUuid': listMsgUuid,
      'State': state
    };
    var data = {'MsgType': 4, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  forwardMessage(
      {required String roomUuid, required String msgLineUuid}) async {
    var body = {'RoomUuid': roomUuid, 'MsgLineUuid': msgLineUuid};
    var data = {'MsgType': 6, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  editMessage({required String content, required String msgLineUuid}) async {
    var body = {'Content': content, 'MsgLineUuid': msgLineUuid};
    var data = {'MsgType': 7, 'Data': jsonEncode(body)};
    _channel?.sink.add(jsonEncode(data));
  }

  // likeMessage(
  //     {required String msgLineUuid,
  //     required int type,
  //     required int status,
  //     required String uuidUser}) async {
  //   var body = {
  //     'MsgLineUuid': msgLineUuid,
  //     "Type": type,
  //     "Status": status,
  //     "Uuid": uuidUser
  //   };
  //   var data = {'MsgType': 8, 'Data': jsonEncode(body)};
  //
  //   _channel?.sink.add(jsonEncode(data));
  // }

  likeMessage(
      {required String msgLineUuid,
        required int type,
        required int status,
        required String uuidUser}) async {
    var body = {
      'MsgLineUuid': msgLineUuid,
      "Type": type,
      "Status": status,
      "Uuid": uuidUser
    };
    var data = {'MsgType': 8, 'Data': jsonEncode(body)};
            _channel?.sink.add(jsonEncode(data));
  }

  blockMember(
      {required String roomUuid,
      required int type,
      required String userName}) async {
    var body = {"RoomUuid": roomUuid, "UserName": userName};
    var data = {'MsgType': type, 'Data': jsonEncode(body)};
    print('-----$body');
    _channel?.sink.add(jsonEncode(data));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // add your localhost detection logic here if you want
  }
}

class MessageTypeDefine {
  static int SESSION_TIME_OUT = 9999;
  static int CONNECT_SERVER = 2000;
  static int CONNECT_SERVER_REP = 2001;
  static int CREATE_ROOM = 2002;
  static int CREATE_RESPONSE = 2003;
}
