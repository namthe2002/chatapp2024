import 'package:hive/hive.dart';


class Emojis {
  String? fullName;
  int? id;
  String? msgUuid;
  String? uuidUser;
  String? userName;
  String? avatar;

  Emojis(
      {this.fullName,
        this.id,
        this.msgUuid,
        this.uuidUser,
        this.userName,
        this.avatar});

  Emojis.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    id = json['type'];
    msgUuid = json['msgUuid'];
    uuidUser = json['uuid'];
    userName = json['userName'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['fullName'] = fullName;
    data['type'] = id;
    data['msgUuid'] = msgUuid;
    data['uuid'] = uuidUser;
    data['userName'] = userName;
    data['avatar'] = avatar;
    return data;
  }
}
