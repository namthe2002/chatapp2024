class Chat {
  String? uuid;
  String? userSent;
  String? fullName;
  int? type;
  String? ownerUuid;
  String? partnerUuid;
  String? lastMsgLineUuid;
  String? content;
  int? contentType;
  int? readCounter;
  String? timeCreated;
  String? lastUpdated;
  int? status;
  String? ownerName;
  int? likeCount;
  int? unreadCount;
  String? avatar;
  bool? pinned;
  String? forwardFrom;
  String userTyping = '';
  bool isActive = false;
  Chat(
      {this.uuid,
      this.userSent,
      this.fullName,
      this.type,
      this.ownerUuid,
      this.partnerUuid,
      this.lastMsgLineUuid,
      this.content,
      this.contentType,
      this.readCounter,
      this.timeCreated,
      this.lastUpdated,
      this.status,
      this.ownerName,
      this.likeCount,
      this.unreadCount,
      this.avatar,
      this.pinned,
      this.forwardFrom});

  Chat.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userSent = json['userSent'];
    fullName = json['fullName'];
    type = json['type'];
    ownerUuid = json['ownerUuid'];
    partnerUuid = json['partnerUuid'];
    lastMsgLineUuid = json['lastMsgLineUuid'];
    content = json['content'];
    contentType = json['contentType'];
    readCounter = json['readCounter'];
    timeCreated = json['timeCreated'];
    lastUpdated = json['lastUpdated'];
    status = json['status'];
    ownerName = json['ownerName'];
    likeCount = json['likeCount'];
    unreadCount = json['unreadCount'];
    avatar = json['avatar'];
    pinned = json['pinned'];
    forwardFrom = json['forwardFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['userSent'] = this.userSent;
    data['fullName'] = this.fullName;
    data['type'] = this.type;
    data['ownerUuid'] = this.ownerUuid;
    data['partnerUuid'] = this.partnerUuid;
    data['lastMsgLineUuid'] = this.lastMsgLineUuid;
    data['content'] = this.content;
    data['contentType'] = this.contentType;
    data['readCounter'] = this.readCounter;
    data['timeCreated'] = this.timeCreated;
    data['lastUpdated'] = this.lastUpdated;
    data['status'] = this.status;
    data['ownerName'] = this.ownerName;
    data['likeCount'] = this.likeCount;
    data['unreadCount'] = this.unreadCount;
    data['avatar'] = this.avatar;
    data['pinned'] = this.pinned;
    data['forwardFrom'] = this.forwardFrom;
    return data;
  }
}
