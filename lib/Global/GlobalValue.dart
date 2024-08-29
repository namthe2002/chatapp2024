import 'package:live_yoko/Global/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import '../Models/Account/Register/UserInfo.dart';

class GlobalValue {
  static var global;

  static GlobalValue getInstance() {
    global ??= GlobalValue();
    return global;
  }

  String _token = "";
  String _fcmToken = "";
  String _uuid = "";
  String _phone = "";
  String _countryCode = 'vi';
  String _session = "";

  // UserInfo _userInfo = UserInfo();

  // UserInfo getUserInfo() {
  //   return _userInfo;
  // }

  void setToken(String token) {
    _token = token;
  }

  String getToken() {
    return _token;
  }

  void setSessionToken(String session) {
    _session = session;
  }

  String getSessionToken() {
    return _session;
  }

  void setFCMToken(String token) {
    _fcmToken = token;
  }

  String getFCMToken() {
    return _fcmToken;
  }

  void setUuid(String uuid) {
    _uuid = uuid;
  }

  String getUuid() {
    return _uuid;
  }

  void setPhone(String phone) {
    _phone = phone;
  }

  String getPhone() {
    return _phone;
  }

  void setCountryCode(String code) {
    _countryCode = code;
  }

  String getCountryCode() {
    return _countryCode;
  }
}
