import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/AddAccountController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Chat/PositionType.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Utils/enum.dart';

class AddAccount extends StatelessWidget {
  AddAccount({Key? key}) : super(key: key);

  Size size = const Size(0, 0);

  final controller = Get.put(AddAccountController());

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<AddAccountController>();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(TextByNation.getStringByKey('add_account')),
        ),
        body: Container(
          color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ColorValue.neutralColor
                          : Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                    ),
                    child: TextField(
                      controller: controller.userName,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: TextByNation.getStringByKey('username'),
                        floatingLabelStyle:
                            TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                        labelStyle: TextStyle(
                            color: Get.isDarkMode
                                ? ColorValue.colorTextDark
                                : Colors.black),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                          width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                    ),
                    child: TextField(
                      controller: controller.email,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: TextByNation.getStringByKey('email'),
                        floatingLabelStyle:
                            TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                        labelStyle: TextStyle(
                            color: Get.isDarkMode
                                ? ColorValue.colorTextDark
                                : Colors.black),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                          width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                    ),
                    child: TextField(
                      controller: controller.firstName,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        labelText: TextByNation.getStringByKey('first_name'),
                        floatingLabelStyle:
                            TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                        labelStyle: TextStyle(
                            color: Get.isDarkMode
                                ? ColorValue.colorTextDark
                                : Colors.black),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: InputBorder.none,
                      ),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  // Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     color: Get.isDarkMode
                  //         ? ColorValue.neutralColor
                  //         : Color.fromRGBO(255, 255, 255, 1),
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(
                  //         width: 1,
                  //         color: Color.fromRGBO(228, 230, 236, 1)),
                  //   ),
                  //   child: TextField(
                  //     controller: controller.lastName,
                  //     onChanged: (value) {},
                  //     decoration: InputDecoration(
                  //       labelText: TextByNation.getStringByKey('last_name'),
                  //       floatingLabelStyle: TextStyle(
                  //           color: Color.fromRGBO(17, 185, 145, 1)),
                  //       labelStyle: TextStyle(
                  //           color: Get.isDarkMode
                  //               ? ColorValue.colorTextDark
                  //               : Colors.black),
                  //       contentPadding: EdgeInsets.symmetric(
                  //           horizontal: 16, vertical: 10),
                  //       border: InputBorder.none,
                  //     ),
                  //     style: TextStyle(
                  //         fontSize: 14, fontWeight: FontWeight.w400),
                  //   ),
                  // ),
                  // SizedBox(height: 16,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ColorValue.neutralColor
                          : Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1, color: Color.fromRGBO(228, 230, 236, 1)),
                    ),
                    child: DropdownButtonFormField<PositionType>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      value: controller.selectedPosition.value,
                      items: controller.positionList
                          .map<DropdownMenuItem<PositionType>>(
                              (PositionType value) {
                        return DropdownMenuItem<PositionType>(
                          value: value,
                          child: Text(value.title!),
                        );
                      }).toList(),
                      onChanged: (PositionType? value) {
                        controller.selectedPosition.value = value!;
                      },
                    ),
                  ),
                ],
              )),
              Container(
                padding: EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () async {
                    if (controller.userName.text.isEmpty) {
                      Utils.showToast(
                        Get.overlayContext!,
                        TextByNation.getStringByKey('user_name_empty'),
                        type: ToastType.ERROR,
                      );
                      // Utils.showSnackBar(
                      //     title: TextByNation.getStringByKey('notification'),
                      //     message:
                      //         TextByNation.getStringByKey('user_name_empty'));
                    } else if (controller.email.text.isEmpty) {
                      Utils.showToast(
                        Get.overlayContext!,
                        TextByNation.getStringByKey('email_empty'),
                        type: ToastType.ERROR,
                      );


                      // Utils.showSnackBar(
                      //     title: TextByNation.getStringByKey('notification'),
                      //     message: TextByNation.getStringByKey('email_empty'));
                    } else if (!controller.hexEmail
                        .hasMatch(controller.email.text)) {


                      Utils.showToast(
                        Get.overlayContext!,
                        TextByNation.getStringByKey('email_format'),
                        type: ToastType.ERROR,
                      );
                      // Utils.showSnackBar(
                      //     title: TextByNation.getStringByKey('notification'),
                      //     message: TextByNation.getStringByKey('email_format'));
                    } else if (controller.firstName.text.isEmpty) {

                      Utils.showToast(
                        Get.overlayContext!,
                        TextByNation.getStringByKey('name_empty'),
                        type: ToastType.ERROR,
                      );

                      // Utils.showSnackBar(
                      //     title: TextByNation.getStringByKey('notification'),
                      //     message: TextByNation.getStringByKey('name_empty'));
                    } else {
                      await controller.changeGroupInfo();
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
                    child: Text(
                      TextByNation.getStringByKey('create'),
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
