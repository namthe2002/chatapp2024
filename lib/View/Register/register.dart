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

import '../../Navigation/Navigation.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Size size = const Size(0, 0);
  late FocusNode _focusNode;
  late LoginController controller;
  bool _isButtonEnabled = false;

  @override
  @override
  void initState() {
    _focusNode = FocusNode();
    controller = Get.put(LoginController());
    controller.textPhoneNumberRegister.addListener(_checkFields);
    controller.textFullNameRegister.addListener(_checkFields);
    controller.textPassRegister.addListener(_checkFields);
    controller.textPassConfirmRegister.addListener(_checkFields);
    super.initState();
  }

  void _checkFields() {
    setState(() {
      _isButtonEnabled = controller.textPhoneNumberRegister.text.isNotEmpty &&
          controller.textFullNameRegister.text.isNotEmpty &&
          controller.textPassRegister.text.isNotEmpty &&
          controller.textPassConfirmRegister.text.isNotEmpty;
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
        Get.delete<LoginController>();
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
            child: Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
              ),
              width: 480,
              child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (controller.isOTP.value) {
                            controller.textOTPRegister.clear();
                            controller.otpData = '';
                            controller.isOTP.value = !controller.isOTP.value;
                          } else {
                            Navigator.pop(context);
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
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        TextByNation.getStringByKey('sign_up'),
                        style: TextStyle(
                          fontSize: 24,
                          height: 32 / 24,
                          fontWeight: FontWeight.w500,
                          color: ColorValue.neutralColor,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      if (controller.isOTP.value) ...[
                        Text(
                          TextByNation.getStringByKey('we_code_phone'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          // height: 50,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ColorValue.neutralColor
                                : Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(228, 230, 236, 1)),
                          ),
                          child: TextField(
                            controller: controller.textOTPRegister,
                            onChanged: (value) {},
                            decoration: InputDecoration(
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
                      ] else ...[
                        Text(
                          TextByNation.getStringByKey('information_join'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? ColorValue.neutralColor
                                : Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(228, 230, 236, 1)),
                          ),
                          child: TextField(
                            controller: controller.textPhoneNumberRegister,
                            onChanged: (value) {},
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText:
                                  TextByNation.getStringByKey('phone_number'),
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
                          height: 16,
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
                          child: TextField(
                            controller: controller.textFullNameRegister,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              labelText:
                                  TextByNation.getStringByKey('full_name'),
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
                          height: 16,
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
                          child: TextField(
                            obscureText:
                                controller.isHidePasswordRegister.value,
                            controller: controller.textPassRegister,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              labelText:
                                  TextByNation.getStringByKey('password'),
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromRGBO(17, 185, 145, 1)),
                              labelStyle: TextStyle(
                                  color: Get.isDarkMode
                                      ? ColorValue.colorTextDark
                                      : Colors.black),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.isHidePasswordRegister.value =
                                      !controller.isHidePasswordRegister.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHidePasswordRegister.value
                                          ? 'asset/icons/hidden.svg'
                                          : 'asset/icons/eye_login.svg',
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 16,
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
                          child: TextField(
                            obscureText:
                                controller.isHidePasswordConfirmRegister.value,
                            controller: controller.textPassConfirmRegister,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              labelText:
                                  TextByNation.getStringByKey('enter_password'),
                              floatingLabelStyle: TextStyle(
                                  color: Color.fromRGBO(17, 185, 145, 1)),
                              labelStyle: TextStyle(
                                  color: Get.isDarkMode
                                      ? ColorValue.colorTextDark
                                      : Colors.black),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller
                                          .isHidePasswordConfirmRegister.value =
                                      !controller
                                          .isHidePasswordConfirmRegister.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHidePasswordConfirmRegister
                                              .value
                                          ? 'asset/icons/hidden.svg'
                                          : 'asset/icons/eye_login.svg',
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: () async {
                          print(" --------- " +
                              controller.isOTP.value.toString());
                          if (controller.isOTP.value) {
                            if (controller.textOTPRegister.text.isNotEmpty) {
                              if (controller.textOTPRegister.text ==
                                  controller.otpData) {
                                await controller.register();
                                controller.textOTPRegister.clear();
                                controller.otpData = '';
                                controller.isOTP.value =
                                    !controller.isOTP.value;
                              } else {
                                Utils.showSnackBar(
                                    title: TextByNation.getStringByKey(
                                        'notification'),
                                    message: TextByNation.getStringByKey(
                                        'otp_no_valid'));
                              }
                            } else {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message:
                                      TextByNation.getStringByKey('enter_otp'));
                            }
                          } else {
                            if (controller
                                .textPhoneNumberRegister.text.isEmpty) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'phone_empty'));
                            } else if (controller
                                .textFullNameRegister.text.isEmpty) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'name_empty'));
                            } else if (controller
                                .textPassRegister.text.isEmpty) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'password_empty'));
                            } else if (controller
                                .textPassConfirmRegister.text.isEmpty) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'confirm_password_empty'));
                            } else if (controller
                                    .textPassConfirmRegister.text.length <
                                8) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'pass_validate'));
                            } else if (controller
                                    .textPassConfirmRegister.text.length <
                                8) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'pass_validate'));
                            } else if (controller
                                    .textPassConfirmRegister.text !=
                                controller.textPassConfirmRegister.text) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'pass_valiate_overlap'));
                            } else if (!RegularExpressions.hexPhoneNumber
                                .hasMatch(controller
                                    .textPhoneNumberRegister.value.text)) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'phone_no_valid'));
                            } else if (controller.textPassRegister.text !=
                                controller.textPassConfirmRegister.text) {
                              Utils.showSnackBar(
                                  title: TextByNation.getStringByKey(
                                      'notification'),
                                  message: TextByNation.getStringByKey(
                                      'pass_no_joint'));
                            } else {
                              if (controller.otpData.isEmpty) {
                                await controller.otp();
                              }
                            }
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
                              colors: _isButtonEnabled
                                  ? [
                                      Color.fromRGBO(12, 190, 140, 1),
                                      Color.fromRGBO(91, 114, 222, 1),
                                    ]
                                  : [
                                      Color.fromRGBO(12, 190, 140, 1)
                                          .withOpacity(0.5),
                                      Color.fromRGBO(91, 114, 222, 1)
                                          .withOpacity(0.5),
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
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

// bottomSheetSingUp() {Icons
//   return showModalBottomSheet(
//     context: Get.context!,
//     isScrollControlled: true,
//     enableDrag: true,
//     backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
//     shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         )),
//     builder: (context) =>
//         DraggableScrollableSheet(
//           initialChildSize: 0.9,
//           expand: false,
//           builder: (context, scrollController) =>
//               ,
//         ),
//   );
// }
}
