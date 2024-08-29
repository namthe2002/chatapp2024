import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Utils/Utils.dart';

class ChatSettingController extends GetxController {
  RxDouble currentSliderValue = 14.0.obs;
  RxInt selectColor = 0.obs;

  @override
  void onInit() async {
    int sizeText = await Utils.getIntValueWithKey(Constant.SIZE_TEXT);
    currentSliderValue.value =
        sizeText.toDouble() == 0 ? 14.0 : sizeText.toDouble();
    selectColor.value = await Utils.getIntValueWithKey(Constant.SELECT_COLOR);

    // TODO: implement onInit
    super.onInit();
  }

  RxList<ThemeColor> listThemeColor = [
    ThemeColor(
        colorBackgr: '0xffc9fad9',
        colorBorder: '0xff55b574',
        colorText: '0xff11B991'),
    ThemeColor(
        colorBackgr: '0xffCCF7FE',
        colorBorder: '0xff55AFB5',
        colorText: '0xFF119BB9'),
    ThemeColor(
        colorBackgr: '0xffFFF1CC',
        colorBorder: '0xffAF7F00',
        colorText: '0xFFAF7F00 '),
    ThemeColor(
        colorBackgr: '0xffFCE2D5',
        colorBorder: '0xffD17343',
        colorText: '0xFFD17343'),
    ThemeColor(
        colorBackgr: '0xffC7FAF3',
        colorBorder: '0xff44A497',
        colorText: '0xFF44A497'),
    ThemeColor(
        colorBackgr: '0xffE0DEF3',
        colorBorder: '0xff7873AA',
        colorText: '0xFF544D92'),
    ThemeColor(
        colorBackgr: '0xffFBE2F7',
        colorBorder: '0xff9F3C8F',
        colorText: '0xFF9F3C8F'),
    ThemeColor(
        colorBackgr: '0xffF9D8D8',
        colorBorder: '0xffB74E4E',
        colorText: '0xFFB74E4E'),
  ].obs;
}

class ThemeColor {
  String? colorBackgr, colorBorder, colorText;
  ThemeColor({this.colorBackgr, this.colorBorder, this.colorText});
}
