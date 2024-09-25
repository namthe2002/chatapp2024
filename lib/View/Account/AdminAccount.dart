import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/AdminAccountController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Navigation/RouteDefine.dart';
import 'package:live_yoko/Utils/Utils.dart';

class AdminAccount extends StatelessWidget {
  var delete = Get.delete<AdminAccountController>();
  AdminAccountController controller = Get.put(AdminAccountController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                content: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: Get.width - 20),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                TextByNation.getStringByKey(
                                    'log_out'), // chat or ground
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
                          Text(
                            TextByNation.getStringByKey('you_sure_loguot'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode
                                  ? ColorValue.colorTextDark
                                  : ColorValue.neutralColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.close(1);
                                },
                                child: Text(
                                  TextByNation.getStringByKey('cancel'),
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
                                onTap: () {
                                  Get.close(2);
                                },
                                child: Text(
                                  TextByNation.getStringByKey('log_out'),
                                  style: TextStyle(
                                      fontSize: 16,
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

          return controller.isBack.value;
        },
        child: (Scaffold(
          appBar: appBar(),
          body: body(context),
        )),
      ),
    );
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      width: Get.width,
      height: Get.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: Get.isDarkMode ? Colors.transparent : ColorValue.colorBrCmr,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  showChooseLanguage(context, 0);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border:
                          Border.all(color: Color(0xfffe4e6ec), width: 1.5)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.selectPosition.value != -1
                              ? controller
                                  .listPosition[controller.selectPosition.value]
                              : TextByNation.getStringByKey('position'),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode
                                  ? ColorValue.colorTextDark
                                  : ColorValue.neutralColor),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        controller.selectPosition.value != 0
                            ? GestureDetector(
                                onTap: () async {
                                  controller.listContact.clear();
                                  controller.isLoangding.value = await true;
                                  controller.hasMore.value = await true;
                                  controller.selectPosition.value = await 0;
                                  await controller.getFriend(
                                      0, controller.selectPosition.value + 1);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                              )
                            : Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 16,
                              )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showChooseLanguage(context, 1);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border:
                          Border.all(color: Color(0xfffe4e6ec), width: 1.5)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.selectStatus.value != -1
                              ? controller
                                  .listStatus[controller.selectStatus.value]
                              : TextByNation.getStringByKey('status'),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Get.isDarkMode
                                  ? ColorValue.colorTextDark
                                  : ColorValue.neutralColor),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
              child: controller.isLoangding.value == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : controller.listContact.length == 0
                      ? Center(
                          child: SvgPicture.asset(
                            'asset/icons/no_accout.svg',
                            width: 200,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: controller.resetFriend,
                          child: ListView.builder(
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
                              }),
                        )),
          // InkWell(
          //   highlightColor: Colors.transparent,
          //   onTap: () {
          //     Navigation.navigateTo(
          //       page: 'AddAccount',
          //     );
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.all(20).r,
          //     child: Container(
          //       width: Get.width,
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(12.r),
          //           gradient: LinearGradient(
          //               colors: [Color(0xff05EBA6), Color(0xff1FB8CD)])),
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(vertical: 14.h),
          //         child: Center(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Icon(
          //                 Icons.person_add_alt_outlined,
          //                 color: Colors.white,
          //                 size: 24.sp,
          //               ),
          //               SizedBox(
          //                 width: 4.w,
          //               ),
          //               Text(
          //                 TextByNation.getStringByKey('add_account'),
          //                 style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     color: Colors.white,
          //                     fontSize: 14.sp),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    ));
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: controller.isSearch.value == false
          ? Text(TextByNation.getStringByKey('list_account'),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                // color: ColorValue.textColor,
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
        Navigation.navigateTo(
            page: RouteDefine.accountDetail, arguments: controller.listContact[index]);
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            children: [
              Stack(
                children: [
                  controller.listContact[index].avatar == null
                      ? Container(
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
                                            .trim()
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
                      : ClipOval(
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
                    controller.listContact[index].fullName == null
                        ? controller.listContact[index].userName.toString()
                        : controller.listContact[index].fullName
                            .toString()
                            .trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Get.isDarkMode
                            ? ColorValue.colorTextDark
                            : ColorValue.textColor),
                  ),
                  // Text(
                  //   'Last seen recently',
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //       fontSize: 14.sp,
                  //       fontWeight: FontWeight.w400,
                  //       color: Get.isDarkMode
                  //           ? ColorValue.colorTextDark
                  //           : ColorValue.colorBorder),
                  // ),
                ],
              )),
              controller.roleId.value != 1
                  ? InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigation.navigateTo(
                            page: RouteDefine.accountDetail,
                            arguments: controller.listContact[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorValue.colorBrSearch,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            TextByNation.getStringByKey('detail'),
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
      ),
    );
  }

  void showChooseLanguage(BuildContext context, int indexFilter) {
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
          return Obx(() => (
              Container(
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
                            TextByNation.getStringByKey('position'),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.neutralColor),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Icon(Icons.close,
                                size: 24,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.neutralColor),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        TextByNation.getStringByKey('select_filter'),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorValue.colorBorder),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                        children: List.generate(
                            indexFilter == 0
                                ? controller.listPosition.length
                                : controller.listStatus.length, (index) {
                      return buildTranslateItem(index, indexFilter);
                    })),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )));
        });
  }

  InkWell buildTranslateItem(int index, int indexFilter) {
    return InkWell(
      onTap: () async {
        indexFilter == 0
            ? controller.selectPosition.value = index
            : controller.selectStatus.value = index;
        Get.close(1);
        controller.listContact.clear();
        controller.isLoangding.value = await true;
        controller.hasMore.value = await true;
        await controller.getFriend(
            controller.selectPosition.value, controller.selectStatus.value + 1);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Ink(
          // padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Get.isDarkMode
                    ? ColorValue.colorTextDark
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
                  indexFilter == 0
                      ? controller.listPosition[index]
                      : controller.listStatus[index],
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: (indexFilter == 0
                                  ? controller.selectPosition.value
                                  : controller.selectStatus) ==
                              index
                          ? ColorValue.colorPrimary
                          : Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : ColorValue.neutralColor),
                ),
                Spacer(),
                (indexFilter == 0
                            ? controller.selectPosition.value
                            : controller.selectStatus) ==
                        index
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
