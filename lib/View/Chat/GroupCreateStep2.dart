import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/GroupCreateController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Controller/Chat/GroupCreateStep2Controller.dart';

class GroupCreateStep2 extends StatelessWidget {
  var delete = Get.delete<GroupCreateStep2Controller>();
  GroupCreateController controller = Get.put(GroupCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          appBar: appBar(),
          body: body(context),
        )));
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        height: Get.height,
        width: Get.width,
        color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? ColorValue.neutralColor
                          : Colors.white),
                  width: Get.width,
                  height: 130,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: ColorValue.colorPrimary.withOpacity(0.5)),
                  width: Get.width,
                  height: 70,
                ),
                controller.avatarUser.value != ''
                    ? ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(),
                          child: Image.network(
                            Constant.BASE_URL_IMAGE +
                                controller.avatarUser.value,
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
                    : Positioned(
                        top: 35,
                        child: GestureDetector(
                          onTap: () async {
                            await controller.getImage();
                          },
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3.r, color: Colors.white),
                                  gradient: LinearGradient(colors: [
                                    Color(0xff0CBE8C),
                                    Color(0xff5B72DE)
                                  ]),
                                  shape: BoxShape.circle),
                              width: 80,
                              height: 80,
                              child: SvgPicture.asset(
                                'asset/icons/select_image.svg',
                                width: 32,
                                height: 32,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ))
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1.5,
                      color: Get.isDarkMode
                          ? Color(0xff232323)
                          : ColorValue.colorBrCmr),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: controller.filterControllerName.value,
                          // onChanged: (value) {},
                          keyboardType: TextInputType.text,
                          // initialValue: 'Vanvu',
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                            hintText: TextByNation.getStringByKey('group_name'),
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.colorBorder),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode
                                  ? ColorValue.colorTextDark
                                  : ColorValue.neutralColor)),
                    ),
                    // Icon(
                    //   Icons.insert_emoticon_outlined,
                    //   color: Color(0xff929AA9),
                    //   size: 24.sp,
                    // )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border(
            //           top: BorderSide(
            //               width: 3.h,
            //               color: Get.isDarkMode
            //                   ? Color(0xff232323)
            //                   : ColorValue.colorBrCmr),
            //           bottom: BorderSide(
            //               width: 3.h,
            //               color: Get.isDarkMode
            //                   ? Color(0xff232323)
            //                   : ColorValue.colorBrCmr))),
            //   child: Padding(
            //     padding: EdgeInsets.all(20.r),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             Text(
            //               TextByNation.getStringByKey('auto_delete_chat'),
            //               style: TextStyle(
            //                   fontSize: 14.sp,
            //                   fontWeight: FontWeight.w600,
            //                   color: ColorValue.neutralColor),
            //             ),
            //             Spacer(),
            //             InkWell(
            //               onTap: () {
            //                 showSelectTimeDeleteMessage(context);
            //               },
            //               child: Row(
            //                 children: [
            //                   Text(
            //                     controller.selectTimeDelete.value == 0
            //                         ? TextByNation.getStringByKey('off')
            //                         : controller.listTime[controller
            //                                     .selectTimeDelete.value]
            //                                 .toString() +
            //                             (controller.selectTimeDelete.value > 1
            //                                 ? ' ' +
            //                                     TextByNation.getStringByKey(
            //                                         'days')
            //                                 : ' ' +
            //                                     TextByNation.getStringByKey(
            //                                         'day')),
            //                     style: TextStyle(
            //                         fontSize: 14.sp,
            //                         color: ColorValue.colorPrimary,
            //                         fontWeight: FontWeight.w600),
            //                   ),
            //                   SizedBox(
            //                     width: 4.w,
            //                   ),
            //                   Icon(
            //                     Icons.keyboard_arrow_down,
            //                     size: 20.sp,
            //                     color: ColorValue.colorBorder,
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(
            //           height: 4.h,
            //         ),
            //         Text(
            //           TextByNation.getStringByKey('auto_delete_chat_content'),
            //           style: TextStyle(
            //               fontSize: 12.sp,
            //               fontWeight: FontWeight.w400,
            //               color: ColorValue.colorBorder),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 20.h,
            // ),
            Container(
                height: 3,
                color:
                    Get.isDarkMode ? Color(0xff232323) : ColorValue.colorBrCmr),
            Expanded(
                child: ListView.builder(
                    itemCount: controller.selectedItems.length,
                    itemBuilder: (context, index) {
                      return chatItem(context, index);
                    })),
            Opacity(
              opacity: controller.selectedItems.length == 0 ? 0.5 : 1,
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  controller.selectedItems.length == 0
                      ? () {}
                      : controller.isClick.value == false
                          ? controller.createGroup()
                          : () {};
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: [Color(0xff0CBE8C), Color(0xff5B72DE)])),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Center(
                        child: Text(
                          TextByNation.getStringByKey('create'),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  chatItem(BuildContext context, int index) {
    return Obx(() => (InkWell(
          onTap: () async {},
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: Get.isDarkMode
                            ? Color(0xff232323)
                            : ColorValue.colorBrCmr))),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      controller.selectedItems[index].avatar != null &&
                              controller.selectedItems[index].avatar!.isNotEmpty
                          ? ClipOval(
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(),
                                child: Image.network(
                                  Constant.BASE_URL_IMAGE +
                                      controller.selectedItems[index].avatar
                                          .toString(),
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
                            )
                          : Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: Utils.getGradientForLetter(
                                      controller.selectedItems[index]
                                                  .fullName ==
                                              null
                                          ? controller
                                              .selectedItems[index].userName
                                              .toString()
                                          : controller
                                              .selectedItems[index].fullName
                                              .toString())),
                              child: Center(
                                  child: Text(
                                Utils.getInitialsName(controller
                                                .selectedItems[index]
                                                .fullName ==
                                            null
                                        ? controller
                                            .selectedItems[index].userName
                                            .toString()
                                        : controller
                                            .selectedItems[index].fullName
                                            .toString())
                                    .toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
                            ),
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
                        controller.selectedItems[index].fullName == null
                            ? controller.selectedItems[index].userName
                                .toString()
                            : controller.selectedItems[index].fullName
                                .toString(),
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
                                controller.selectedItems[index].lastSeen!),
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
                  // Text(
                  //   TextByNation.getStringByKey('unlock_friend'),
                  //   textAlign: TextAlign.end,
                  //   style: TextStyle(
                  //       fontSize: 10.sp,
                  //       fontWeight: FontWeight.w400,
                  //       color: Get.isDarkMode
                  //           ? ColorValue.colorTextDark
                  //           : ColorValue.textColor),
                  // ),
                  // Switch(
                  //   value: controller.selectedItems[index].isMakeFriend!,
                  //   onChanged: (value) {
                  //     controller.selectedItems[index].isMakeFriend = value;
                  //     controller.selectedItems.refresh();
                  //   },
                  //   activeColor: Colors.white,
                  //   activeTrackColor: ColorValue.colorPrimary,
                  //   inactiveTrackColor: ColorValue.colorBrCmr,
                  // ),
                  // Container(
                  //   height: 21.h,
                  //   width: 1.w,
                  //   color: ColorValue.colorBrCmr,
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      controller.selectedItems
                          .remove(controller.selectedItems[index]);
                      controller.selectedItems.refresh();
                    },
                    child: Icon(
                      Icons.close_outlined,
                      size: 24,
                      color: ColorValue.colorBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(TextByNation.getStringByKey('new_group'),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          )),
    );
  }

  void showSelectTimeDeleteMessage(BuildContext context) {
    showModalBottomSheet(
        backgroundColor:
            Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Obx(() => (Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          height: 4,
                          width: 32,
                          decoration: BoxDecoration(
                              color: ColorValue.colorPlaceholder,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            TextByNation.getStringByKey('auto_delete_title'),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.neutralColor),
                          ),
                          Spacer(),
                          Icon(
                            Icons.close,
                            size: 24,
                            color: ColorValue.neutralColor,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        TextByNation.getStringByKey('auto_delete_content'),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorValue.textColor),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Column(
                        children:
                            List.generate(controller.listTime.length, (index) {
                      return buildTranslateItem(index);
                    })),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )));
        });
  }

  InkWell buildTranslateItem(int index) {
    return InkWell(
      onTap: () {
        controller.selectTimeDelete.value = index;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Ink(
          // padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: index == controller.listTime.length - 1
                    ? Colors.transparent
                    : Get.isDarkMode
                        ? Color(0xff232323)
                        : ColorValue.colorBrCmr, // Màu của đường viền dưới cùng
                width: 1.0, // Độ dày của đường viền
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Row(
              children: [
                Text(
                  index == 0
                      ? TextByNation.getStringByKey('off')
                      : controller.listTime[index].toString() +
                          (index > 1
                              ? ' ' + TextByNation.getStringByKey('days')
                              : ' ' + TextByNation.getStringByKey('day')),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: controller.selectTimeDelete == index
                          ? ColorValue.colorPrimary
                          : Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : ColorValue.neutralColor),
                ),
                Spacer(),
                controller.selectTimeDelete.value == index
                    ? Icon(
                        Icons.check,
                        size: 24,
                        color: ColorValue.colorPrimary,
                      )
                    : SizedBox(
                        height: 24,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
