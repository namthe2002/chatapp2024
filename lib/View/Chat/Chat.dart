import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Service/SocketManager.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../Navigation/Navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late ChatController _chatController;
  var delete = Get.delete<ChatController>();

  @override
  void initState() {
    // TODO: implement initState
    _chatController = Get.put(ChatController());
    super.initState();
  }

  @override
  void dispose() {
    delete;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
      // backgroundColor: Colors.white,
      appBar: appBar(),
      drawer:
      _chatController.forward.uuid != null ? null : drawerChat(context),
      drawerEnableOpenDragGesture: true,
      floatingActionButton: _chatController.forward.uuid != null
          ? null
          : AnimatedSlide(
        duration: const Duration(microseconds: 300),
        offset: _chatController.isVisible.value
            ? Offset.zero
            : Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(microseconds: 300),
          opacity: _chatController.isVisible.value ? 1 : 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _chatController.isSelected.value == true
                  ? null
                  : LinearGradient(
                colors: [Colors.blue, Colors.green],
              ),
            ),
            child: FloatingActionButton(
              elevation: 0,
              // Tắt đổ bóng
              focusElevation: 0,
              // Tắt đổ bóng khi focus
              hoverElevation: 0,
              // Tắt đổ bóng khi hover
              focusColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              onPressed: () async {
                await Navigation.navigateTo(page: 'ChatCreate');
                _chatController.refreshListChat();
              },
              tooltip: 'Increment',
              child: SvgPicture.asset(
                'asset/icons/add_chat.svg',
                width: 32.w,
                height: 32.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: Get.width,
          height: Get.height,
          color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
              // top: 20.r,
            ),
            child: _chatController.isLoading.value == true
                ? Center(
              child: CircularProgressIndicator(),
            )
                : _chatController.listChat.length == 0 &&
                !_chatController.isUnPin.value
                ? emptyChat()
                : chat(),
          ),
        ),
      ),
    )));
  }

  Drawer drawerChat(BuildContext context) {
    return Drawer(
      backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 46,
                ),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          _chatController.avatarUser == ''
                              ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: Utils.getGradientForLetter(
                                    _chatController.userName.toString())),
                            child: Center(
                                child: Text(
                                  Utils.getInitialsName(
                                      _chatController.userName.toString())
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )),
                          )
                              : ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(),
                              child: Image.network(
                                Constant.BASE_URL_IMAGE +
                                    _chatController.avatarUser.value,
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
                          ),
                          // Positioned(
                          //     right: 0,
                          //     bottom: 0,
                          //     child: Container(
                          //       width: 32.r,
                          //       height: 32.r,
                          //       decoration: BoxDecoration(
                          //         color: ColorValue.colorBrCmr,
                          //         border: Border.all(
                          //           color: Colors.white, // Màu của viền
                          //           width: 2, // Độ dày của viền
                          //         ),
                          //         shape: BoxShape.circle,
                          //       ),
                          //       child: Icon(
                          //         Icons.camera_alt,
                          //         size: 20.sp,
                          //       ),
                          //     ))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        _chatController.userName.value.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode
                                ? ColorValue.colorPrimary
                                : ColorValue.neutralColor),
                      ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // Text(
                      //   'Always Grateful 🙏🏻',
                      //   style: TextStyle(
                      //       fontSize: 12.sp,
                      //       fontWeight: FontWeight.w400,
                      //       color: ColorValue.colorBorder),
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Text(
                  '${TextByNation.getStringByKey('account').toUpperCase()} ${AppLocalizations.of(context)!.account}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorValue.colorBorder),
                ),
                SizedBox(
                  height: 3,
                ),
                options(TextByNation.getStringByKey('update_profile'), () {
                  Navigation.navigateTo(page: 'UpdateProfile');
                }, 'asset/icons/draw_1.svg'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  TextByNation.getStringByKey('friend').toUpperCase(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorValue.colorBorder),
                ),
                SizedBox(
                  height: 8,
                ),
                options(TextByNation.getStringByKey('friend'), () {
                  Navigation.navigateTo(page: 'Friend');
                }, 'asset/icons/draw_2.svg'),
                SizedBox(
                  height: 2,
                ),
                options(TextByNation.getStringByKey('Invite_friend'), () {
                  Navigation.navigateTo(page: 'ManageFriends');
                }, 'asset/icons/draw_3.svg'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  TextByNation.getStringByKey('settings').toUpperCase(),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColorValue.colorBorder),
                ),
                SizedBox(
                  height: 8,
                ),
                options(TextByNation.getStringByKey('night_mode'), () {
                  showSelectBrightnessMode(context);
                }, 'asset/icons/draw_4.svg'),
                SizedBox(
                  height: 2,
                ),
                options(TextByNation.getStringByKey('chat_setting'), () {
                  Navigation.navigateTo(page: 'ChatSetting');
                }, 'asset/icons/draw_5.svg'),
                SizedBox(
                  height: 2,
                ),
                options(TextByNation.getStringByKey('notification'), () {
                  Navigation.navigateTo(page: 'NotificationSetting');
                }, 'asset/icons/draw_6.svg'),
                SizedBox(
                  height: 2,
                ),
                options(TextByNation.getStringByKey('language'), () {
                  Navigation.navigateTo(page: 'LanguageSettings');
                }, 'asset/icons/draw_7.svg'),
                SizedBox(
                  height: 2,
                ),
                SizedBox(
                  height: 100,
                ),
                options(TextByNation.getStringByKey('log_out'), () async {
                  showDialog(
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
                                      TextByNation.getStringByKey(
                                          'you_sure_loguot'),
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
                                          onTap: () async {
                                            await Utils.backLogin(true);
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
                      });
                }, 'asset/icons/draw_8.svg'),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )),
    );
  }

  options(String title, VoidCallback onTap, String imgScr) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                // Icon(
                //   icon,
                //   size: 24.sp,
                //   color: ColorValue.textColor,
                // ),
                SvgPicture.asset(imgScr,
                    width: 24,
                    height: 24,
                    color: 'asset/icons/draw_8.svg' == imgScr
                        ? Get.isDarkMode
                        ? Colors.white
                        : Color(0xff32363E)
                        : null),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      // color: ColorValue.neutralColor
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                  // color: ColorValue.colorBorder,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.5,
      // title: Text(
      //   _chatController.isSelected.value == true
      //       ? '${_chatController.listChatSelect.length.toString()}'
      //           '  ${TextByNation.getStringByKey('select')}'
      //       : 'ChatAPP',
      //   style: TextStyle(
      //       fontSize: _chatController.isSelected.value == true ? 18.sp : 24.sp,
      //       fontWeight: FontWeight.w600,
      //       color: _chatController.isSelected.value == true
      //           ? ColorValue.neutralColor
      //           : Colors.white),
      // ),
      backgroundColor: _chatController.isSelected.value == true
          ? Colors.white
          : ColorValue.colorAppBar,
      leading: _chatController.isSelected.value == true
          ? GestureDetector(
        onTap: () {
          _chatController.isSelected.value = false;
          _chatController.listChatSelect.clear();
        },
        child: Icon(
          Icons.close,
          size: 100,
          color: ColorValue.neutralLineIcon,
        ),
      )
          : Builder(
        builder: (context) => _chatController.forward.uuid != null
            ? IconButton(
            icon: const Icon(Icons.arrow_back_rounded,
                color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            })
            : GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Icon(
            Icons.menu,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      actions: _chatController.isSelected.value
          ? [
        GestureDetector(
          child: Icon(
            Icons.push_pin_outlined,
            size: 24,
            color: ColorValue.neutralColor,
          ),
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(
              Icons.delete_outlined,
              size: 24,
              color: ColorValue.neutralColor,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        // GestureDetector(
        //   onTap: () {
        //     Navigation.navigateTo(page: 'SearchChat');
        //   },
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 20.w),
        //     child: Icon(
        //       Icons.cleaning_services_outlined,
        //       size: 24.sp,
        //       color: ColorValue.neutralColor,
        //     ),
        //   ),
        // ),
      ]
          : [
        GestureDetector(
          onTap: () {
            Navigation.navigateTo(
                page: 'SearchChat',
                arguments: _chatController.forward.uuid != null
                    ? _chatController.forward
                    : null);
          },
          child: Icon(
            Icons.search,
            size: 24,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  Obx chat() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Text(
            'PINNED MESSAGE',
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xff929AA9)),
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        Expanded(
            child: _chatController.isLoading.value == true
                ? Center(
              child: CircularProgressIndicator(),
            )
                : RefreshIndicator(
              onRefresh: _chatController.refreshListChat,
              child: ListView.builder(
                  controller: _chatController.scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _chatController.listChat.length,
                  itemBuilder: (context, index) {
                    if (index < _chatController.listChat.length) {
                      return chatItem(context, index);
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                            child: _chatController.hasMore.value
                                ? CircularProgressIndicator()
                                : Container()),
                      );
                    }
                  }),
            )),
      ],
    ));
  }

  Obx chatItem(BuildContext context, int index) {
    return Obx(() => (InkWell(
      onTap: () async {
        if (_chatController.forward.uuid == null) {
          if (_chatController.isSelected.value == false) {
            _chatController.listChat[index].unreadCount = 0;
            _chatController.listChat.refresh();
            await Navigation.navigateTo(page: 'ChatDetail', arguments: {
              'uuid': _chatController.listChat[index].uuid,
              'name': _chatController.listChat[index].ownerName,
              'type': _chatController.listChat[index].type,
              'ownerUuid': _chatController.listChat[index].ownerUuid,
              'avatar': _chatController.listChat[index].avatar ?? '',
              'lastMsgLineUuid':
              _chatController.listChat[index].lastMsgLineUuid ?? ''
            });
          } else {
            if (_chatController.listChatSelect
                .contains(_chatController.listChat[index].uuid)) {
              _chatController.listChatSelect
                  .remove(_chatController.listChat[index].uuid!);
            } else {
              _chatController.listChatSelect
                  .add(_chatController.listChat[index].uuid!);
            }
            _chatController.listChatSelect.refresh();
            _chatController.listChat.refresh();
          }
        }
      },
      onLongPress: () {
        if (_chatController.forward.uuid == null) {
          showPopupselect(context, index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: _chatController.listChat[index].pinned == true
                ? Get.isDarkMode
                ? Color(0xff1c1c1c)
                : Color(0xfff7f7f7)
                : Get.isDarkMode
                ? ColorValue.neutralColor
                : Colors.white),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            children: [
              Stack(
                children: [
                  _chatController.listChat[index].avatar != null &&
                      _chatController.listChat[index].avatar!.isNotEmpty
                      ? ClipOval(
                    child: Container(
                      width: Utils.isDesktopWeb(context) ? 100 : 200,
                      height: Utils.isDesktopWeb(context) ? 100 : 200,
                      decoration: BoxDecoration(),
                      child: Image.network(
                        Constant.BASE_URL_IMAGE +
                            _chatController.listChat[index].avatar
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
                            _chatController.listChat[index].ownerName!
                                .toString())),
                    child: Center(
                        child: Text(
                          Utils.getInitialsName(_chatController
                              .listChat[index].ownerName!
                              .toString())
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontSize: 32.sp 18.sp,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )),
                  ),
                  _chatController.listChatSelect
                      .contains(_chatController.listChat[index].uuid)
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorValue.colorPrimary,
                          border: Border.all(
                              width: 1, color: Colors.white)),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                      : _chatController.listChat[index].isActive == true
                      ? Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Get.isDarkMode
                                ? ColorValue.neutralColor
                                : Colors.white, // Màu của viền
                            width: 2, // Độ dày của viền
                          ),
                          shape: BoxShape.circle,
                          // gradient: LinearGradient(colors: [
                          //   Color(0xff39EFA2),
                          //   Color(0xff39EFA2),
                          //   // Color(0xff48C6D7)
                          // ]
                          color: Color(0xff39EFA2),
                        )),
                  )
                      : SizedBox()
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _chatController.listChat[index].ownerName!.toString(),
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
                      _chatController.listChat[index].userTyping.isNotEmpty
                          ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${_chatController.listChat[index].userTyping} ${TextByNation.getStringByKey('is_typing')}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  color: ColorValue.colorPrimary,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                          Lottie.asset(
                            'asset/json/importing.json',
                            width: 30,
                            height: 15,
                          )
                        ],
                      )
                          : Row(
                        children: [
                          if (_chatController
                              .listChat[index].forwardFrom !=
                              null)
                            Container(
                              margin: EdgeInsets.only(
                                  right: _chatController
                                      .listChat[index].type ==
                                      2
                                      ? 3
                                      : 0),
                              child: SvgPicture.asset(
                                'asset/icons/forward_chat.svg',
                                width: 20,
                                height: 20,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          _chatController.listChat[index].status ==
                              4 // nội dung tin nhắn bị xóa
                              ? Flexible(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: <TextSpan>[
                                  if (_chatController
                                      .listChat[index].type ==
                                      2)
                                    TextSpan(
                                      text: _chatController
                                          .listChat[index]
                                          .userSent
                                          .toString() ==
                                          'admin'
                                          ? _chatController
                                          .listChat[index]
                                          .content
                                          .toString() +
                                          ' '
                                          : _chatController
                                          .listChat[index]
                                          .fullName
                                          .toString() +
                                          ':' +
                                          ' ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Get.isDarkMode
                                            ? ColorValue
                                            .colorTextDark
                                            : ColorValue.textColor,
                                      ),
                                    ),
                                  TextSpan(
                                    text: TextByNation.getStringByKey(
                                        'message_been_deleted'), // name chat
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: _chatController
                                            .listChat[index]
                                            .unreadCount! >
                                            0
                                            ? Get.isDarkMode
                                            ? ColorValue
                                            .colorTextDark
                                            : ColorValue
                                            .neutralColor
                                            : Get.isDarkMode
                                            ? ColorValue
                                            .colorTextDark_2
                                            : ColorValue
                                            .colorBorder),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : Expanded(
                            child: getTypeContent(
                                _chatController
                                    .listChat[index].contentType!,
                                index),
                          )
                        ],
                      )
                    ],
                  )),
              _chatController.forward.uuid != null
                  ? GestureDetector(
                onTap: () async {
                  await _chatController.forwardMessage(
                      uuid: _chatController.listChat[index].uuid!);
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Colors.white70
                          : Colors.black26,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    TextByNation.getStringByKey('send'),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorValue.textColor),
                  ),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      if (_chatController.listChat[index].fullName ==
                          _chatController.fullNameUser.value &&
                          _chatController
                              .listChat[index].unreadCount ==
                              0)
                        Icon(
                          _chatController
                              .listChat[index].readCounter ==
                              0
                              ? Icons.done
                              : Icons.done_all,
                          size: 13,
                          color: ColorValue.colorPrimary,
                        ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        _chatController.getTimeMessage(_chatController
                            .listChat[index].lastUpdated!),
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Get.isDarkMode
                                ? ColorValue.colorTextDark
                                : ColorValue.colorBorder),
                      ),
                    ],
                  ),
                  if (_chatController.listChat[index].pinned ==
                      true &&
                      _chatController.listChat[index].unreadCount! ==
                          0)
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: SvgPicture.asset(
                        'asset/icons/pin.svg',
                        width: 15,
                        height: 15,
                        color:
                        Get.isDarkMode ? Color(0xff737373) : null,
                      ),
                    ),
                  if (_chatController.listChat[index].unreadCount! >
                      0 &&
                      _chatController.listChat[index].fullName !=
                          _chatController.userNameAcount.value)
                    Container(
                      margin: EdgeInsets.only(top: 6),
                      height: 20,
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorValue.colorPrimary,
                      ),
                      child: Center(
                        child: Text(
                          _chatController.listChat[index].unreadCount!
                              .toString(),
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    )));
  }

  Future<dynamic> showPopupselect(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: Stack(
            children: [
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  content: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: Get.width - 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _chatController.listChat[index].avatar != null &&
                                _chatController
                                    .listChat[index].avatar!.isNotEmpty
                                ? ClipOval(
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(),
                                child: Image.network(
                                  Constant.BASE_URL_IMAGE +
                                      _chatController
                                          .listChat[index].avatar
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
                                      _chatController
                                          .listChat[index].ownerName!
                                          .toString())),
                              child: Center(
                                  child: Text(
                                    Utils.getInitialsName(_chatController
                                        .listChat[index].ownerName!
                                        .toString())
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                _chatController.listChat[index].ownerName
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
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 1,
                          color: Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : Color(0xffE4E6EC),
                          width: Get.width,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.close(1);
                            _chatController.pinMessage(
                                index, _chatController.listChat[index].pinned!);
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.push_pin_outlined,
                                //   size: 20,
                                //   color: Get.isDarkMode
                                //       ? ColorValue.colorTextDark
                                //       : ColorValue.neutralColor,
                                // ),
                                SvgPicture.asset(
                                  _chatController.listChat[index].pinned ==
                                      false
                                      ? 'asset/icons/pin.svg'
                                      : 'asset/icons/un_pin.svg',
                                  width: 20,
                                  height: 20,
                                  color:
                                  Get.isDarkMode ? Color(0xff737373) : null,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  TextByNation.getStringByKey(
                                      _chatController.listChat[index].pinned ==
                                          false
                                          ? 'pin'
                                          : 'un_pin'),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Get.isDarkMode
                                          ? ColorValue.colorTextDark
                                          : ColorValue.neutralColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.close(1);
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.0)),
                                  content: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: Get.width - 20),
                                    child: Wrap(
                                      crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                _chatController.listChat[index]
                                                    .avatar !=
                                                    null &&
                                                    _chatController
                                                        .listChat[index]
                                                        .avatar!
                                                        .isNotEmpty
                                                    ? ClipOval(
                                                  child: Container(
                                                    width: 48,
                                                    height: 48,
                                                    decoration:
                                                    BoxDecoration(),
                                                    child: Image.network(
                                                      Constant.BASE_URL_IMAGE +
                                                          _chatController
                                                              .listChat[
                                                          index]
                                                              .avatar
                                                              .toString(),
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (BuildContext
                                                      context,
                                                          Object
                                                          exception,
                                                          StackTrace?
                                                          stackTrace) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: ColorValue
                                                                  .colorBorder),
                                                          width: 48,
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
                                                      shape:
                                                      BoxShape.circle,
                                                      gradient: Utils.getGradientForLetter(
                                                          _chatController
                                                              .listChat[
                                                          index]
                                                              .ownerName!
                                                              .toString())),
                                                  child: Center(
                                                      child: Text(
                                                        Utils.getInitialsName(
                                                            _chatController
                                                                .listChat[
                                                            index]
                                                                .ownerName!
                                                                .toString())
                                                            .toUpperCase(),
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            color:
                                                            Colors.white),
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Text(
                                                  TextByNation.getStringByKey(
                                                      'delete_chat'),
                                                  // chat or ground
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      color: Get.isDarkMode
                                                          ? ColorValue
                                                          .colorTextDark
                                                          : ColorValue
                                                          .neutralColor),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 12.h,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: TextByNation
                                                        .getStringByKey(
                                                        'chat_delete') +
                                                        ' ',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color: Get.isDarkMode
                                                          ? ColorValue
                                                          .colorTextDark
                                                          : ColorValue
                                                          .neutralColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: _chatController
                                                        .listChat[index]
                                                        .ownerName
                                                        .toString(),
                                                    // name chat
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      color: ColorValue
                                                          .colorPrimary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10.h,
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
                                              height: 24.h,
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
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Get.isDarkMode
                                                            ? ColorValue
                                                            .colorTextDark
                                                            : ColorValue
                                                            .textColor),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    if (_chatController
                                                        .isClickLoading) {
                                                      _chatController
                                                          .isClickLoading =
                                                      false;
                                                      await _chatController
                                                          .deleteMessage(index);
                                                      _chatController
                                                          .isClickLoading =
                                                      true;
                                                    }
                                                  },
                                                  child: Text(
                                                    TextByNation.getStringByKey(
                                                        'delete'),
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: ColorValue
                                                            .colorPrimary),
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
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'asset/icons/delete.svg',
                                  width: 20.sp,
                                  height: 20.sp,
                                  color:
                                  Get.isDarkMode ? Color(0xff737373) : null,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  TextByNation.getStringByKey('delete_chat'),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Get.isDarkMode
                                          ? ColorValue.colorTextDark
                                          : ColorValue.neutralColor),
                                )
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 16.h,
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     controller.listChatSelect
                        //         .add(controller.listChat[index].uuid!);
                        //     controller.isSelected.value = true;
                        //     Get.back();
                        //   },
                        //   child: Container(
                        //     color: Colors.transparent,
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.done_all,
                        //           size: 20.sp,
                        //           color: Get.isDarkMode
                        //               ? ColorValue.colorTextDark
                        //               : ColorValue.neutralColor,
                        //         ),
                        //         SizedBox(
                        //           width: 6.w,
                        //         ),
                        //         Text(
                        //           TextByNation.getStringByKey('selct_chat'),
                        //           style: TextStyle(
                        //               fontSize: 14.sp,
                        //               fontWeight: FontWeight.w400,
                        //               color: Get.isDarkMode
                        //                   ? ColorValue.colorTextDark
                        //                   : ColorValue.neutralColor),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 16.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_chatController.isClickLoading) {
                              _chatController.isClickLoading = false;
                              await _chatController.clearMessage(index: index);
                              Navigator.pop(context);
                              _chatController.isClickLoading = true;
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.cleaning_services_outlined,
                                size: 20.sp,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.neutralColor,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                TextByNation.getStringByKey('clear_history'),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Get.isDarkMode
                                        ? ColorValue.colorTextDark
                                        : ColorValue.neutralColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  getTypeContent(int typeContent, int index) {
    switch (typeContent) {
      case 1:
      // case 2: // link
      //   return Text(controller.listChat[index].content.toString(),
      //       maxLines: 2,
      //       overflow: TextOverflow.ellipsis,
      //       style: TextStyle(
      //           fontSize: 14.sp,
      //           fontWeight: FontWeight.w400,
      //           color: controller.listChat[index].unreadCount! > 0
      //               ? Get.isDarkMode
      //                   ? ColorValue.colorTextDark
      //                   : ColorValue.neutralColor
      //               : Get.isDarkMode
      //                   ? ColorValue.colorTextDark_2
      //                   : ColorValue.colorBorder));
      case 2:
        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: <TextSpan>[
              if (_chatController.listChat[index].type == 2)
                TextSpan(
                  text: _chatController.listChat[index].userSent.toString() ==
                      'admin'
                      ? _chatController.listChat[index].content.toString() + ' '
                      : _chatController.listChat[index].fullName.toString() +
                      ':' +
                      ' ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.textColor,
                  ),
                ),
              TextSpan(
                text: _chatController.listChat[index].userSent.toString() ==
                    'admin'
                    ? TextByNation.getStringByKey('admin_create')
                    : _chatController.listChat[index].content
                    .toString(), // name chat
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: _chatController.listChat[index].unreadCount! > 0
                        ? Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.neutralColor
                        : Get.isDarkMode
                        ? ColorValue.colorTextDark_2
                        : ColorValue.colorBorder),
              ),
            ],
          ),
        );
      case 3: //image
        return Row(
          children: [
            if (_chatController.listChat[index].type == 2)
              Flexible(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  _chatController.listChat[index].fullName.toString() +
                      ':' +
                      ' ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.textColor,
                  ),
                ),
              ),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0).r,
              child: Container(
                height: 24.r,
                width: 24.r,
                child: Utils.getFileType(Constant.BASE_URL_IMAGE +
                    jsonDecode(_chatController.listChat[index].content
                        .toString())[0]) ==
                    "Video"
                    ? _videoThumbnail(Constant.BASE_URL_IMAGE +
                    jsonDecode(_chatController.listChat[index].content
                        .toString())[0])
                    : Image.network(
                  Constant.BASE_URL_IMAGE +
                      jsonDecode(_chatController.listChat[index].content
                          .toString())[0],
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Container(
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
              child: Text(
                Utils.getFileType(Constant.BASE_URL_IMAGE +
                    jsonDecode(_chatController.listChat[index].content
                        .toString())[0]) ==
                    "Image"
                    ? "Photo"
                    : 'Video',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: _chatController.listChat[index].unreadCount! > 0
                        ? Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.neutralColor
                        : Get.isDarkMode
                        ? ColorValue.colorTextDark_2
                        : ColorValue.colorBorder),
              ),
            ),
          ],
        );
      case 4: //file
        String typeThumbnail = '';
        String type = Utils.getFileType(Constant.BASE_URL_IMAGE +
            jsonDecode(_chatController.listChat[index].content.toString())[0]);
        switch (type) {
          case 'Microsoft Word':
            typeThumbnail = 'asset/icons/docx.svg';
            break;
          case 'Microsoft Excel':
            typeThumbnail = 'asset/icons/xlsm.svg';
            break;
          case 'Microsoft PowerPoint':
            typeThumbnail = 'asset/icons/pdfx.svg';
            break;
          case 'Text':
            typeThumbnail = 'asset/icons/txt.svg';
            break;
          case 'ZIP':
            typeThumbnail = 'asset/icons/file.svg';
            break;
          default:
            typeThumbnail = 'asset/icons/file.svg';
        }
        return Row(
          children: [
            if (_chatController.listChat[index].type == 2)
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                _chatController.listChat[index].fullName.toString() + ':' + ' ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Get.isDarkMode
                      ? ColorValue.colorTextDark
                      : ColorValue.textColor,
                ),
              ),
            SvgPicture.asset(
              typeThumbnail,
              width: 24.w,
              height: 24.w,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 6.w,
            ),
            Expanded(
              child: Text(
                // Uri.parse(controller.listChat[index].content.toString())
                //     .pathSegments
                //     .last,
                  TextByNation.getStringByKey('file'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: _chatController.listChat[index].unreadCount! > 0
                          ? Get.isDarkMode
                          ? ColorValue.colorTextDark
                          : ColorValue.neutralColor
                          : Get.isDarkMode
                          ? ColorValue.colorTextDark_2
                          : ColorValue.colorBorder)),
            ),
          ],
        );
      case 5: //audio
        return Row(
          children: [
            if (_chatController.listChat[index].type == 2)
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                _chatController.listChat[index].fullName.toString() + ':' + ' ',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Get.isDarkMode
                      ? ColorValue.colorTextDark
                      : ColorValue.textColor,
                ),
              ),
            Icon(
              Icons.mic,
              size: 18.sp,
              color: ColorValue.colorBorder,
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(TextByNation.getStringByKey('audio'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: _chatController.listChat[index].unreadCount! > 0
                        ? Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.neutralColor
                        : Get.isDarkMode
                        ? ColorValue.colorTextDark_2
                        : ColorValue.colorBorder)),
          ],
        );
    }
  }

  Padding emptyChat() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              Get.isDarkMode
                  ? 'asset/images/empty_chat_darkmode.png'
                  : 'asset/images/empty_chat_lightmode.png',
              width: 250.w,
              height: 250.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            TextByNation.getStringByKey('welcome_chat'),
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: ColorValue.colorPrimary),
          ),
          SizedBox(
            height: 6.h,
          ),
          Text(
            TextByNation.getStringByKey('welcome_content'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: Get.isDarkMode
                  ? ColorValue.colorTextDark
                  : ColorValue.textColor,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          InkWell(
            onTap: () async {
              await Navigation.navigateTo(page: 'ChatCreate');
              _chatController.refreshListChat();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  gradient: LinearGradient(
                      colors: [Color(0xff0CBE8C), Color(0xff5B72DE)])),
              child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
                  child: Text(
                    TextByNation.getStringByKey('create_chat'),
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
            ),
          )
        ],
      ),
    );
  }

  void showSelectBrightnessMode(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Obx(() => (Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                    20.0), // Đặt bán kính cho góc trên bên trái
                topRight: Radius.circular(
                    20.0), // Đặt bán kính cho góc trên bên phải
              ),
              color:
              Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8).h,
                    child: Container(
                      height: 4.h,
                      width: 32.w,
                      decoration: BoxDecoration(
                          color: ColorValue.colorPlaceholder,
                          borderRadius: BorderRadius.circular(4).r),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Text(
                        TextByNation.getStringByKey('night_mode'),
                        style: TextStyle(
                            fontSize: 20.sp,
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
                            size: 24.sp, color: ColorValue.neutralColor),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    TextByNation.getStringByKey('choose_mode'),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorValue.colorBorder),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_chatController.listNode.length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              if (index !=
                                  _chatController.selectBrightnessMode.value) {
                                _chatController.selectBrightnessMode.value =
                                    index;
                                _chatController.changeTheme(index, context);
                              }
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: (Get.width - 40.w - 24.w) / 3,
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    _chatController.listNode[index].src!,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    _chatController.listNode[index].title!,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Radio(
                                    groupValue: _chatController
                                        .selectBrightnessMode.value,
                                    value: index,
                                    onChanged: ((value) {
                                      if (index !=
                                          _chatController
                                              .selectBrightnessMode.value) {
                                        _chatController
                                            .selectBrightnessMode.value = index;
                                        _chatController.changeTheme(
                                            index, context);
                                      }
                                    }),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                //   child: InkWell(
                //     child: Ink(
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(12.r),
                //           gradient: LinearGradient(colors: [
                //             Color(0xff0CBE8C),
                //             Color(0xff5B72DE),
                //           ])),
                //       child: Center(
                //         child: Padding(
                //           padding: EdgeInsets.symmetric(vertical: 12.h),
                //           child: Text(
                //             'Appy',
                //             style: TextStyle(
                //                 fontSize: 16.sp,
                //                 fontWeight: FontWeight.w600,
                //                 color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
          )));
        });
  }

  Widget _videoThumbnail(String videoUrl) {
    if (_chatController.thumbnailCache.containsKey(videoUrl)) {
      // Sử dụng hình ảnh từ cache nếu có.
      return _buildThumbnailImage(_chatController.thumbnailCache[videoUrl]!);
    } else {
      return FutureBuilder<Uint8List?>(
        future: _generateThumbnail(videoUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            // Lưu hình ảnh vào cache và hiển thị nó.
            _chatController.thumbnailCache[videoUrl] = snapshot.data!;
            return _buildThumbnailImage(snapshot.data!);
          } else {
            return Center(
              child: Container(
                // margin: EdgeInsets.symmetric(vertical: 20),
                // height: 30,
                // width: 30,
                // child: const CircularProgressIndicator(
                //   strokeWidth: 3,
                // ),
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildThumbnailImage(Uint8List thumbnailData) {
    return Stack(children: [
      Image.memory(
        width: 24.w,
        height: 24.w,
        key: UniqueKey(),
        thumbnailData,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object exception, StackTrace? stackTrace) {
          return Container(
            color: Colors.grey,
          );
        },
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
            // padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.3)),
            child: Icon(Icons.play_arrow_rounded,
                size: 14.sp, color: Color.fromRGBO(255, 255, 255, 0.8)),
          ),
        ),
      )
    ]);
  }

  Future<Uint8List?> _generateThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
    );
    return thumbnail;
  }
}
