class Contact {
  String? uuid;
  String? userName;
  String? fullName;
  String? avatar;
  String? lastSeen;

  Contact(
      {this.uuid, this.userName, this.fullName, this.avatar, this.lastSeen});

  Contact.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userName = json['userName'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    lastSeen = json['lastSeen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['lastSeen'] = this.lastSeen;
    return data;
  }
}
