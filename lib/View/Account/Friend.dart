import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/FriendController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';

import '../../Global/ColorValue.dart';
import '../../Utils/Utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Friend extends StatelessWidget {
  var delete = Get.delete<FriendController>();
  FriendController controller = Get.put(FriendController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (Scaffold(
        appBar: appBar(context),
        body: body(context),
      )),
    );
  }



  SafeArea body(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      width: Get.width,
      height: Get.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 12, left: 24, right: 24),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorValue.colorBrSearch),
            child: TextFormField(
                controller: controller.filterController.value,
                onChanged: (value) async {
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
                      color: Get.isDarkMode
                          ? Colors.white
                          : ColorValue.colorBorder),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color:
                        Get.isDarkMode ? Colors.white : ColorValue.textColor)),
          ),
          SizedBox(
            height: 16,
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Expanded(
          //         child: _buildButtonRequest(context,
          //             buttonTitle: AppLocalizations.of(context)!.received,
          //             onTap: () {})),
          //     Expanded(
          //         child: _buildButtonRequest(context,
          //             buttonTitle: AppLocalizations.of(context)!.sent,
          //             onTap: () {})),
          //   ],
          // ),
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
        ],
      ),
    ));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
        centerTitle: false,
        elevation: 0,
        titleSpacing: 20,
        bottomOpacity: 0,
        // toolbarOpacity: 0,
        title: Text(AppLocalizations.of(context)!.friend,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 28 / 20,
              fontStyle: FontStyle.normal,
              // color: ColorValue.textColor,
            ))
        // actions: [
        //   InkWell(
        //       onTap: () async {
        //         if (controller.isSearch.value == false) {
        //           controller.isSearch.value = true;
        //         } else {
        //           controller.filterController.value.text = await '';
        //
        //           controller.isSearch.value = !controller.isSearch.value;
        //           if (controller.keyword.value != '') {
        //             await controller.resetFriend();
        //           }
        //         }
        //       },
        //       child: Icon(
        //         controller.isSearch.value ? Icons.close : Icons.search_outlined,
        //         size: 24,
        //       )),
        //   SizedBox(
        //     width: 20,
        //   )
        // ],
        );
  }

  chatItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        controller.createRoom(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                                controller.listContact[index].avatar.toString(),
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
                                  controller.listContact[index].fullName == null
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
            const SizedBox(width: 12),
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
            controller.roleId.value != 1
                ? InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    controller.listContact[index]
                                                    .avatar !=
                                                null &&
                                            controller.listContact[index]
                                                .avatar!.isNotEmpty
                                        ? ClipOval(
                                            child: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(),
                                              child: Image.network(
                                                Constant.BASE_URL_IMAGE +
                                                    controller
                                                        .listContact[
                                                            index]
                                                        .avatar
                                                        .toString(),
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace?
                                                            stackTrace) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        color: ColorValue
                                                            .colorBorder),
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
                                                gradient: Utils
                                                    .getGradientForLetter(controller
                                                                .listContact[
                                                                    index]
                                                                .fullName ==
                                                            null
                                                        ? controller
                                                            .listContact[
                                                                index]
                                                            .userName
                                                            .toString()
                                                        : controller
                                                            .listContact[
                                                                index]
                                                            .fullName
                                                            .toString())),
                                            child: Center(
                                                child: Text(
                                              Utils.getInitialsName(controller
                                                              .listContact[
                                                                  index]
                                                              .fullName ==
                                                          null
                                                      ? controller
                                                          .listContact[
                                                              index]
                                                          .userName
                                                          .toString()
                                                      : controller
                                                          .listContact[
                                                              index]
                                                          .fullName
                                                          .toString())
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: Colors.white),
                                            )),
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      TextByNation.getStringByKey(
                                          'cancel_friend'), // chat or ground
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Get.isDarkMode
                                              ? ColorValue.colorTextDark
                                              : ColorValue.neutralColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: TextByNation.getStringByKey(
                                                        'cancal_friend_with') +
                                                    ' ' +
                                                    controller
                                                        .listContact[
                                                            index]
                                                        .fullName! ==
                                                null
                                            ? controller
                                                .listContact[index]
                                                .userName
                                                .toString()
                                            : controller
                                                .listContact[index]
                                                .fullName
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Get.isDarkMode
                                              ? ColorValue.colorTextDark
                                              : ColorValue.neutralColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: controller
                                            .listContact[index].userName
                                            .toString(), // name chat
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: ColorValue.colorPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                // Row(
                                //   crossAxisAlignment:
                                //       CrossAxisAlignment.center,
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.start,
                                //   children: [
                                //     Checkbox(
                                //         activeColor: ColorValue
                                //             .colorPrimary,
                                //         materialTapTargetSize:
                                //             MaterialTapTargetSize
                                //                 .shrinkWrap,
                                //         visualDensity: VisualDensity(
                                //             horizontal:
                                //                 VisualDensity
                                //                     .minimumDensity,
                                //             vertical: VisualDensity
                                //                 .minimumDensity),
                                //         value: controller
                                //             .isDeleteBot.value,
                                //         onChanged: (value) {
                                //           controller.isDeleteBot
                                //               .value = value!;
                                //         }),
                                //     SizedBox(
                                //       width: 8.w,
                                //     ),
                                //     RichText(
                                //       text: TextSpan(
                                //         children: <TextSpan>[
                                //           TextSpan(
                                //             text:
                                //                 'Also delete for ',
                                //             style: TextStyle(
                                //               fontSize: 14.sp,
                                //               fontWeight:
                                //                   FontWeight
                                //                       .w400,
                                //               color: ColorValue
                                //                   .neutralColor,
                                //             ),
                                //           ),
                                //           TextSpan(
                                //             text:
                                //                 'Van Vu', // name chat
                                //             style: TextStyle(
                                //               fontSize: 14.sp,
                                //               fontWeight:
                                //                   FontWeight
                                //                       .w400,
                                //               color: ColorValue
                                //                   .colorPrimary,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(
                                  height: 24,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.close(1);
                                      },
                                      child: Text(
                                        TextByNation.getStringByKey(
                                            'cancel'),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Get.isDarkMode
                                                ? ColorValue.colorTextDark
                                                : ColorValue.textColor),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (!controller.requestDone)
                                          return;
                                        await controller
                                            .cancelFriend(index);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        TextByNation.getStringByKey(
                                            'accept'),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                ColorValue.colorPrimary),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorValue.colorBrSearch,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          TextByNation.getStringByKey('cancel_friend'),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ColorValue.textColor),
                        ),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRequest(BuildContext context,
      {required String buttonTitle, required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ColorValue.white,
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            buttonTitle,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 24 / 14,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: buttonTitle == AppLocalizations.of(context)!.received
                    ? ColorValue.colorPrimary
                    : ColorValue.colorYl,
                borderRadius: BorderRadius.circular(16),
                border: Border(
                  bottom: BorderSide(
                      width: 1,
                      color: ColorValue.colorPrimary ?? ColorValue.white),
                )),
            child: Text(
              '0',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 18 / 12,
                  fontStyle: FontStyle.normal),
            ),
          )
        ],
      ),
    );
  }
}
