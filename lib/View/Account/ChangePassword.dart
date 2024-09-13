import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/ChangePasswordController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var delete = Get.delete<ChangePasswordController>();
  ChangePasswordController controller = Get.put(ChangePasswordController());

  @override
  void initState() {
    // TODO: implement initState
    controller.initData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    delete;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Obx(
        () =>
          Container(
            width: 350,
            // padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
            // borderRadius:BorderRadius.circular(24)),
            ),
            child: controller.isLoading.value == false
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child:
                                Text(TextByNation.getStringByKey('change_pass'),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      // color: ColorValue.textColor,
                                    )),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 28,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 350,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorValue
                                    .colorBorder, // Set the border color
                                width: 1.5, // Set the border width
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                        obscureText: controller.isHidePass.value,
                                        controller: controller.passOld.value,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          labelText: TextByNation.getStringByKey(
                                              'pass_old'),
                                          labelStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: ColorValue.colorBorder),
                                          isDense: true,
                                          contentPadding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          border: InputBorder.none,
                                          suffixIcon: InkWell(
                                            onTap: () {
                                              controller.isHidePass.value =
                                                  !controller.isHidePass.value;
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  controller.isHidePass.value
                                                      ? 'asset/icons/hidden.svg'
                                                      : 'asset/icons/eye_login.svg',
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  SizedBox(width: 6),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorValue.colorBorder, // Set the border color
                            width: 1.5, // Set the border width
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: TextFormField(
                                    obscureText: controller.isHidePassNew.value,
                                    controller: controller.passNew.value,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText:
                                          TextByNation.getStringByKey('pass_new'),
                                      labelStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: ColorValue.colorBorder),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      border: InputBorder.none,
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
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorValue.colorBorder, // Set the border color
                            width: 1.5, // Set the border width
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                child: TextFormField(
                                    // onChanged: (value) {
                                    //   controller.passNewRe.value.text =
                                    //       value;
                                    // },
                                    obscureText: controller.isHidePassNewEn.value,
                                    controller: controller.passNewRe.value,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: TextByNation.getStringByKey(
                                          'pass_new_en'),
                                      labelStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: ColorValue.colorBorder),
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      border: InputBorder.none,
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
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 28,),
                      Opacity(
                        opacity: controller.isActive.value == false ? 0.5 : 1,
                        child: GestureDetector(
                          onTap: () {
                            controller.isActive.value == false
                                ? () {}
                                : controller.changePassWord();
                          },
                          child: Container(
                            width: 350,
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
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
      ),
    );
  }
}
