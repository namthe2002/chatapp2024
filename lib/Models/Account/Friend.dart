class Friend {
  String? uuid;
  String? friendUserName;
  String? friendFullName;
  int? type;
  String? timeCreated;
  String? lastUpdated;
  int? status;
  int? canMakeFriend;
  String? avatar;

  Friend(
      {this.uuid,
      this.friendUserName,
      this.friendFullName,
      this.type,
      this.timeCreated,
      this.lastUpdated,
      this.status,
      this.canMakeFriend,
      this.avatar});

  Friend.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    friendUserName = json['friendUserName'];
    friendFullName = json['friendFullName'];
    type = json['type'];
    timeCreated = json['timeCreated'];
    lastUpdated = json['lastUpdated'];
    status = json['status'];
    canMakeFriend = json['canMakeFriend'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['friendUserName'] = this.friendUserName;
    data['friendFullName'] = this.friendFullName;
    data['type'] = this.type;
    data['timeCreated'] = this.timeCreated;
    data['lastUpdated'] = this.lastUpdated;
    data['status'] = this.status;
    data['canMakeFriend'] = this.canMakeFriend;
    data['avatar'] = this.avatar;
    return data;
  }
}
