import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/UpdateProfileController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/View/Chat/home_chat.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';

class UpdateProfile extends StatefulWidget {
  UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final controller = Get.put(UpdateProfileController());

  Size size = const Size(0, 0);

  @override
  Widget build(BuildContext context) {
    print('avatarUpdatepro ${controller.avatarUser.value}');
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<UpdateProfileController>();
        return true;
      },
      child: Obx(()
        => Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
              height: size.height,
              padding: EdgeInsets.symmetric(
                  horizontal: Utils.isDesktopWeb(context) ? 0 : 15),
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
                  width: 480,
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color:
                        Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          TextByNation.getStringByKey('update_profile_content'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode
                                  ? ColorValue.colorTextDark
                                  : ColorValue.textColor),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: SingleTapDetector(
                            onTap: () async {
                              await controller.getImageFiles(isCamera: false);
                              setState(() {
                              });
                            },
                            child: controller.avatarUser.value.isEmpty
                                ? Image.asset(
                                    'asset/images/img_defaut_avatar.png',
                                    height: 100,
                                    width: 100,
                                  )
                                : ClipOval(
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(),
                                      child: Image.network(
                                        Constant.BASE_URL_IMAGE +
                                            controller.avatarUser.value,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorValue.colorBorder),
                                            width: 48,
                                            height: 48,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        TextByNation.getStringByKey('person_information'),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorValue.colorBorder),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorValue.colorBorder,
                            width: 1.5, // Set the border width
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.only(left: 15),
                        child: TextFormField(
                            controller: controller.firstName,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText:
                                  TextByNation.getStringByKey('first_name'),
                              labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: ColorValue.colorBorder),
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleTapDetector(
                        delayTimeInMillisecond: 2500,
                        onTap: () async {
                          if (controller.isCheckNull.value == false) {
                            Utils.showSnackBar(
                                title:
                                    TextByNation.getStringByKey('notification'),
                                message:
                                    TextByNation.getStringByKey('error_name'));
                          } else {
                            await controller.updateName();
                            setState(() {
                            });
                            Get.offAll(() => HomeChatWebsite());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(colors: [
                                Color(0xff0CBE8C).withOpacity(0.9),
                                Color(0xff5B72DE).withOpacity(0.9),
                              ])),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                                child: Text(
                              TextByNation.getStringByKey('update'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleTapDetector(
                        delayTimeInMillisecond: 2500,
                        onTap: () {
                          Navigation.navigateTo(page: 'ChangePassword');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorValue.colorBrCmr),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                                child: Text(
                              TextByNation.getStringByKey('change_pass'),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorValue.neutralColor),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
