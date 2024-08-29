import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';

import '../../Controller/Account/ManageFriendsController.dart';
import '../../Global/ColorValue.dart';
import '../../Utils/Utils.dart';

class ManageFriends extends StatelessWidget {
  ManageFriends({super.key});

  var delete = Get.delete<ManageFriendsController>();

  final controller = Get.put(ManageFriendsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          appBar: appBar(),
          body: body(),
        )));
  }

  AppBar appBar() {
    return AppBar(
      // centerTitle: true,
      titleSpacing: 24,
      actions: [
        InkWell(
            onTap: () async {
              if (controller.isSearch.value == false) {
                controller.isSearch.value = true;
              } else {
                controller.filterController.value.text = await '';

                controller.isSearch.value = !controller.isSearch.value;
                if (controller.keyword.value != '') {
                  await controller.refreshData();
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
      elevation: 0,
      title: controller.isSearch.value == false
          ? Text(TextByNation.getStringByKey('Invite_friend'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 28 / 20,
                fontStyle: FontStyle.normal,
                // color: ColorValue.textColor,
              ))
          : TextFormField(
              controller: controller.filterController.value,
              onChanged: (value) {
                if (controller.statusFriend == 2) {
                  controller.isLoading.value = true;
                } else {
                  controller.isLoadingSend.value = true;
                }
                if (controller.debounce?.isActive ?? false)
                  controller.debounce?.cancel();
                controller.debounce =
                    Timer(Duration(milliseconds: 2000), () async {
                  await controller.refreshData();
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
                    color: ColorValue.colorBorder),
                border: InputBorder.none,
              ),
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: ColorValue.textColor)),
    );
  }

  SafeArea body() {
    return SafeArea(
        child: Container(
      color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      width: Get.width,
      height: Get.height,
      child: Column(children: [
        Container(
          height: 1,
          color:
              Get.isDarkMode ? ColorValue.colorTextDark : ColorValue.colorBrCmr,
        ),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              // isScrollable: true,
              indicatorColor: ColorValue.colorPrimary,
              labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? ColorValue.colorTextDark
                      : ColorValue.textColor),
              labelColor: Get.isDarkMode ? Colors.white : ColorValue.textColor,
              unselectedLabelColor: Get.isDarkMode
                  ? ColorValue.colorTextDark
                  : ColorValue.textColor,
              controller: controller.tabController,
              tabs: [
                Tab(
                  child: Container(
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(TextByNation.getStringByKey('received')
                            .toUpperCase()),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorValue.colorPrimary),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                controller.totalReceived.value.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    width: Get.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          TextByNation.getStringByKey('sent').toUpperCase(),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorValue.colorYl),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                controller.totalSend.value.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color:
              Get.isDarkMode ? ColorValue.colorTextDark : ColorValue.colorBrCmr,
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              // controller.isLoading.value == true
              //     ? Center(
              //         child: CircularProgressIndicator(),
              //       )
              //     :
              //
              //

              controller.listReceivedFriend.length == 0
                      ? Center(
                          child: SvgPicture.asset(
                            'asset/icons/no_results.svg',
                            width: 200,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ListView.builder(
                          controller: controller.receivedScroll,
                          itemCount: controller.listReceivedFriend.length,
                          itemBuilder: (context, index) {
                            if (index < controller.listReceivedFriend.length) {
                              return chatItem(context, index, true);
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
              // controller.isLoadingSend.value == true
              //     ? Center(
              //         child: CircularProgressIndicator(),
              //       )
              //     :

              controller.listSendFriend.length == 0
                      ? Center(
                          child: SvgPicture.asset(
                            'asset/icons/no_results.svg',
                            width: 200,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                        )
                      : ListView.builder(
                          controller: controller.sendScroll,
                          itemCount: controller.listSendFriend.length,
                          itemBuilder: (context, index) {
                            if (index < controller.listSendFriend.length) {
                              return chatItem(context, index, false);
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Center(
                                    child: controller.hasMoreSend.value
                                        ? CircularProgressIndicator()
                                        : Container()),
                              );
                            }
                          }),
            ],
          ),
        ),
      ]),
    ));
  }

  chatItem(BuildContext context, int index, bool isRequired) {
    return InkWell(
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          border: Border(
            // Thiết lập viền trên
            bottom: BorderSide(
                width: 1.0,
                color: ColorValue.colorBrCmr), // Thiết lập viền dưới
            // Thiết lập các viền khác nếu cần
          ),
        ),
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              children: [
                Stack(
                  children: [
                    (isRequired == true
                                ? controller.listReceivedFriend[index].avatar
                                : controller.listSendFriend[index].avatar) ==
                            null
                        ? Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient:
                                    Utils.getGradientForLetter(isRequired ==
                                            true
                                        ? controller.listReceivedFriend[index]
                                                    .friendFullName!
                                                    .trim()
                                                    .toString() ==
                                                ""
                                            ? controller
                                                .listReceivedFriend[index]
                                                .friendUserName
                                                .toString()
                                            : controller
                                                .listReceivedFriend[index]
                                                .friendFullName
                                                .toString()
                                        : controller.listSendFriend[index]
                                                    .friendFullName!
                                                    .trim()
                                                    .toString() ==
                                                ""
                                            ? controller.listSendFriend[index]
                                                .friendUserName
                                                .toString()
                                            : controller.listSendFriend[index]
                                                .friendFullName
                                                .toString())),
                            child: Center(
                                child: Text(
                              Utils.getInitialsName(isRequired == true
                                      ? controller.listReceivedFriend[index]
                                                  .friendFullName!
                                                  .trim()
                                                  .toString() ==
                                              ""
                                          ? controller.listReceivedFriend[index]
                                              .friendUserName
                                              .toString()
                                          : controller.listReceivedFriend[index]
                                              .friendFullName
                                              .toString()
                                      : controller.listSendFriend[index]
                                                  .friendFullName!
                                                  .trim()
                                                  .toString() ==
                                              ""
                                          ? controller.listSendFriend[index]
                                              .friendUserName
                                              .toString()
                                          : controller.listSendFriend[index]
                                              .friendFullName
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
                              // decoration: BoxDecoration(),
                              child: Image.network(
                                Constant.BASE_URL_IMAGE +
                                    (isRequired == true
                                        ? controller
                                            .listReceivedFriend[index].avatar
                                            .toString()
                                        : controller
                                            .listSendFriend[index].avatar
                                            .toString()),
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
                      isRequired == true
                          ? controller.listReceivedFriend[index].friendFullName!
                                      .trim()
                                      .toString() ==
                                  ""
                              ? controller
                                  .listReceivedFriend[index].friendUserName
                                  .toString()
                              : controller
                                  .listReceivedFriend[index].friendFullName
                                  .toString()
                          : controller.listSendFriend[index].friendFullName!
                                      .trim()
                                      .toString() ==
                                  ""
                              ? controller.listSendFriend[index].friendUserName
                                  .toString()
                              : controller.listSendFriend[index].friendFullName
                                  .toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : const Color.fromARGB(255, 65, 82, 114)),
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
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    controller.cancelFriend(index, isRequired);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorValue.colorBrSearch,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        TextByNation.getStringByKey('cancel'),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ColorValue.textColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4),
                isRequired == true
                    ? InkWell(
                        onTap: () async {
                          if (controller.isAcceptFriendLoading) {
                            controller.isAcceptFriendLoading = false;
                            await controller.acceptFriend(index);
                            controller.isAcceptFriendLoading = true;
                          }
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(colors: [
                                Color(0xff0CBE8C),
                                Color(0xff5B72DE)
                              ])),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              TextByNation.getStringByKey('accept'),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
