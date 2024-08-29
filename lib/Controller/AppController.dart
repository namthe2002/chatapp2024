import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  var appState = Rx<AppLifecycleState>(AppLifecycleState.resumed);

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    appState.value = state;
  }
}
