class ChatDetail {
  String? uuid;
  String? msgRoomUuid;
  String? replyMsgUuid;
  String? userSent;
  String? content;
  int? contentType;
  String? timeCreated;
  String? lastEdited;
  int? status;
  int? likeCount = 0;
  int? readState;
  int? type;
  String? ownerUuid;
  String? countryCode;
  String? roomName;
  String? fullName;
  String? avatar;
  String? forwardFrom;
  String? mediaName;
  ReplyMsgUu? replyMsgUu;
  // List<Emojis>? emojis;
  String translate = '';
  bool isTranslate = false;
  String translateOrigin = '';

  ChatDetail({
    this.uuid,
    this.msgRoomUuid,
    this.replyMsgUuid,
    this.userSent,
    this.content,
    this.contentType,
    this.timeCreated,
    this.lastEdited,
    this.status,
    this.likeCount,
    this.readState,
    this.type,
    this.ownerUuid,
    this.countryCode,
    this.roomName,
    this.fullName,
    this.avatar,
    this.forwardFrom,
    this.mediaName,
    this.replyMsgUu,
    // this.emojis
  });

  ChatDetail.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    msgRoomUuid = json['msgRoomUuid'];
    replyMsgUuid = json['replyMsgUuid'];
    userSent = json['userSent'];
    content = json['content'];
    contentType = json['contentType'];
    timeCreated = json['timeCreated'];
    lastEdited = json['lastEdited'];
    status = json['status'];
    likeCount = json['likeCount'];
    readState = json['readState'];
    type = json['type'];
    ownerUuid = json['ownerUuid'];
    countryCode = json['countryCode'];
    roomName = json['roomName'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    forwardFrom = json['forwardFrom'];
    mediaName = json['mediaName'];
    replyMsgUu = json['replyMsgUu'] != null
        ? new ReplyMsgUu.fromJson(json['replyMsgUu'])
        : null;
    // if (json['emojis'] != null) {
    //   emojis = <Emojis>[];
    //   json['emojis'].forEach((v) {
    //     emojis!.add(new Emojis.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['msgRoomUuid'] = this.msgRoomUuid;
    data['replyMsgUuid'] = this.replyMsgUuid;
    data['userSent'] = this.userSent;
    data['content'] = this.content;
    data['contentType'] = this.contentType;
    data['timeCreated'] = this.timeCreated;
    data['lastEdited'] = this.lastEdited;
    data['status'] = this.status;
    data['likeCount'] = this.likeCount;
    data['readState'] = this.readState;
    data['type'] = this.type;
    data['ownerUuid'] = this.ownerUuid;
    data['countryCode'] = this.countryCode;
    data['roomName'] = this.roomName;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['forwardFrom'] = this.forwardFrom;
    data['mediaName'] = this.mediaName;
    if (this.replyMsgUu != null) {
      data['replyMsgUu'] = this.replyMsgUu!.toJson();
    }
    // if (this.emojis != null) {
    //   data['emojis'] = this.emojis!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class ReplyMsgUu {
  String? uuid;
  String? msgRoomUuid;
  String? userSent;
  String? content;
  int? contentType;
  String? timeCreated;
  String? lastEdited;
  int? status;
  int? likeCount;
  int? readState;
  int? type;
  String? ownerUuid;
  String? countryCode;
  String? roomName;
  String? fullName;
  String? avatar;
  String? mediaName;
  // List<Emojis>? emojis;

  ReplyMsgUu({
    this.uuid,
    this.msgRoomUuid,
    this.userSent,
    this.content,
    this.contentType,
    this.timeCreated,
    this.lastEdited,
    this.status,
    this.likeCount,
    this.readState,
    this.type,
    this.ownerUuid,
    this.countryCode,
    this.roomName,
    this.fullName,
    this.avatar,
    this.mediaName,
  });

  ReplyMsgUu.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    msgRoomUuid = json['msgRoomUuid'];
    userSent = json['userSent'];
    content = json['content'];
    contentType = json['contentType'];
    timeCreated = json['timeCreated'];
    lastEdited = json['lastEdited'];
    status = json['status'];
    likeCount = json['likeCount'];
    readState = json['readState'];
    type = json['type'];
    ownerUuid = json['ownerUuid'];
    countryCode = json['countryCode'];
    roomName = json['roomName'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    mediaName = json['mediaName'];
    // if (json['emojis'] != null) {
    //   emojis = <Emojis>[];
    //   json['emojis'].forEach((v) {
    //     emojis!.add(new Emojis.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['msgRoomUuid'] = this.msgRoomUuid;
    data['userSent'] = this.userSent;
    data['content'] = this.content;
    data['contentType'] = this.contentType;
    data['timeCreated'] = this.timeCreated;
    data['lastEdited'] = this.lastEdited;
    data['status'] = this.status;
    data['likeCount'] = this.likeCount;
    data['readState'] = this.readState;
    data['type'] = this.type;
    data['ownerUuid'] = this.ownerUuid;
    data['countryCode'] = this.countryCode;
    data['roomName'] = this.roomName;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['mediaName'] = this.mediaName;
    // if (this.emojis != null) {
    //   data['emojis'] = this.emojis!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

// class Emojis {
//   String? name;
//   int? id;
//   String? path;
//   Sender? sender;
//
//   Emojis({this.name, this.id, this.path, this.sender});
//
//   Emojis.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     id = json['id'];
//     path = json['path'];
//     sender =
//     json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['id'] = this.id;
//     data['path'] = this.path;
//     if (this.sender != null) {
//       data['sender'] = this.sender!.toJson();
//     }
//     return data;
//   }
// }

// class Sender {
//   String? name;
//   String? uuid;
//   String? path;
//
//   Sender({this.name, this.uuid, this.path});
//
//   Sender.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     uuid = json['uuid'];
//     path = json['path'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['uuid'] = this.uuid;
//     data['path'] = this.path;
//     return data;
//   }
// }
