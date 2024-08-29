import 'package:get/get.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Utils/Utils.dart';

class NotificationSettingController extends GetxController {
  Rx<bool> isNotification = false.obs;
  @override
  void onInit() async {
    if (await Utils.getIntValueWithKey(Constant.NOTIFICATION) == 2) {
      isNotification.value = false;
    } else {
      isNotification.value = true;
    }
    // TODO: implement onInit
    super.onInit();
  }
}
