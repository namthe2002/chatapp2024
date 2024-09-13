import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/NotificationSettingController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Utils.dart';

class NotificationSetting extends StatelessWidget {
  var delete = Get.delete<NotificationSettingController>();
  NotificationSettingController controller =
      Get.put(NotificationSettingController());

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
      decoration: BoxDecoration(
        color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      ),
      width: Get.width,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          builderNotification(TextByNation.getStringByKey('chat_notification'),
              TextByNation.getStringByKey('notification_content'),
              (value) async {
            if (value == true) {
              await Utils.toggleNotification(1);
              controller.isNotification.value = value;
            } else {
              await Utils.toggleNotification(0);
              controller.isNotification.value = value;
            }
          }, controller.isNotification.value),
          // builderNotification(
          //     'Group chat notifications',
          //     'Receive notifications when there are new group messages',
          //     (value) {},
          //     false),
          // builderNotification(
          //     'Interact Emoji',
          //     'Receive notifications when there is an emotional interaction',
          //     (value) {},
          //     false),
          // builderNotification(
          //     'Pinned Messages',
          //     'Notify when there is a message pinned in the group',
          //     (value) {},
          //     false),
          // builderNotification(
          //     'Friend Request',
          //     'Receive notifications when receiving friend requests and when becoming friends.',
          //     (value) {},
          //     false),
          // buldResetNotification(context),
        ]),
      ),
    ));
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: false,
      titleSpacing: 15,
      elevation: 0,
      title: Text(TextByNation.getStringByKey('notification'),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 28/20,
          )),
    );
  }

  InkWell buldResetNotification(BuildContext context) {
    return InkWell(
      onTap: () {
        showResetNotification(context);
      },
      child: Ink(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resset all notifications',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode
                                  ? ColorValue.colorTextDark
                                  : Colors.black),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          'Reset default notification settings ',
                          maxLines: 2,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorValue.colorBorder),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 20.sp,
                    color: ColorValue.colorBorder,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showResetNotification(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          content: ConstrainedBox(
            constraints: BoxConstraints(minWidth: Get.width - 20.w),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reset notifications', // chat or ground
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : ColorValue.neutralColor),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      'Are you sure you want to reset all notifications settings to default?',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : ColorValue.textColor),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.close(1);
                          },
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.textColor),
                          ),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        InkWell(
                          onTap: () {
                            Get.close(1);
                          },
                          child: Text(
                            'RESET',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorValue.colorPrimary),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Padding builderNotification(
      String title, String note, Function(bool) onTap, bool valueSwwith) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            // Thiết lập viền trên
            bottom: BorderSide(
                width: 1.0,
                color: Get.isDarkMode
                    ? ColorValue.colorTextDark
                    : ColorValue.colorBrCmr), // Thiết lập viền dưới
            // Thiết lập các viền khác nếu cần
          ),
        ),
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : Colors.black),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      note,
                      maxLines: 2,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorValue.colorBorder),
                    ),
                  ],
                ),
              ),
              Switch(
                value: valueSwwith,
                onChanged: onTap,
                activeColor: Colors.white,
                activeTrackColor: ColorValue.colorPrimary,
                inactiveTrackColor: ColorValue.colorBrCmr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
