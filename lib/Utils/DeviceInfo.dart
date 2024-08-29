import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static Future<String> getDeviceId() async {
    String deviceId = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      deviceId = info.id;
    } else {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      deviceId = info.identifierForVendor.toString();
    }
    return deviceId;
  }

  static Future<String> getDeviceModel() async {
    String deviceModel = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      deviceModel = info.model;
    } else {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      deviceModel = info.model.toString();
    }
    return deviceModel;
  }
}
