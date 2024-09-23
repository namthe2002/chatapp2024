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
import 'package:live_yoko/Navigation/RouteDefine.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';
import '../../Navigation/Navigation.dart';
import '../../Utils/enum.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Size size = const Size(0, 0);
  late FocusNode _focusNode;
  late FocusNode _passFocusNode;
  late LoginController controller;
  bool _isButtonEnabled = false;

  @override
  @override
  void initState() {
    _focusNode = FocusNode();
    _passFocusNode = FocusNode();
    controller = Get.put(LoginController());
    controller.textUserName.addListener(_checkFields);
    controller.textPass.addListener(_checkFields);
    super.initState();
  }

  void _checkFields() {
    setState(() {
      _isButtonEnabled = controller.textUserName.text.isNotEmpty && controller.textPass.text.isNotEmpty;
    });
  }

  void dispose() {
    _focusNode.dispose();
    _passFocusNode.dispose();
    Get.delete<LoginController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Utils.isDesktopWeb(context) ? 0 : 15),
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset(
                'asset/images/img_theme_login.png',
                width: MediaQuery.of(context).size.width,
              ).image,
            ),
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
              Color(0xFF0CBE8C).withOpacity(1),
              Color(0xFF5B72DE).withOpacity(1),
            ])),
        child: Center(
          child: Container(
            width: 480,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
            ),
            padding: EdgeInsets.all(32),
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  children: [
                    SvgPicture.asset(
                      'asset/images/logo.svg',
                      width: 170,
                      height: 120,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      AppLocalizations.of(context)!.label_welcome_web,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500, height: 32 / 24, color: ColorValue.neutralColor, fontStyle: FontStyle.normal),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      // TextByNation.getStringByKey('login_content'),
                      AppLocalizations.of(context)!.label_welcome_web_2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 24 / 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                      ),
                      child: TextField(
                        controller: controller.textUserName,
                        focusNode: _focusNode,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.phone_number,
                          floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                          labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          border: InputBorder.none,
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: controller.textUserName,
                            builder: (context, value, child) {
                              // Hiển thị icon khi có focus và có text
                              return _focusNode.hasFocus && value.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        controller.textUserName.clear();
                                      },
                                      child: Icon(Icons.clear_rounded),
                                    )
                                  : SizedBox.shrink();
                            },
                          ),
                        ),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                      ),
                      child: TextField(
                        obscureText: controller.isHidePassword.value,
                        controller: controller.textPass,
                        focusNode: _passFocusNode,
                        maxLength: 30,
                        onChanged: (value) {},
                        onSubmitted: (value) async {
                          if (_isButtonEnabled) {
                            controller.isLoading.value = true;
                            await Utils.login(context: context, userName: controller.textUserName.text, password: controller.textPass.text);
                            controller.isLoading.value = false;
                          } else {
                            controller.isLoading.value = true;
                            await Future.delayed(Duration(seconds: 4));
                            controller.isLoading.value = false;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: TextByNation.getStringByKey('password'),
                          floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                          labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          border: InputBorder.none,
                          suffixIcon: InkWell(
                            onTap: () {
                              controller.isHidePassword.value = !controller.isHidePassword.value;
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: SvgPicture.asset(controller.isHidePassword.value ? 'asset/icons/hidden.svg' : 'asset/icons/eye_login.svg',
                                  fit: BoxFit.cover),
                            ),
                          ),
                          counterText: '',
                        ),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigation.navigateTo(page: RouteDefine.forgotPassword);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          TextByNation.getStringByKey('forgotpass'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(17, 185, 145, 1),
                            height: 24 / 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => GestureDetector(
                        onTap: () async {
                          if (_isButtonEnabled) {
                            controller.isLoading.value = true;
                            await Utils.login(context: context, userName: controller.textUserName.text, password: controller.textPass.text);
                            controller.isLoading.value = false;
                          } else {
                            controller.isLoading.value = true;
                            await Future.delayed(Duration(seconds: 2));
                            controller.isLoading.value = false;
                          }
                        },
                        child: Container(
                          width: size.width,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: _isButtonEnabled
                                  ? [
                                      Color.fromRGBO(12, 190, 140, 1).withOpacity(1),
                                      Color.fromRGBO(91, 114, 222, 1).withOpacity(1),
                                    ]
                                  : [
                                      Color.fromRGBO(12, 190, 140, 1).withOpacity(0.5),
                                      Color.fromRGBO(91, 114, 222, 1).withOpacity(0.5),
                                    ],
                              stops: [0.0607, 0.9222],
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                TextByNation.getStringByKey('login'),
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white, height: 24 / 16),
                                textAlign: TextAlign.center,
                              )),
                              controller.isLoading.value
                                  ? SizedBox(
                                      height: 23.5,
                                      width: 23.5,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Icon(
                                      Icons.arrow_right_alt_rounded,
                                      color: Colors.white,
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SingleTapDetector(
                              onTap: () {
                                Navigation.navigateTo(page: RouteDefine.loginQr);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                      begin: Alignment(-1.0, 0.0),
                                      // Start at the left
                                      end: Alignment(1.0, 0.0),
                                      colors: [
                                        Color(0xFF98B3D3),
                                        Color(0xFF6288B6),
                                      ],
                                      stops: [
                                        0.0109,
                                        0.9891
                                      ]),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.label_login_by_qr,
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white, height: 24 / 16),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: SingleTapDetector(
                              onTap: () {
                                Navigation.navigateTo(page: RouteDefine.register);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(begin: Alignment(-1.0, 0.0), end: Alignment(1.0, 0.0), colors: [
                                      Color(0xFF0CBE8C),
                                      Color(0xFF5B72DE),
                                    ], stops: [
                                      0.0607,
                                      0.9222
                                    ])),
                                child: Text(
                                  AppLocalizations.of(context)!.label_register,
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white, height: 24 / 16),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bottomSheetSingUp() {
    return showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Obx(() => Column(
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
                    child: Padding(
                      padding: EdgeInsets.all(20),
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
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            TextByNation.getStringByKey('sign_up'),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              child: TextField(
                                controller: controller.textOTPRegister,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  labelText: TextByNation.getStringByKey('otp'),
                                  floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                              height: 50,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              child: TextField(
                                controller: controller.textPhoneNumberRegister,
                                onChanged: (value) {},
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: TextByNation.getStringByKey('phone_number'),
                                  floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              child: TextField(
                                controller: controller.textFullNameRegister,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  labelText: TextByNation.getStringByKey('full_name'),
                                  floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              child: TextField(
                                obscureText: controller.isHidePasswordRegister.value,
                                controller: controller.textPassRegister,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  labelText: TextByNation.getStringByKey('password'),
                                  floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      controller.isHidePasswordRegister.value = !controller.isHidePasswordRegister.value;
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                          controller.isHidePasswordRegister.value ? 'asset/icons/hidden.svg' : 'asset/icons/eye_login.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                              ),
                              child: TextField(
                                obscureText: controller.isHidePasswordConfirmRegister.value,
                                controller: controller.textPassConfirmRegister,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  labelText: TextByNation.getStringByKey('enter_password'),
                                  floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                                  labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  border: InputBorder.none,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      controller.isHidePasswordConfirmRegister.value = !controller.isHidePasswordConfirmRegister.value;
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(12),
                                      child: SvgPicture.asset(
                                          controller.isHidePasswordConfirmRegister.value ? 'asset/icons/hidden.svg' : 'asset/icons/eye_login.svg',
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () async {
                              print(" --------- " + controller.isOTP.value.toString());
                              if (controller.isOTP.value) {
                                if (controller.textOTPRegister.text.isNotEmpty) {
                                  if (controller.textOTPRegister.text == controller.otpData) {
                                    await controller.register();
                                    controller.textOTPRegister.clear();
                                    controller.otpData = '';
                                    controller.isOTP.value = !controller.isOTP.value;
                                  } else {
                                    Utils.showToast(
                                      Get.overlayContext!,
                                      TextByNation.getStringByKey('otp_no_valid'),
                                      type: ToastType.SUCCESS,
                                    );
                                    // Utils.showSnackBar(
                                    //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('otp_no_valid'));
                                  }
                                } else {
                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('enter_otp'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('enter_otp'));
                                }
                              } else {
                                if (controller.textPhoneNumberRegister.text.isEmpty) {

                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('phone_empty'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('phone_empty'));
                                } else if (controller.textFullNameRegister.text.isEmpty) {
                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('name_empty'),
                                    type: ToastType.ERROR,
                                  );


                                  // Utils.showSnackBar(
                                      // title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('name_empty'));
                                } else if (controller.textPassRegister.text.isEmpty) {
                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('password_empty'),
                                    type: ToastType.ERROR,
                                  );

                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('password_empty'));
                                } else if (controller.textPassConfirmRegister.text.isEmpty) {

                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('confirm_password_empty'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'),
                                  //     message: TextByNation.getStringByKey('confirm_password_empty'));
                                } else if (controller.textPassConfirmRegister.text.length < 8) {

                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('pass_validate'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('pass_validate'));
                                } else if (controller.textPassConfirmRegister.text.length < 8) {

                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('pass_validate'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('pass_validate'));
                                } else if (controller.textPassConfirmRegister.text != controller.textPassConfirmRegister.text) {
                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('pass_valiate_overlap'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'),
                                  //     message: TextByNation.getStringByKey('pass_valiate_overlap'));
                                } else if (!RegularExpressions.hexPhoneNumber.hasMatch(controller.textPhoneNumberRegister.value.text)) {
                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('phone_no_valid'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('phone_no_valid'));
                                } else if (controller.textPassRegister.text != controller.textPassConfirmRegister.text) {

                                  Utils.showToast(
                                    Get.overlayContext!,
                                    TextByNation.getStringByKey('pass_no_joint'),
                                    type: ToastType.ERROR,
                                  );
                                  // Utils.showSnackBar(
                                  //     title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('pass_no_joint'));
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
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
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
                  ))
                ],
              )),
        ),
      ),
    );
  }

// showForgotPassword(BuildContext context) {
//   showModalBottomSheet(
//       isDismissible: false,
//       backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20.0).r,
//           topRight: Radius.circular(20.0).r,
//         ),
//       ),
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return Obx(() => WillPopScope(
//               onWillPop: () async {
//                 if (controller.forgotPassState.value == 0) {
//                   return true;
//                 } else {
//                   controller.forgotPassState.value = 0;
//                   return false;
//                 }
//               },
//               child: (Padding(
//                 padding: EdgeInsets.all(20.r),
//                 child: (Container(
//                   height: Get.height * 0.9,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.max,
//                     children: [
//                       GestureDetector(
//                           onTap: () {
//                             if (controller.forgotPassState.value == 0) {
//                               Get.close(1);
//                             } else {
//                               controller.forgotPassState.value = 0;
//                             }
//                           },
//                           child: Icon(Icons.arrow_back_ios)),
//                       SizedBox(height: 9.h),
//                       Center(
//                         child: Text(
//                           TextByNation.getStringByKey('forgot_pass'),
//                           style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500, color: const Color.fromARGB(255, 75, 87, 122)),
//                         ),
//                       ),
//                       controller.forgotPassState.value == 0
//                           ? Text(
//                               TextByNation.getStringByKey('forgot_pass_ct'),
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: ColorValue.textColor),
//                             )
//                           : RichText(
//                               text: TextSpan(
//                                 children: <TextSpan>[
//                                   TextSpan(
//                                     text: TextByNation.getStringByKey('forgot_pas_phone') + ' ',
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w400,
//                                       color: Get.isDarkMode ? ColorValue.colorTextDark : ColorValue.neutralColor,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: controller.phoneNumberForgotpass.text.toString(), // name chat
//                                     style: TextStyle(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w400,
//                                       color: ColorValue.colorPrimary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                       SizedBox(
//                         height: 16.h,
//                       ),
//                       if (controller.forgotPassState.value == 0)
//                         Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
//                           ),
//                           child: TextFormField(
//                             controller: controller.phoneNumberForgotpass,
//                             onChanged: (value) {},
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
//                             ],
//                             keyboardType: TextInputType.phone,
//                             //  onSaved: (value) => _phoneNumber = value!,
//                             decoration: InputDecoration(
//                               // labelText: TextByNation.getStringByKey('username'),
//                               labelText: TextByNation.getStringByKey('phone'),
//                               floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
//                               labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
//                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                               border: InputBorder.none,
//                             ),
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                       if (controller.forgotPassState.value == 1)
//                         Column(
//                           children: [
//                             SizedBox(
//                               height: 16.h,
//                             ),
//                             Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
//                               ),
//                               padding: EdgeInsets.all(0),
//                               child: TextFormField(
//                                 controller: controller.otpForgotpass,
//                                 onChanged: (value) {},
//                                 // maxLength: 6,
//                                 inputFormatters: [
//                                   LengthLimitingTextInputFormatter(6),
//                                   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
//                                 ],
//                                 keyboardType: TextInputType.phone,
//                                 //  onSaved: (value) => _phoneNumber = value!,
//                                 decoration: InputDecoration(
//                                   // labelText: TextByNation.getStringByKey('username'),
//                                   labelText: TextByNation.getStringByKey('otp'),
//                                   floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
//                                   labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
//                                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                                   border: InputBorder.none,
//                                 ),
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16.h,
//                             ),
//                             Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
//                               ),
//                               child: TextFormField(
//                                 obscureText: controller.isHidePassNew.value,
//                                 controller: controller.passForgotpass,
//                                 onChanged: (value) {},
//
//                                 keyboardType: TextInputType.phone,
//                                 //  onSaved: (value) => _phoneNumber = value!,
//                                 decoration: InputDecoration(
//                                   suffixIcon: InkWell(
//                                     onTap: () {
//                                       controller.isHidePassNew.value = !controller.isHidePassNew.value;
//                                     },
//                                     child: Padding(
//                                       padding: EdgeInsets.all(12),
//                                       child: SvgPicture.asset(
//                                           controller.isHidePassNew.value ? 'asset/icons/hidden.svg' : 'asset/icons/eye_login.svg',
//                                           fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                   labelText: TextByNation.getStringByKey('pass_new'),
//                                   floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
//                                   labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
//                                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                                   border: InputBorder.none,
//                                 ),
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 16.h,
//                             ),
//                             Container(
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: Get.isDarkMode ? ColorValue.neutralColor : Color.fromRGBO(255, 255, 255, 1),
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
//                               ),
//                               child: TextFormField(
//                                 controller: controller.passRetypeForgotpass,
//                                 onChanged: (value) {},
//                                 obscureText: controller.isHidePassNewEn.value,
//                                 keyboardType: TextInputType.phone,
//                                 //  onSaved: (value) => _phoneNumber = value!,
//                                 decoration: InputDecoration(
//                                   suffixIcon: InkWell(
//                                     onTap: () {
//                                       controller.isHidePassNewEn.value = !controller.isHidePassNewEn.value;
//                                     },
//                                     child: Padding(
//                                       padding: EdgeInsets.all(12),
//                                       child: SvgPicture.asset(
//                                           controller.isHidePassNewEn.value ? 'asset/icons/hidden.svg' : 'asset/icons/eye_login.svg',
//                                           fit: BoxFit.cover),
//                                     ),
//                                   ),
//                                   labelText: TextByNation.getStringByKey('pass_new_en'),
//                                   floatingLabelStyle: TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
//                                   labelStyle: TextStyle(color: Get.isDarkMode ? ColorValue.colorTextDark : Colors.black),
//                                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                                   border: InputBorder.none,
//                                 ),
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
//                               ),
//                             ),
//                           ],
//                         ),
//                       SizedBox(
//                         height: 28.h,
//                       ),
//                       GestureDetector(
//                         onTap: () async {
//                           print("================== " + controller.forgotPassState.value.toString());
//                           if (!controller.isLoading.value) {
//                             controller.isLoading.value = true;
//                             controller.forgotPassState.value == 0 ? controller.forgotpass() : controller.resetPassWord();
//                           }
//                         },
//                         child: Container(
//                           width: size.width,
//                           padding: EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(12)),
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Color.fromRGBO(12, 190, 140, 1),
//                                 Color.fromRGBO(91, 114, 222, 1),
//                               ],
//                               stops: [0.0607, 0.9222],
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                   child: Text(
//                                 TextByNation.getStringByKey('continue'),
//                                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
//                                 textAlign: TextAlign.center,
//                               )),
//                               Icon(
//                                 Icons.arrow_right_alt_rounded,
//                                 color: Colors.white,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 )),
//               )),
//             ));
//       });
// }
}
