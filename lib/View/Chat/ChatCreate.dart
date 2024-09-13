import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Controller/Chat/ChatCreateController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';

import 'GroupCreate.dart';

class ChatCreate extends StatelessWidget {
  var delete = Get.delete<ChatCreateController>();
  ChatCreateController controller = Get.put(ChatCreateController());

  final VoidCallback? callback;
  ChatCreate({super.key,this.callback});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          appBar: appBar(),
          body: body(),
        )));
  }

  SafeArea body() {
    return SafeArea(
      child: Container(
        width: Get.width,
        height: Get.height,
        color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (controller.roleId.value == 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: InkWell(
                onTap: () {
                  Get.find<ChatController>().updateFeature(widget: GroupCreate(callback: () {  },));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Color(0xff232323)
                          : Color(0xffc9fad9),
                      border: Border.all(width: 1, color: Color(0xFFabe0d3)),
                      borderRadius: BorderRadius.circular(8)),
                  width: Get.width,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'asset/icons/group_add.svg',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          TextByNation.getStringByKey('new_group'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorValue.colorPrimary),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(TextByNation.getStringByKey('friends'),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorValue.colorBorder)),
          ),
          Expanded(
              child: controller.isLoangding.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.listContact.length == 0
                      ? Center(
                          child: SvgPicture.asset(
                            'asset/icons/no_friend.svg',
                            width: 200,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ListView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.listContact.length,
                          itemBuilder: (context, index) {
                            if (index < controller.listContact.length) {
                              return chatItem(context, index);
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Center(
                                    child: controller.hasMore.value
                                        ? CircularProgressIndicator()
                                        : Container()),
                              );
                            }
                          })),
        ]),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Get.isDarkMode ? Colors.white : ColorValue.neutralColor),
      // centerTitle: true,
      elevation: 0,
      titleSpacing: 15,
      leading: IconButton(onPressed: () {
       callback?.call();

      }

      , icon: Icon(Icons.arrow_back)),
      title: controller.isSearch.value == false
          ? Text(TextByNation.getStringByKey('create_chat'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 28/20,
              ))
          : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
                controller: controller.filterController.value,
                onChanged: (value) {
                  controller.isLoangding.value = true;
                  if (controller.debounce?.isActive ?? false)
                    controller.debounce?.cancel();

                  controller.debounce =
                      Timer(Duration(milliseconds: 2000), () async {
                    await controller.resetFriend();
                  });
                  controller.keyword.value = value;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  hintText: TextByNation.getStringByKey('search_friend'),
                  hintStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color:
                          Get.isDarkMode ? Colors.white : ColorValue.colorBorder),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode ? Colors.white : ColorValue.textColor)),
          ),
      actions: [
        InkWell(
            onTap: () async {
              if (controller.isSearch.value == false) {
                controller.isSearch.value = true;
              } else {
                controller.filterController.value.text = await '';

                controller.isSearch.value = !controller.isSearch.value;
                if (controller.keyword.value != '') {
                  await controller.resetFriend();
                }
              }
            },
            child: Icon(
              controller.isSearch.value ? Icons.close : Icons.search_outlined,
              size: 24,
            )),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  chatItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        controller.createRoom(index);
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            children: [
              Stack(
                children: [
                  controller.listContact[index].avatar != null &&
                          controller.listContact[index].avatar!.isNotEmpty
                      ? ClipOval(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(),
                            child: Image.network(
                              Constant.BASE_URL_IMAGE +
                                  controller.listContact[index].avatar
                                      .toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
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
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: Utils.getGradientForLetter(
                                  controller.listContact[index].fullName == null
                                      ? controller.listContact[index].userName
                                          .toString()
                                      : controller.listContact[index].fullName
                                          .toString())),
                          child: Center(
                              child: Text(
                            Utils.getInitialsName(
                                    controller.listContact[index].fullName ==
                                            null
                                        ? controller.listContact[index].userName
                                            .toString()
                                        : controller.listContact[index].fullName
                                            .toString())
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
                        )
                  // Positioned(
                  //   right: 3,
                  //   bottom: 3,
                  //   child: Container(
                  //       width: 10.r,
                  //       height: 10.r,
                  //       decoration: BoxDecoration(
                  //         border: Border.all(
                  //           color: Colors.white, // Màu của viền
                  //           width: 2, // Độ dày của viền
                  //         ),
                  //         shape: BoxShape.circle,
                  //         // gradient: LinearGradient(colors: [
                  //         //   Color(0xff39EFA2),
                  //         //   Color(0xff39EFA2),
                  //         //   // Color(0xff48C6D7)
                  //         // ]
                  //         color: Color(0xff39EFA2),
                  //       )),
                  // )
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.listContact[index].fullName == null
                        ? controller.listContact[index].userName.toString()
                        : controller.listContact[index].fullName.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Get.isDarkMode
                            ? ColorValue.colorTextDark
                            : ColorValue.textColor),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    TextByNation.getStringByKey('last_seen') +
                        ' ' +
                        Utils.getTimeMessage(
                            controller.listContact[index].lastSeen!),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Get.isDarkMode
                            ? ColorValue.colorTextDark
                            : ColorValue.colorBorder),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
