class ChatDetailItem {
  String? uuid;
  String? msgRoomUuid;
  String? roomName;
  String? replyMsgUuid;
  String? userSent;
  String? content;
  int? contentType;
  String? timeCreated;
  String? lastEdited;
  int? status;
  int? type;
  int? likeCount;
  int? readState;
  String? countryCode;
  String? ownerUuid;
  String? fullName;
  String? avatar;
  String? forwardFrom;
  String? mediaName;
  ReplyMsgUu? replyMsgUu;

  ChatDetailItem(
      {this.uuid,
      this.msgRoomUuid,
      this.roomName,
      this.replyMsgUuid,
      this.userSent,
      this.content,
      this.contentType,
      this.timeCreated,
      this.lastEdited,
      this.status,
      this.type,
      this.likeCount,
      this.readState,
      this.countryCode,
      this.ownerUuid,
      this.fullName,
      this.avatar,
      this.forwardFrom,
      this.mediaName,
      this.replyMsgUu});

  ChatDetailItem.fromJson(Map<String, dynamic> json) {
    uuid = json['Uuid'];
    msgRoomUuid = json['MsgRoomUuid'];
    roomName = json['RoomName'];
    replyMsgUuid = json['ReplyMsgUuid'];
    userSent = json['UserSent'];
    content = json['Content'];
    contentType = json['ContentType'];
    timeCreated = json['TimeCreated'];
    lastEdited = json['LastEdited'];
    status = json['Status'];
    type = json['Type'];
    likeCount = json['LikeCount'];
    readState = json['ReadState'];
    countryCode = json['CountryCode'];
    ownerUuid = json['OwnerUuid'];
    fullName = json['FullName'];
    avatar = json['Avatar'];
    forwardFrom = json['ForwardFrom'];
    mediaName = json['MediaName'];
    replyMsgUu = json['ReplyMsgUu'] != null
        ? new ReplyMsgUu.fromJson(json['ReplyMsgUu'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Uuid'] = this.uuid;
    data['MsgRoomUuid'] = this.msgRoomUuid;
    data['RoomName'] = this.roomName;
    data['ReplyMsgUuid'] = this.replyMsgUuid;
    data['UserSent'] = this.userSent;
    data['Content'] = this.content;
    data['ContentType'] = this.contentType;
    data['TimeCreated'] = this.timeCreated;
    data['LastEdited'] = this.lastEdited;
    data['Status'] = this.status;
    data['Type'] = this.type;
    data['LikeCount'] = this.likeCount;
    data['ReadState'] = this.readState;
    data['CountryCode'] = this.countryCode;
    data['OwnerUuid'] = this.ownerUuid;
    data['FullName'] = this.fullName;
    data['Avatar'] = this.avatar;
    data['ForwardFrom'] = this.forwardFrom;
    data['MediaName'] = this.mediaName;
    if (this.replyMsgUu != null) {
      data['ReplyMsgUu'] = this.replyMsgUu!.toJson();
    }
    return data;
  }
}

class ReplyMsgUu {
  String? uuid;
  String? msgRoomUuid;
  String? replyMsgUuid;
  String? userSent;
  String? content;
  int? contentType;
  String? timeCreated;
  String? lastEdited;
  int? status;
  int? likeCount;
  int? readState;
  String? countryCode;
  String? roomName;
  int? type;
  int? ownerUuid;
  String? fullName;
  String? avatar;
  String? mediaName;
  // Null? replyMsgUu;

  ReplyMsgUu(
      {this.uuid,
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
      this.countryCode,
      this.roomName,
      this.type,
      this.ownerUuid,
      this.fullName,
      this.avatar,
      this.mediaName,
      // this.replyMsgUu
      });

  ReplyMsgUu.fromJson(Map<String, dynamic> json) {
    uuid = json['Uuid'];
    msgRoomUuid = json['MsgRoomUuid'];
    replyMsgUuid = json['ReplyMsgUuid'];
    userSent = json['UserSent'];
    content = json['Content'];
    contentType = json['ContentType'];
    timeCreated = json['TimeCreated'];
    lastEdited = json['LastEdited'];
    status = json['Status'];
    likeCount = json['LikeCount'];
    readState = json['ReadState'];
    countryCode = json['CountryCode'];
    roomName = json['RoomName'];
    type = json['Type'];
    ownerUuid = json['OwnerUuid'];
    fullName = json['FullName'];
    avatar = json['Avatar'];
    mediaName = json['MediaName'];
    // replyMsgUu = json['ReplyMsgUu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Uuid'] = this.uuid;
    data['MsgRoomUuid'] = this.msgRoomUuid;
    data['ReplyMsgUuid'] = this.replyMsgUuid;
    data['UserSent'] = this.userSent;
    data['Content'] = this.content;
    data['ContentType'] = this.contentType;
    data['TimeCreated'] = this.timeCreated;
    data['LastEdited'] = this.lastEdited;
    data['Status'] = this.status;
    data['LikeCount'] = this.likeCount;
    data['ReadState'] = this.readState;
    data['CountryCode'] = this.countryCode;
    data['RoomName'] = this.roomName;
    data['Type'] = this.type;
    data['OwnerUuid'] = this.ownerUuid;
    data['FullName'] = this.fullName;
    data['Avatar'] = this.avatar;
    data['MediaName'] = this.mediaName;
    // data['ReplyMsgUu'] = this.replyMsgUu;
    return data;
  }
}
