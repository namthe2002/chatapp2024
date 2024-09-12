import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Controller/Chat/GroupCreateController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/View/Chat/GroupCreateStep2.dart';

class GroupCreate extends StatelessWidget {
  var delete = Get.delete<GroupCreateController>();
  GroupCreateController controller = Get.put(GroupCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          // backgroundColor: Colors.white,
          appBar: appBar(),
          body: body(context),
        )));
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Get.width,
        height: Get.height,
        color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 12.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(TextByNation.getStringByKey('friends').toUpperCase(),
                style: TextStyle(
                    fontSize: 12.sp,
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
                            width: 200.w,
                            height: 260.h,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Obx(() => ListView.builder(
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
                          }))),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Color(0xff232323) : Colors.white,
              border: Border(
                top: BorderSide(
                  color: Get.isDarkMode
                      ? Color(0xff232323)
                      : Color(0xfff1f4f3), // Màu sắc của border top
                  width: 1.0, // Độ dày của border top
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Color(0xfff1f4f3).withOpacity(0.5), // Màu sắc của shadow
                  spreadRadius: 1, // Độ phân tán của shadow
                  blurRadius: 4, // Độ mờ của shadow
                  offset: Offset(0, 2), // Vị trí của shadow
                ),
              ],
            ),
            height: 70.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: controller.selectedItems.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 5.0.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  controller.selectedItems[index].avatar !=
                                              null &&
                                          controller.selectedItems[index]
                                              .avatar!.isNotEmpty
                                      ? ClipOval(
                                          child: Container(
                                            width: 48.w,
                                            height: 48.w,
                                            decoration: BoxDecoration(),
                                            child: Image.network(
                                              Constant.BASE_URL_IMAGE +
                                                  controller
                                                      .selectedItems[index]
                                                      .avatar
                                                      .toString(),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: ColorValue
                                                          .colorBorder),
                                                  width: 48.w,
                                                  height: 48.w,
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 48.w,
                                          height: 48.w,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient:
                                                  Utils.getGradientForLetter(
                                                      controller
                                                                  .selectedItems[
                                                                      index]
                                                                  .fullName ==
                                                              null
                                                          ? controller
                                                              .selectedItems[
                                                                  index]
                                                              .userName
                                                              .toString()
                                                          : controller
                                                              .selectedItems[
                                                                  index]
                                                              .fullName
                                                              .toString())),
                                          child: Center(
                                              child: Text(
                                            Utils.getInitialsName(controller
                                                            .selectedItems[
                                                                index]
                                                            .fullName ==
                                                        null
                                                    ? controller
                                                        .selectedItems[index]
                                                        .userName
                                                        .toString()
                                                    : controller
                                                        .selectedItems[index]
                                                        .fullName
                                                        .toString())
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          )),
                                        ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () {
                                          controller.selectedItems.remove(
                                              controller.selectedItems[index]);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1.w,
                                                  color: Colors.white),
                                              shape: BoxShape.circle,
                                              color: Color(0xffe4e6ec)),
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(1),
                                            child: Icon(
                                              Icons.close,
                                              size: 12.sp,
                                            ),
                                          )),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                    ),
                  ),
                  child: FloatingActionButton(
                      elevation: 0, // Tắt đổ bóng
                      focusElevation: 0, // Tắt đổ bóng khi focus
                      hoverElevation: 0, // Tắt đổ bóng khi hover
                      focusColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        ChatController homeController = Get.find<ChatController>();
                        homeController.updateFeature(widget: GroupCreateStep2());
                      },
                      tooltip: 'Create Group',
                      child: Icon(
                        Icons.arrow_forward_outlined,
                        size: 24.sp,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      iconTheme: IconThemeData(
          color: Get.isDarkMode ? Colors.white : ColorValue.neutralColor),
      centerTitle: true,
      elevation: 0,
      title: controller.isSearch.value == false
          ? Text(TextByNation.getStringByKey('new_group'),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ))
          : TextFormField(
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
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorValue.colorBorder),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorValue.textColor)),
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
              size: 24.sp,
            )),
        SizedBox(
          width: 20.w,
        )
      ],
    );
  }

  chatItem(BuildContext context, int index) {
    return Obx(() => (InkWell(
          onTap: () async {
            if (controller.isUuidInSelectedItems(
                    controller.listContact[index].uuid!) ==
                false) {
              controller.selectedItems.add(controller.listContact[index]);
            } else {
              int indexItem = controller.selectedItems.indexWhere((element) =>
                  controller.listContact[index].uuid == element.uuid);
              controller.selectedItems.removeAt(indexItem);
            }
          },
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
              child: Row(
                children: [
                  Stack(
                    children: [
                      controller.listContact[index].avatar != null &&
                              controller.listContact[index].avatar!.isNotEmpty
                          ? ClipOval(
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(),
                                child: Image.network(
                                  Constant.BASE_URL_IMAGE +
                                      controller.listContact[index].avatar
                                          .toString(),
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorValue.colorBorder),
                                      width: 48.w,
                                      height: 48.w,
                                    );
                                  },
                                ),
                              ),
                            )
                          : Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: Utils.getGradientForLetter(
                                      controller.listContact[index].fullName ==
                                              null
                                          ? controller
                                              .listContact[index].userName
                                              .toString()
                                          : controller
                                              .listContact[index].fullName
                                              .toString())),
                              child: Center(
                                  child: Text(
                                Utils.getInitialsName(controller
                                                .listContact[index].fullName ==
                                            null
                                        ? controller.listContact[index].userName
                                            .toString()
                                        : controller.listContact[index].fullName
                                            .toString())
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18.sp,
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
                  SizedBox(width: 12.w),
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? ColorValue.colorTextDark
                                : ColorValue.textColor),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        TextByNation.getStringByKey('last_seen') +
                            ' ' +
                            Utils.getTimeMessage(
                                controller.listContact[index].lastSeen!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Get.isDarkMode
                                ? ColorValue.colorTextDark
                                : ColorValue.colorBorder),
                      ),
                    ],
                  )),
                  // controller.selectedItems
                  //         .contains(controller.listContact[index])
                  controller.isUuidInSelectedItems(
                          controller.listContact[index].uuid!)
                      ? Container(
                          height: 20.sp,
                          width: 20.sp,
                          child: Icon(
                            Icons.check_circle,
                            color: ColorValue.colorPrimary,
                          ),
                        )
                      : Container(
                          height: 20.sp,
                          width: 20.sp,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 1.5.sp,
                                  color: ColorValue.colorBorder)),
                        ),
                ],
              ),
            ),
          ),
        )));
  }
}
