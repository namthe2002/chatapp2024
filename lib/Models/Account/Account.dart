class Account {
  String? uuid;
  String? userName;
  String? passWord;
  String? email;
  String? fullName;
  String? avatar;
  String? timeCreated;
  String? lastUpdated;
  int? status;
  int? activeState;
  int? id;
  int? roleId;
  int? receiveNotifyStatus;

  Account(
      {this.uuid,
      this.userName,
      this.passWord,
      this.email,
      this.fullName,
      this.avatar,
      this.timeCreated,
      this.lastUpdated,
      this.status,
      this.activeState,
      this.id,
      this.roleId,
      this.receiveNotifyStatus});

  Account.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    userName = json['userName'];
    passWord = json['passWord'];
    email = json['email'];
    fullName = json['fullName'];
    avatar = json['avatar'];
    timeCreated = json['timeCreated'];
    lastUpdated = json['lastUpdated'];
    status = json['status'];
    activeState = json['activeState'];
    id = json['id'];
    roleId = json['roleId'];
    receiveNotifyStatus = json['receiveNotifyStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['userName'] = this.userName;
    data['passWord'] = this.passWord;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['avatar'] = this.avatar;
    data['timeCreated'] = this.timeCreated;
    data['lastUpdated'] = this.lastUpdated;
    data['status'] = this.status;
    data['activeState'] = this.activeState;
    data['id'] = this.id;
    data['roleId'] = this.roleId;
    data['receiveNotifyStatus'] = this.receiveNotifyStatus;
    return data;
  }
}
