import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/theme_controler.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';
import '../../Global/Constant.dart';
import '../../Models/Chat/Chat.dart';
import '../../Utils/Utils.dart';

class SelectThemeMode extends StatefulWidget {
  final Chat? chatDetail;

  SelectThemeMode({Key? key, this.chatDetail}) : super(key: key);

  @override
  State<SelectThemeMode> createState() => _SelectThemeModeState();
}

class _SelectThemeModeState extends State<SelectThemeMode> {
  final _homeController = Get.put(ThemeControler());

  @override
  void initState() {
    _homeController.initData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<ThemeControler>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 18),
                child: Text(
                  AppLocalizations.of(context)!.night_mode,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 28 / 20,
                    color: Get.isDarkMode ? ColorValue.colorTextDark : ColorValue.neutralColor,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppLocalizations.of(context)!.choose_mode,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Get.isDarkMode ? ColorValue.colorTextDark : ColorValue.neutralColor,
                      height: 16 / 12),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_homeController.listNode.length, (index) {
                    return Flexible(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          if (index != _homeController.selectBrightnessMode.value) {
                            _homeController.selectBrightnessMode.value = index;
                            changeTheme(index, context);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SvgPicture.asset(
                                _homeController.listNode[index].src!,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _homeController.listNode[index].title!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Radio(
                                groupValue: _homeController.selectBrightnessMode.value,
                                value: index,
                                onChanged: (value) {
                                  if (index != _homeController.selectBrightnessMode.value) {
                                    _homeController.selectBrightnessMode.value = index;
                                    changeTheme(index, context);
                                    // _homeController.checkBrightnessChange();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleTapDetector(
                    onTap: () {
                      Get.forceAppUpdate();
                    },
                    child: Container(
                      width: Get.width,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                            Color(0xFF0CBE8C).withOpacity(1),
                            Color(0xFF5B72DE).withOpacity(1),
                          ])),
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.label_apply,
                        style: TextStyle(
                          color: ColorValue.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 24 / 16,
                        ),
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  changeTheme(int index, BuildContext context) async {
    if (index == 0) {
      await Utils.saveBoolWithKey(Constant.DARK_MODE, false);
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, false);
      Get.changeThemeMode(ThemeMode.light);
    } else if (index == 1) {
      await Utils.saveBoolWithKey(Constant.DARK_MODE, true);
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, false);
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      await Utils.saveBoolWithKey(Constant.AUTO_MODE, true);
      MediaQuery.platformBrightnessOf(context) == Brightness.light ? Get.changeThemeMode(ThemeMode.light) : Get.changeThemeMode(ThemeMode.dark);
    }
    _homeController.selectBrightnessMode.value = index;
  }
}
