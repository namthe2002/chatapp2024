import 'package:get/get.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _init();
  }
  void _init() async {
    await Future.delayed(
        Duration(seconds: 3)); // Increased to 7 seconds for testing
    String accessToken =
        await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
    print('Access Token: $accessToken');
    if (accessToken.isEmpty) {
      Navigation.navigateGetOffAll(page: 'Login');
    } else {
      await Utils.login();
    }
  }
}
