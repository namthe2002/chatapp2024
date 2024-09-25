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
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';

import '../../Navigation/RouteDefine.dart';
import 'QrCode/qr_code.dart';

class LoginQr extends StatelessWidget {
  LoginQr({Key? key}) : super(key: key);

  Size size = const Size(0, 0);

  final controller = Get.put(LoginController());

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
            // Image.asset(
            //   'asset/images/img_theme_login.png',
            //   width: MediaQuery.of(context).size.width,
            // ),

            child: Container(
              width: 480,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32, horizontal: 32),
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
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              height: 32 / 24,
                              color: ColorValue.neutralColor,
                              fontStyle: FontStyle.normal),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          // TextByNation.getStringByKey('login_content'),
                          AppLocalizations.of(context)!.label_des_scan_qr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(width: 1, color: Color(0xFFE4E6EC)),
                          ),
                          child: QrGeneratePage(size: 140),
                        ),
                        // QrGeneratePage(),
                        SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.label_use_app_scanning,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            Navigation.goBack(result: true);
                          },
                          child: Container(
                            // height: 48,
                            width: size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(12, 190, 140, 1),
                                  Color.fromRGBO(91, 114, 222, 1)
                                ],
                                stops: [0.0607, 0.9222],
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  AppLocalizations.of(context)!
                                      .label_login_phone_number,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white,
                                      height: 24 / 16),
                                  textAlign: TextAlign.center,
                                )),
                                controller.isLoading.value
                                    ? SizedBox(
                                        height: 23.5,
                                        width: 23.5,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}