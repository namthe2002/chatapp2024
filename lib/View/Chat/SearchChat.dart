import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/ChatDetailController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Controller/Chat/SearchChatController.dart';
import '../../Models/Chat/Chat.dart';
import '../../Navigation/RouteDefine.dart';

class SearchChat extends StatelessWidget {
  var delete = Get.delete<SearchChatController>();
  SearchChatController controller = Get.put(SearchChatController());

  SearchChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(70),
          //   child: AppBar(
          //       elevation: 0.2,
          //       automaticallyImplyLeading: false,
          //       flexibleSpace: Container(
          //         margin: EdgeInsets.only(top: 32),
          //         decoration: BoxDecoration(
          //             border: Border(
          //               bottom: BorderSide(
          //                 color: ColorValue.colorTextDark
          //                     .withOpacity(0.2), // Màu của đường viền dưới
          //                 width: 2, // Độ dày của đường viền
          //               ),
          //             ),
          //             color: Get.isDarkMode
          //                 ? ColorValue.colorAppBar
          //                 : Colors.white),
          //         child: search(),
          //       )),
          // ),

          body: controller.isLoadState.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  // width: Get.width,
                  height: Get.height,
                  color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: controller.isSearch.value == true
                            ? controller.isLoading.value == false
                                ? controller.listChat.length == 0
                                    ? Center(
                                        child: SvgPicture.asset(
                                          'asset/icons/no_results.svg',
                                          width: 200,
                                          height: 260,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: controller.scrollController,
                                        shrinkWrap: true,
                                        itemCount: controller.listChat.length,
                                        itemBuilder: (context, index) {
                                          if (index < controller.listChat.length) {
                                            return chatItem(context, index);
                                          } else {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(vertical: 30),
                                              child: Center(child: controller.hasMore.value ? CircularProgressIndicator() : Container()),
                                            );
                                          }
                                        })
                                : Center(
                                    child: CircularProgressIndicator(),
                                  )
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    controller.listUserRecent.length > 0
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            child: Row(
                                              children: [
                                                Text(
                                                  TextByNation.getStringByKey('recent'),
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ColorValue.colorBorder),
                                                ),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () async {
                                                    controller.listUserRecent.value = await [];
                                                    await Utils.saveListToSharedPreferences([]);
                                                  },
                                                  child: Text(
                                                    TextByNation.getStringByKey('clear'),
                                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ColorValue.colorBorder),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : SizedBox(),

                                    controller.listUserRecent.length > 0
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 20),
                                            child: Wrap(
                                                runSpacing: 10,
                                                children: List.generate(
                                                  controller.listUserRecent.length,
                                                  (index) => chatRecnet(index),
                                                )),
                                          )
                                        : SizedBox(),
                                    // SizedBox(
                                    //   height:
                                    //       controller.listUserRecent.length > 0 ? 0 : 20.h,
                                    // ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(left: 20.w),
                                    //   child: Text(
                                    //     'Recommend chat'.toUpperCase(),
                                    //     style: TextStyle(
                                    //         fontSize: 12.sp,
                                    //         fontWeight: FontWeight.w600,
                                    //         color: ColorValue.colorBorder),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 8.h,
                                    // ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
        )));
  }

  GestureDetector chatRecnet(int index) {
    return GestureDetector(
      onTap: () async {
        if (controller.listUserRecent.length > 1) {
          Chat itemchat = await controller.listUserRecent[index];
          if (!Get.isRegistered<ChatDetailController>()) {
            Navigation.navigateTo(page: RouteDefine.chatBoxDetail, arguments: {
              'uuid': controller.listUserRecent[index].uuid,
              'name': controller.listUserRecent[index].ownerName,
              'type': controller.listUserRecent[index].type,
              'ownerUuid': controller.listUserRecent[index].ownerUuid,
              'avatar': controller.listUserRecent[index].avatar ?? '',
              'lastMsgLineUuid': controller.listUserRecent[index].lastMsgLineUuid
            });
          }
          controller.listUserRecent.removeAt(index);
          controller.listUserRecent.insert(0, itemchat);
          await Utils.saveListToSharedPreferences(controller.listUserRecent);
        }
      },
      child: SizedBox(
        width: (Get.width - 40) / 4,
        child: Column(
          children: [
            controller.listUserRecent[index].avatar != null && controller.listUserRecent[index].avatar!.isNotEmpty
                ? ClipOval(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(),
                      child: Image.network(
                        Constant.BASE_URL_IMAGE + controller.listUserRecent[index].avatar.toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, color: ColorValue.colorBorder),
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
                        shape: BoxShape.circle, gradient: Utils.getGradientForLetter(controller.listUserRecent[index].ownerName!.toString())),
                    child: Center(
                        child: Text(
                      Utils.getInitialsName(controller.listUserRecent[index].ownerName!.toString()).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    )),
                  ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                controller.listUserRecent[index].ownerName.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ColorValue.textColor),
              ),
            ),
            Visibility(
              visible: controller.forward.uuid != null,
              child: GestureDetector(
                onTap: () async {
                  await controller.forwardMessage(uuid: controller.listUserRecent[index].uuid!);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Get.isDarkMode ? Colors.white70 : Colors.black26, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    TextByNation.getStringByKey('send'),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorValue.textColor),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Obx search() {
    return Obx(() => (Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          width: Get.width,
          height: 50,
          decoration: BoxDecoration(
              // color: Get.isDarkMode
              //     ? ColorValue.colorTextDark
              //     : ColorValue.colorBrSearch,
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Get.close(1);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: TextFormField(
                      controller: controller.filterController.value,
                      onChanged: (value) async {
                        if (value.trim() == '') {
                          controller.isSearch.value = await false;
                        } else {
                          controller.isSearch.value = await true;
                        }

                        if (controller.debounce?.isActive ?? false) controller.debounce?.cancel();
                        controller.debounce = Timer(Duration(milliseconds: 2000), () async {
                          await controller.refreshData();
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        hintText: TextByNation.getStringByKey('search_chat'),
                        hintStyle:
                            TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Get.isDarkMode ? Colors.white : ColorValue.colorBorder),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Get.isDarkMode ? Colors.white : ColorValue.textColor)),
                ),
                controller.isSearch.value == false
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () async {
                          controller.filterController.value.text = await '';
                          await controller.refreshData();
                          controller.isSearch.value = await false;
                        },
                        child: Icon(Icons.close))
              ],
            ),
          ),
        )));
  }

  InkWell chatItem(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        controller.listChat[index].unreadCount = 0;
        controller.listChat.refresh();

        if (controller.listUserRecent.length == 0) {
          controller.listUserRecent.insert(0, controller.listChat[index]);
          Utils.saveListToSharedPreferences(controller.listUserRecent);
        } else {
          int indexItem = controller.listUserRecent.indexWhere((element) => controller.listChat[index].uuid == element.uuid);
          if (indexItem == -1) {
            controller.listUserRecent.insert(0, controller.listChat[index]);
            await Utils.saveListToSharedPreferences(controller.listUserRecent);
          } else {
            Chat itemchat = await controller.listUserRecent[indexItem];
            controller.listUserRecent.removeAt(indexItem);
            controller.listUserRecent.insert(0, itemchat);
            await Utils.saveListToSharedPreferences(controller.listUserRecent);
          }
          if (controller.listUserRecent.length == 9) {
            controller.listUserRecent.removeAt(controller.listUserRecent.length - 1);
            await Utils.saveListToSharedPreferences(controller.listUserRecent);
          }
        }
        if (!Get.isRegistered<ChatDetailController>()) {
          Navigation.navigateTo(page: 'ChatDetail', arguments: {
            'uuid': controller.listChat[index].uuid,
            'name': controller.listChat[index].ownerName,
            'type': controller.listChat[index].type,
            'ownerUuid': controller.listChat[index].ownerUuid,
            'avatar': controller.listChat[index].avatar ?? '',
            'lastMsgLineUuid': controller.listChat[index].lastMsgLineUuid
          });
        }
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            children: [
              Stack(
                children: [
                  controller.listChat[index].avatar != null && controller.listChat[index].avatar!.isNotEmpty
                      ? ClipOval(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(),
                            child: Image.network(
                              Constant.BASE_URL_IMAGE + controller.listChat[index].avatar.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: ColorValue.colorBorder),
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
                              shape: BoxShape.circle, gradient: Utils.getGradientForLetter(controller.listChat[index].ownerName!.toString())),
                          child: Center(
                              child: Text(
                            Utils.getInitialsName(controller.listChat[index].ownerName!.toString()).toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
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
                    controller.listChat[index].ownerName.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Get.isDarkMode ? ColorValue.colorTextDark : ColorValue.textColor),
                  ),
                  // Text(
                  //   'Last seen recently',
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //       fontSize: 14.sp,
                  //       fontWeight: FontWeight.w400,
                  //       color: ColorValue.colorBorder),
                  // ),
                ],
              )),
              Visibility(
                visible: controller.forward.uuid != null,
                child: GestureDetector(
                  onTap: () async {
                    await controller.forwardMessage(uuid: controller.listChat[index].uuid!);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Get.isDarkMode ? Colors.white70 : Colors.black26, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      TextByNation.getStringByKey('send'),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorValue.textColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
