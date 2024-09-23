import 'package:get/get.dart';

import 'RouteDefine.dart';

class Navigation {
  static String currentPageName = '';
  static dynamic currentParam;

  static Future<dynamic>? navigateTo({required String page, dynamic arguments, Transition? transition}) {
    currentParam = null;
    if (arguments != null) {
      currentParam = arguments;
    }
    currentPageName = page;
    return Get.toNamed(page, arguments: arguments);
  }

  static Future<dynamic>? navigateTo1({
    required String page,
    dynamic arguments,
    Transition? transition,
  }) {
    currentParam = arguments;
    currentPageName = page;

    return Get.toNamed(page, arguments: arguments);
  }

  static void goBack({Object? result, dynamic arguments}) {
    currentParam = null;
    if (arguments != null) {
      currentParam = arguments;
    }
    Get.back(result: result);
  }

  static void goBack2({Object? result, dynamic arguments}) {
    currentParam = null;
    if (arguments != null) {
      currentParam = arguments;
    }
  }

  // static void navigateGetxOff({required String routeName, dynamic arguments}) {
  //   Get.offNamed(routeName, arguments: arguments);
  // }

  static void navigateGetxOff({required String routeName, String? conversationId, dynamic arguments}) {
    Get.offNamed('$routeName/${conversationId ?? ''}', arguments: arguments);
  }

  static void navigateGetxOffAll({required String routeName, dynamic arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }

  static void navigateGetOffAll({required String page, dynamic arguments}) {
    currentParam = null;
    if (arguments != null) {
      currentParam = arguments;
    }
    Get.offAll(() => RouteDefine.getPageByName(page), transition: Transition.rightToLeft, arguments: arguments);
  }
}
