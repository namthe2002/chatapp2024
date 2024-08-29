import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/LoginController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/RegularExpressions.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';

import '../../../Navigation/Navigation.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  Size size = const Size(0, 0);
  late FocusNode _focusNode;
  late LoginController controller;
  bool _isButtonEnabled = false;

  @override
  @override
  void initState() {
    _focusNode = FocusNode();
    controller = Get.put(LoginController());
    controller.textUserName.addListener(_checkFields);
    controller.textPass.addListener(_checkFields);
    super.initState();
  }

  void _checkFields() {
    setState(() {
      _isButtonEnabled = controller.textUserName.text.isNotEmpty &&
          controller.textPass.text.isNotEmpty;
    });
  }

  void dispose() {
    _focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          if (controller.forgotPassState.value == 0) {
            return true;
          } else {
            controller.forgotPassState.value = 0;
            return false;
          }
        },
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Utils.isDesktopWeb(context) ? 0 : 15),
            height: size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.asset(
                    'asset/images/img_theme_login.png',
                    width: MediaQuery.of(context).size.width,
                  ).image,
                ),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0CBE8C).withOpacity(1),
                      Color(0xFF5B72DE).withOpacity(1),
                    ])),
            child: Center(
              child: Obx(
                () => Container(
                  width: 400,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller.forgotPassState.value == 0) {
                            Get.close(1);
                          } else {
                            controller.forgotPassState.value = 0;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              TextByNation.getStringByKey('back_login'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28),
                      Center(
                        child: Text(
                          TextByNation.getStringByKey('forgot_pass'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: ColorValue.neutralColor,
                            height: 32/24,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      controller.forgotPassState.value == 0
                          ? Text(
                              TextByNation.getStringByKey('forgot_pass_ct'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 24/14,
                                  color:Get.isDarkMode
                                      ? ColorValue.colorTextDark
                                      : ColorValue.neutralColor),
                            )
                          : RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: TextByNation.getStringByKey(
                                            'forgot_pas_phone') +
                                        ' ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 24/14,
                                      color: Get.isDarkMode
                                          ? ColorValue.colorTextDark
                                          : ColorValue.neutralColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: controller.phoneNumberForgotpass.text
                                        .toString(), // name chat
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: ColorValue.colorPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 16,
                      ),
                      if (controller.forgotPassState.value == 0)
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ColorValue.neutralColor
                                : Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(228, 230, 236, 1)),
                          ),
                          child: TextFormField(
                            controller: controller.phoneNumberForgotpass,
                            onChanged: (value) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9+]')),
                            ],
                            keyboardType: TextInputType.phone,
                            //  onSaved: (value) => _phoneNumber = value!,
                            decoration: InputDecoration(
                              // labelText: TextByNation.getStringByKey('username'),
                              labelText: TextByNation.getStringByKey('phone'),
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromRGBO(17, 185, 145, 1)),
                              labelStyle: TextStyle(
                                  color: Get.isDarkMode
                                      ? ColorValue.colorTextDark
                                      : Colors.black),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      if (controller.forgotPassState.value == 1)
                        Column(
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? ColorValue.neutralColor
                                    : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              padding: EdgeInsets.all(0),
                              child: TextFormField(
                                controller: controller.otpForgotpass,
                                onChanged: (value) {},
                                // maxLength: 6,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                keyboardType: TextInputType.phone,
                                //  onSaved: (value) => _phoneNumber = value!,
                                decoration: InputDecoration(
                                  // labelText: TextByNation.getStringByKey('username'),
                                  labelText: TextByNation.getStringByKey('otp'),
                                  floatingLabelStyle: TextStyle(
                                      color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(
                                      color: Get.isDarkMode
                                          ? ColorValue.colorTextDark
                                          : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? ColorValue.neutralColor
                                    : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              child: TextFormField(
                                obscureText: controller.isHidePassNew.value,
                                controller: controller.passForgotpass,
                                onChanged: (value) {},

                                keyboardType: TextInputType.phone,
                                //  onSaved: (value) => _phoneNumber = value!,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      controller.isHidePassNew.value =
                                          !controller.isHidePassNew.value;
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                          controller.isHidePassNew.value
                                              ? 'asset/icons/hidden.svg'
                                              : 'asset/icons/eye_login.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  labelText:
                                      TextByNation.getStringByKey('pass_new'),
                                  floatingLabelStyle: TextStyle(
                                      color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(
                                      color: Get.isDarkMode
                                          ? ColorValue.colorTextDark
                                          : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode
                                    ? ColorValue.neutralColor
                                    : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              child: TextFormField(
                                controller: controller.passRetypeForgotpass,
                                onChanged: (value) {},
                                obscureText: controller.isHidePassNewEn.value,
                                keyboardType: TextInputType.phone,
                                //  onSaved: (value) => _phoneNumber = value!,
                                decoration: InputDecoration(
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      controller.isHidePassNewEn.value =
                                          !controller.isHidePassNewEn.value;
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                          controller.isHidePassNewEn.value
                                              ? 'asset/icons/hidden.svg'
                                              : 'asset/icons/eye_login.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  labelText: TextByNation.getStringByKey(
                                      'pass_new_en'),
                                  floatingLabelStyle: TextStyle(
                                      color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(
                                      color: Get.isDarkMode
                                          ? ColorValue.colorTextDark
                                          : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 28,
                      ),
                      GestureDetector(
                        onTap: () async {
                          print("================== " +
                              controller.forgotPassState.value.toString());
                          if (!controller.isLoading.value) {
                            controller.isLoading.value = true;
                            controller.forgotPassState.value == 0
                                ? controller.forgotpass()
                                : controller.resetPassWord();
                          }
                        },
                        child: Container(
                          width: size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromRGBO(12, 190, 140, 1),
                                Color.fromRGBO(91, 114, 222, 1),
                              ],
                              stops: [0.0607, 0.9222],
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                TextByNation.getStringByKey('continue'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              )),
                              Icon(
                                Icons.arrow_right_alt_rounded,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
