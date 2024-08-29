class ChatDetailMember {
  String? uuid;
  String? userName;
  String? fullName;
  String? avatar;
  String? timeCreated;
  int? status;
  int? roleId;
  bool? isFriend;
  int? canMakeFriend;

  ChatDetailMember(
      {this.uuid,
        this.userName,
        this.fullName,
        this.avatar,
        this.timeCreated,
        this.status,
        this.roleId,
        this.isFriend,
        this.canMakeFriend});

  ChatDetailMember.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userName = json['userName'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    timeCreated = json['timeCreated'];
    status = json['status'];
    roleId = json['roleId'];
    isFriend = json['isFriend'];
    canMakeFriend = json['canMakeFriend'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['timeCreated'] = this.timeCreated;
    data['status'] = this.status;
    data['roleId'] = this.roleId;
    data['isFriend'] = this.isFriend;
    data['canMakeFriend'] = this.canMakeFriend;
    return data;
  }
}
