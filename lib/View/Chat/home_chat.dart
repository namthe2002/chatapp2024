import 'dart:convert';
import 'dart:html' as html;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:live_yoko/Controller/Chat/ChatController.dart';
import 'package:live_yoko/Controller/Chat/ProfileChatDetailController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/View/Account/ChatSetting.dart';
import 'package:live_yoko/View/Account/LanguageSettings.dart';
import 'package:live_yoko/View/Account/ManageFriends.dart';
import 'package:live_yoko/View/Account/UpdateProfile.dart';
import 'package:live_yoko/View/Chat/ChatBoxDetail.dart';
import 'package:live_yoko/View/Chat/ChatCreate.dart';
import 'package:live_yoko/View/Chat/GroupCreate.dart';
import 'package:live_yoko/View/Chat/theme_mode_page.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';
import 'package:lottie/lottie.dart';
import '../../Controller/Account/UpdateProfileController.dart';
import '../../Controller/Chat/ChatDetailController.dart';
import '../../Navigation/Navigation.dart';
import '../../Utils/TextWithEmoji.dart';
import '../../Utils/thumnail_generator.dart';
import '../../core/constant/sticker/sticker.dart';
import '../../widget/my_entry.dart';
import '../Account/Friend.dart';
import '../Account/NotificationSetting.dart';

class HomeChatWebsite extends StatefulWidget {
  @override
  State<HomeChatWebsite> createState() => _HomeChatWebsiteState();
}

class _HomeChatWebsiteState extends State<HomeChatWebsite> {
  final _homeController = Get.put(ChatController());
  var delete = Get.delete<ChatController>();

  final ValueNotifier<double> progress =
      ValueNotifier(0.0); // Initialize progress notifier

  void simulateLoading() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (progress.value < 1.0) {
        progress.value += 0.1; // Increment progress by 10%
        simulateLoading(); // Continue loading until 100%
      }
    });
  }

  @override
  void initState() {
    _homeController.selectedChatItemIndex.value = 1;
    _homeController.onInitData();
    simulateLoading();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ChatController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          drawer:
              _homeController.forward.uuid != null ? null : drawerChat(context),
          drawerEnableOpenDragGesture: true,
          body: SafeArea(
            child: Container(
              width: Get.width,
              height: Get.height,
              color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
              child: _homeController.isLoading.value == true
                  ? Center(
                      child: ValueListenableBuilder<double>(
                        valueListenable: progress,
                        builder: (context, value, child) {
                          double cappedValue = value.clamp(0.0, 1.0);
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            constraints: BoxConstraints(
                              maxWidth: 300,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: cappedValue,
                                    minHeight: 10,
                                    backgroundColor: Colors.grey.shade300,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '${(cappedValue * 100).toInt()}%',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.bold), // Style text
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : chat(
                      _homeController.widgetFeature.value ?? homeChatWidget()),
            ),
          ),
        ));
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
                      _homeController.avatarUser == ''
                          ? Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: Utils.getGradientForLetter(
                                      _homeController.userName.toString())),
                              child: Center(
                                  child: Text(
                                Utils.getInitialsName(
                                        _homeController.userName.toString())
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
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(),
                                child: Image.network(
                                  Constant.BASE_URL_IMAGE +
                                      _homeController.avatarUser.value,
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
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    _homeController.userName.value.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Get.isDarkMode
                            ? ColorValue.colorPrimary
                            : ColorValue.neutralColor),
                  ),
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
              // showSelectBrightnessMode(context);
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
                      content: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Column(
                            // mainAxisAlignment: ,
                            mainAxisSize: MainAxisSize.min,
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

  Widget toolBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Get.isDarkMode
              ? ColorValue.neutralColor
              : ColorValue.colorBrSearch),
      height: MediaQuery.of(context).size.height,
      // alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => _homeController.avatarUser.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Tooltip(
                    message: _homeController.fullNameUser.value,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        Constant.BASE_URL_IMAGE +
                            _homeController.avatarUser.value,
                        fit: BoxFit.cover,
                        width: 36,
                        height: 36,
                      ),
                    ),
                  ),
                )
              : iconToolBar(
                  image: 'asset/images/ic_account_avatar.png',
                  size: 36,
                  borderRadius: 40,
                  message: _homeController.fullNameUser.value,
                  buttonColor: _homeController.selectedChatItemIndex.value == 0
                      ? ColorValue.white
                      : null,
                  iconButton: _homeController.selectedChatItemIndex.value == 0
                      ? ColorValue.colorPrimary
                      : null,
                  onTap: () {
                    // _homeController.selectIcon(0);
                  },
                )),
          Obx(() => iconToolBar(
                image: 'asset/images/ic_home_chat.png',
                buttonColor: _homeController.selectedChatItemIndex.value == 1
                    ? ColorValue.white
                    : null,
                iconButton: _homeController.selectedChatItemIndex.value == 1
                    ? ColorValue.colorPrimary
                    : null,
                message: AppLocalizations.of(context)!.chatApp,
                onTap: () async {
                  _homeController.listChat.refresh();
                  await _homeController.refreshListChat;
                  _homeController.updateFeature(
                      context: context, widget: homeChatWidget());
                  _homeController.selectIcon(1);
                },
              )),
          Obx(() => iconToolBar(
                image: 'asset/images/ic_contact.png',
                buttonColor: _homeController.selectedChatItemIndex.value == 2
                    ? ColorValue.white
                    : null,
                iconButton: _homeController.selectedChatItemIndex.value == 2
                    ? ColorValue.colorPrimary
                    : null,
                message: AppLocalizations.of(context)!.friend,
                onTap: () {
                  // _buildFeatureHomeChat(context, C);
                  _homeController.updateFeature(
                      context: context, widget: Friend());
                  _homeController.selectIcon(2);
                },
              )),
          Obx(() => iconToolBar(
                image: 'asset/images/ic_friend_request.png',
                buttonColor: _homeController.selectedChatItemIndex.value == 3
                    ? ColorValue.white
                    : null,
                iconButton: _homeController.selectedChatItemIndex.value == 3
                    ? ColorValue.colorPrimary
                    : null,
                message: AppLocalizations.of(context)!.friend_sent,
                onTap: () {
                  _homeController.updateFeature(
                      context: context, widget: ManageFriends());
                  _homeController.selectIcon(3);
                },
              )),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => iconToolBar(
                          image: 'asset/images/ic_ud_profile.png',
                          buttonColor:
                              _homeController.selectedChatItemIndex.value == 4
                                  ? ColorValue.white
                                  : null,
                          iconButton:
                              _homeController.selectedChatItemIndex.value == 4
                                  ? ColorValue.colorPrimary
                                  : null,
                          message: AppLocalizations.of(context)!.update_profile,
                          onTap: () {
                            Get.delete<UpdateProfileController>();
                            _homeController.updateFeature(
                                context: context, widget: UpdateProfile());
                            _homeController.selectIcon(4);
                          },
                        )),
                    Obx(() => iconToolBar(
                          image: 'asset/images/ic_night_mode.png',
                          buttonColor:
                              _homeController.selectedChatItemIndex.value == 5
                                  ? ColorValue.white
                                  : null,
                          iconButton:
                              _homeController.selectedChatItemIndex.value == 5
                                  ? ColorValue.colorPrimary
                                  : null,
                          message: AppLocalizations.of(context)!.night_mode,
                          onTap: () {
                            _homeController.updateFeature(
                                context: context, widget: SelectThemeMode());
                            _homeController.selectIcon(5);
                          },
                        )),
                    Obx(() => iconToolBar(
                          image: 'asset/images/ic_chat_setting.png',
                          buttonColor:
                              _homeController.selectedChatItemIndex.value == 6
                                  ? ColorValue.white
                                  : null,
                          iconButton:
                              _homeController.selectedChatItemIndex.value == 6
                                  ? ColorValue.colorPrimary
                                  : null,
                          message: AppLocalizations.of(context)!.chat_setting,
                          onTap: () {
                            _homeController.updateFeature(
                                context: context, widget: ChatSetting());
                            _homeController.selectIcon(6);
                          },
                        )),
                    Obx(() => iconToolBar(
                          image: 'asset/images/ic_active_session.png',
                          buttonColor:
                              _homeController.selectedChatItemIndex.value == 7
                                  ? ColorValue.white
                                  : null,
                          iconButton:
                              _homeController.selectedChatItemIndex.value == 7
                                  ? ColorValue.colorPrimary
                                  : null,
                          message: AppLocalizations.of(context)!.status_active,
                          onTap: () {
                            // _buildFeatureHomeChat(context);
                            _homeController.selectIcon(7);
                          },
                        )),
                    Obx(() => iconToolBar(
                          image: 'asset/images/ic_notification.png',
                          buttonColor:
                              _homeController.selectedChatItemIndex.value == 8
                                  ? ColorValue.white
                                  : null,
                          iconButton:
                              _homeController.selectedChatItemIndex.value == 8
                                  ? ColorValue.colorPrimary
                                  : null,
                          message: AppLocalizations.of(context)!.notification,
                          onTap: () {
                            _homeController.updateFeature(
                                context: context,
                                widget: NotificationSetting());
                            _homeController.selectIcon(8);
                          },
                        )),
                    Obx(() => iconToolBar(
                          image: 'asset/images/ic_language.png',
                          buttonColor:
                              _homeController.selectedChatItemIndex.value == 9
                                  ? ColorValue.white
                                  : null,
                          iconButton:
                              _homeController.selectedChatItemIndex.value == 9
                                  ? ColorValue.colorPrimary
                                  : null,
                          message: AppLocalizations.of(context)!.language,
                          onTap: () {
                            _homeController.updateFeature(
                                context: context, widget: LanguageSettings());
                            _homeController.selectIcon(9);
                          },
                        )),
                    Obx(() => iconToolBar(
                          image: 'asset/images/ic_log_out.png',
                          buttonColor:
                              _homeController.selectedChatItemIndex.value == 10
                                  ? ColorValue.white
                                  : null,
                          iconButton:
                              _homeController.selectedChatItemIndex.value == 10
                                  ? ColorValue.colorPrimary
                                  : null,
                          message: AppLocalizations.of(context)!.log_out,
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    contentPadding: EdgeInsets.all(32),
                                    content: Container(
                                      decoration: BoxDecoration(),
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
                                                  Text(
                                                    TextByNation.getStringByKey(
                                                        'log_out'),
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Get.isDarkMode
                                                            ? ColorValue
                                                                .colorTextDark
                                                            : ColorValue
                                                                .neutralColor,
                                                        height: 32 / 24,
                                                        fontStyle:
                                                            FontStyle.normal),
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
                                                        ? ColorValue
                                                            .colorTextDark
                                                        : ColorValue
                                                            .neutralColor,
                                                    height: 24 / 14,
                                                    fontStyle:
                                                        FontStyle.normal),
                                              ),
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
                                                      TextByNation
                                                              .getStringByKey(
                                                                  'cancel')
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Get.isDarkMode
                                                              ? ColorValue
                                                                  .colorTextDark
                                                              : ColorValue
                                                                  .textColor,
                                                          height: 24 / 16,
                                                          fontStyle:
                                                              FontStyle.normal),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 12,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await Utils.backLogin(
                                                          true);
                                                    },
                                                    child: Text(
                                                      TextByNation
                                                              .getStringByKey(
                                                                  'log_out')
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: ColorValue
                                                              .colorPrimary,
                                                          height: 24 / 16,
                                                          fontStyle:
                                                              FontStyle.normal),
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
                            _homeController.selectIcon(10);
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconToolBar(
      {double? size,
      Color? buttonColor,
      Color? iconButton,
      double? borderRadius,
      required String image,
      required VoidCallback onTap,
      String? message}) {
    return Center(
      child: Tooltip(
        message: message ?? '',
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
              color: buttonColor ??
                  (Get.isDarkMode
                      ? ColorValue.neutralColor
                      : ColorValue.colorBrSearch)),
          padding: EdgeInsets.all(12),
          child: SingleTapDetector(
            delayTimeInMillisecond: 200,
            onTap: () {
              onTap.call();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 32),
              child: Image.asset(
                image,
                color: iconButton ?? null,
                width: size ?? 32,
                height: size ?? 32,
              ),
            ),
          ),
        ),
      ),
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

  // AppBar appBar() {
  //   return AppBar(
  //     elevation: 0.5,
  //     title: Text(
  //       _homeController.isSelected.value == true
  //           ? '${_homeController.listChatSelect.length.toString()}'
  //               '  ${TextByNation.getStringByKey('select')}'
  //           : 'ChatAPP',
  //       style: TextStyle(
  //           fontSize: _homeController.isSelected.value == true ? 18 : 24,
  //           fontWeight: FontWeight.w600,
  //           color: _homeController.isSelected.value == true
  //               ? ColorValue.neutralColor
  //               : Colors.white),
  //     ),
  //     backgroundColor: _homeController.isSelected.value == true
  //         ? Colors.white
  //         : ColorValue.colorAppBar,
  //     leading: _homeController.isSelected.value == true
  //         ? GestureDetector(
  //             onTap: () {
  //               _homeController.isSelected.value = false;
  //               _homeController.listChatSelect.clear();
  //             },
  //             child: Icon(
  //               Icons.close,
  //               size: 28,
  //               color: ColorValue.neutralLineIcon,
  //             ),
  //           )
  //         : Builder(
  //             builder: (context) => _homeController.forward.uuid != null
  //                 ? IconButton(
  //                     icon: const Icon(Icons.arrow_back_rounded,
  //                         color: Colors.white),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     })
  //                 : GestureDetector(
  //                     onTap: () => Scaffold.of(context).openDrawer(),
  //                     child: Icon(
  //                       Icons.menu,
  //                       size: 24,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //           ),
  //     actions: _homeController.isSelected.value
  //         ? [
  //             GestureDetector(
  //               child: Icon(
  //                 Icons.push_pin_outlined,
  //                 size: 24,
  //                 color: ColorValue.neutralColor,
  //               ),
  //             ),
  //             GestureDetector(
  //               child: Padding(
  //                 padding: EdgeInsets.only(left: 20),
  //                 child: Icon(
  //                   Icons.delete_outlined,
  //                   size: 24,
  //                   color: ColorValue.neutralColor,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             // GestureDetector(
  //             //   onTap: () {
  //             //     Navigation.navigateTo(page: 'SearchChat');
  //             //   },
  //             //   child: Padding(
  //             //     padding: EdgeInsets.symmetric(horizontal: 20.w),
  //             //     child: Icon(
  //             //       Icons.cleaning_services_outlined,
  //             //       size: 24.sp,
  //             //       color: ColorValue.neutralColor,
  //             //     ),
  //             //   ),
  //             // ),
  //           ]
  //         : [
  //             GestureDetector(
  //               onTap: () {
  //                 Navigation.navigateTo(
  //                     page: 'SearchChat',
  //                     arguments: _homeController.forward.uuid != null
  //                         ? _homeController.forward
  //                         : null);
  //               },
  //               child: Icon(
  //                 Icons.search,
  //                 size: 24,
  //                 color: Colors.white,
  //               ),
  //             ),
  //             SizedBox(
  //               width: 20,
  //             )
  //           ],
  //   );
  // }

  Obx chat(Widget widget) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (Utils.isDesktopWeb(context)) ? toolBar(context) : SizedBox(),
            (Utils.isDesktopWeb(context))
                ? Expanded(
                    flex: 3,
                    child: _homeController.isLoading.value == true
                        ? Center(
                            child: const CircularProgressIndicator(),
                          )
                        : widget)
                : SizedBox(),
            Expanded(
                flex: 8,
                child: ChatBoxDetail(
                  key: ValueKey(
                    _homeController.selectedChatItem.value?.uuid ?? 1,
                  ),
                  chatDetail: _homeController.selectedChatItem.value,
                )),
          ],
        ));
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
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            TextByNation.getStringByKey('welcome_chat'),
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: ColorValue.colorPrimary),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            TextByNation.getStringByKey('welcome_content'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Get.isDarkMode
                  ? ColorValue.colorTextDark
                  : ColorValue.textColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () async {
              await Navigation.navigateTo(page: 'ChatCreate');
              // _homeController.refreshListChat();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      colors: [Color(0xff0CBE8C), Color(0xff5B72DE)])),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Text(
                    TextByNation.getStringByKey('create_chat'),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget homeChatWidget() {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 12,
                  left: 16,
                ),
                child: Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 20,
                    height: 28 / 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                height: 40,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? ColorValue.colorBrSearch
                      : ColorValue.colorBrSearch,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.search,
                    floatingLabelStyle:
                        TextStyle(color: Color.fromRGBO(17, 185, 145, 1)),
                    labelStyle: TextStyle(
                        color: Get.isDarkMode
                            ? ColorValue.colorTextDark
                            : Colors.black),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: null == _homeController.listChat.length
                    ? RefreshIndicator(
                        onRefresh: _homeController.refreshListChat,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Image.asset(
                                  'asset/images/listchat_empty.png',
                                  width: 160,
                                  height: 128,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.label_no_dialog,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF101114),
                                    fontSize: 16,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.w400,
                                    height: 0.09,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _homeController.refreshListChat,
                        child: ListView.builder(
                          controller: _homeController.scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _homeController.listChat.length + 1,
                          itemBuilder: (context, index) {
                            if (index < _homeController.listChat.length) {
                              return chatItem(context, index);
                            } else {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: _homeController.hasMore.value
                                    ? CircularProgressIndicator()
                                    : const SizedBox(),
                              );
                            }
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
        _homeController.forward.uuid != null
            ? SizedBox()
            : Positioned(
                right: 24,
                bottom: 24,
                child: buttonAddChat(),
              ),
      ],
    );
  }

  Widget buttonAddChat() {
    return AnimatedSlide(
      duration: const Duration(microseconds: 300),
      offset: _homeController.isVisible.value ? Offset.zero : Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(microseconds: 300),
        opacity: _homeController.isVisible.value ? 1 : 0,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _homeController.isSelected.value == true
                ? null
                : LinearGradient(
                    colors: [Colors.blue, Colors.green],
                  ),
          ),
          // child: FloatingActionButton(
          //   elevation: 0,
          //   // Tắt đổ bóng
          //   focusElevation: 0,
          //   // Tắt đổ bóng khi focus
          //   hoverElevation: 0,
          //   // Tắt đổ bóng khi hover
          //   focusColor: Colors.transparent,
          //   backgroundColor: Colors.transparent,
          //   onPressed: () async {
          //     await Navigation.navigateTo(page: 'ChatCreate');
          //     _homeController.refreshListChat();
          //   },
          //   tooltip: 'Creat Chat',
          //   child:
          //
          //   SvgPicture.asset(
          //     'asset/icons/add_chat.svg',
          //     width: 32,
          //     height: 32,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: _createChatButton(),
        ),
      ),
    );
  }

  Obx chatItem(BuildContext context, int index) {
    return Obx(() => (InkWell(
          onTap: () async {
            if (_homeController.forward.uuid == null) {
              if (_homeController.isSelected.value == false) {
                _homeController.listChat[index].unreadCount = 0;
                _homeController.listChat.refresh();
                Get.delete<ProfileChatDetailController>();
                Get.delete<ChatDetailController>();
                _homeController.selectItem(index);
                _homeController.selectChatItem(_homeController.listChat[index]);
              } else {
                if (_homeController.listChatSelect
                    .contains(_homeController.listChat[index].uuid)) {
                  _homeController.listChatSelect
                      .remove(_homeController.listChat[index].uuid!);
                } else {
                  _homeController.listChatSelect
                      .add(_homeController.listChat[index].uuid!);
                }
                _homeController.listChatSelect.refresh();
                _homeController.listChat.refresh();
              }
            }
          },
          onSecondaryTap: () {
            html.window.document.onContextMenu.listen((event) {
              event.preventDefault();
            });
            if (_homeController.forward.uuid == null) {
              showPopupselect(context, index);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: BoxDecoration(
                color: _homeController.selectedChatIndex.value == index
                    ? ColorValue.colorFilledBox
                    : Get.isDarkMode
                        ? ColorValue.neutralColor
                        : Colors.white),
            child: Row(
              children: [
                Stack(
                  children: [
                    _homeController.listChat[index].avatar != null &&
                            _homeController.listChat[index].avatar!.isNotEmpty
                        ? ClipOval(
                            child: Container(
                              width: Utils.isDesktopWeb(context) ? 50 : 50,
                              height: Utils.isDesktopWeb(context) ? 50 : 50,
                              decoration: BoxDecoration(),
                              child: Image.network(
                                Constant.BASE_URL_IMAGE +
                                    _homeController.listChat[index].avatar
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
                                    _homeController.listChat[index].ownerName!
                                        .toString())),
                            child: Center(
                                child: Text(
                              Utils.getInitialsName(_homeController
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
                    _homeController.listChatSelect
                            .contains(_homeController.listChat[index].uuid)
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
                        : _homeController.listChat[index].isActive == true
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
                      _homeController.listChat[index].ownerName!.toString(),
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
                    _homeController.listChat[index].userTyping.isNotEmpty
                        ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_homeController.listChat[index].userTyping} ${TextByNation.getStringByKey('is_typing')}',
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
                              if (_homeController.listChat[index].forwardFrom !=
                                  null)
                                Container(
                                  margin: EdgeInsets.only(
                                      right: _homeController
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
                              _homeController.listChat[index].status ==
                                      4 // nội dung tin nhắn bị xóa
                                  ? Flexible(
                                      child: RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          style: TextStyle(),
                                          children: <TextSpan>[
                                            if (_homeController
                                                    .listChat[index].type ==
                                                2)
                                              TextSpan(
                                                text: _homeController
                                                            .listChat[index]
                                                            .userSent
                                                            .toString() ==
                                                        'admin'
                                                    ? _homeController
                                                            .listChat[index]
                                                            .content
                                                            .toString() +
                                                        ' '
                                                    : _homeController
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
                                                    fontFamily:
                                                        'NotoColorEmoji'),
                                              ),
                                            TextSpan(
                                              text: TextByNation.getStringByKey(
                                                  'message_been_deleted'), // name chat
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: _homeController
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
                                                            .colorBorder,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Expanded(
                                      child: getTypeContent(
                                          _homeController.listChat[index]
                                                  .contentType ??
                                              0,
                                          index),
                                    )
                            ],
                          )
                  ],
                )),
                _homeController.forward.uuid != null
                    ? GestureDetector(
                        onTap: () async {
                          await _homeController.forwardMessage(
                              uuid: _homeController.listChat[index].uuid!);
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              if (_homeController.listChat[index].fullName ==
                                      _homeController.fullNameUser.value &&
                                  _homeController.listChat[index].unreadCount ==
                                      0)
                                Icon(
                                  _homeController.listChat[index].readCounter ==
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
                                _homeController.getTimeMessage(_homeController
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
                          if (_homeController.listChat[index].pinned == true &&
                              _homeController.listChat[index].unreadCount! == 0)
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
                          if (_homeController.listChat[index].unreadCount! >
                                  0 &&
                              _homeController.listChat[index].fullName !=
                                  _homeController.userNameAcount.value)
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
                                  _homeController.listChat[index].unreadCount!
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
        )));
  }

  Future<dynamic> showPopupselect(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _homeController.listChat[index].avatar != null &&
                          _homeController.listChat[index].avatar!.isNotEmpty
                      ? ClipOval(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(),
                            child: Image.network(
                              Constant.BASE_URL_IMAGE +
                                  _homeController.listChat[index].avatar
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
                                  _homeController.listChat[index].ownerName!
                                      .toString())),
                          child: Center(
                              child: Text(
                            Utils.getInitialsName(_homeController
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
                  Text(
                    _homeController.listChat[index].ownerName.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Get.isDarkMode
                            ? ColorValue.colorTextDark
                            : ColorValue.textColor),
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: () {
                  Get.close(1);
                  _homeController.pinMessage(
                      index, _homeController.listChat[index].pinned!);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        _homeController.listChat[index].pinned == false
                            ? 'asset/icons/pin.svg'
                            : 'asset/icons/un_pin.svg',
                        width: 20,
                        height: 20,
                        color: Get.isDarkMode ? Color(0xff737373) : null,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        TextByNation.getStringByKey(
                            _homeController.listChat[index].pinned == false
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
                            borderRadius: BorderRadius.circular(12.0)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _homeController.listChat[index].avatar !=
                                            null &&
                                        _homeController
                                            .listChat[index].avatar!.isNotEmpty
                                    ? ClipOval(
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(),
                                          child: Image.network(
                                            Constant.BASE_URL_IMAGE +
                                                _homeController
                                                    .listChat[index].avatar
                                                    .toString(),
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        ColorValue.colorBorder),
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
                                            gradient:
                                                Utils.getGradientForLetter(
                                                    _homeController
                                                        .listChat[index]
                                                        .ownerName!
                                                        .toString())),
                                        child: Center(
                                            child: Text(
                                          Utils.getInitialsName(_homeController
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
                                Text(
                                  TextByNation.getStringByKey('delete_chat'),
                                  // chat or ground
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
                                            'chat_delete') +
                                        ' ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Get.isDarkMode
                                          ? ColorValue.colorTextDark
                                          : ColorValue.neutralColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _homeController
                                        .listChat[index].ownerName
                                        .toString(),
                                    // name chat
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
                              mainAxisSize: MainAxisSize.min,
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
                                SingleTapDetector(
                                  onTap: () async {
                                    if (_homeController.isClickLoading) {
                                      _homeController.isClickLoading = false;
                                      await _homeController
                                          .deleteMessage(index);
                                      _homeController.isClickLoading = true;
                                    }
                                  },
                                  child: Text(
                                    TextByNation.getStringByKey('delete'),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ColorValue.colorPrimary),
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
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'asset/icons/delete.svg',
                        width: 20,
                        height: 20,
                        color: Get.isDarkMode ? Color(0xff737373) : null,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 6),
                      Text(
                        TextByNation.getStringByKey('delete_chat'),
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
                height: 16,
              ),
              GestureDetector(
                onTap: () async {
                  if (_homeController.isClickLoading) {
                    _homeController.isClickLoading = false;
                    Navigator.of(context).pop();
                    await _homeController.clearMessage(index: index);
                    _homeController.isClickLoading = true;
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cleaning_services_outlined,
                      size: 20,
                      color: Get.isDarkMode
                          ? ColorValue.colorTextDark
                          : ColorValue.neutralColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      TextByNation.getStringByKey('clear_history'),
                      style: TextStyle(
                          fontSize: 14,
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
        );
      },
    );
  }

  getTypeContent(int typeContent, int index) {
    var indexs;
    var indexSticker;
    String stickerString = '';
    if (typeContent == 6) {
      indexs = int.tryParse(
              _homeController.listChat[index].content!.split('_')[1]) ??
          -1;
      indexSticker = int.tryParse(
              _homeController.listChat[index].content!.split('_')[2]) ??
          -1;
      stickerString = (stickerPacks[indexs - 1]['stickers']
          as List)[indexSticker - 1]['emojis'];
    }

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
        return Row(
          children: [
            RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: <TextSpan>[
                  if (_homeController.listChat[index].type == 2)
                    TextSpan(
                      text: _homeController.listChat[index].userSent
                                  .toString() ==
                              'admin'
                          ? _homeController.listChat[index].content.toString() +
                              ' '
                          : _homeController.listChat[index].fullName
                                  .toString() +
                              ':' +
                              ' ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Get.isDarkMode
                            ? ColorValue.colorTextDark
                            : ColorValue.textColor,
                        // fontFamily: 'NotoColorEmoji',
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Expanded(
              child: TextWithEmoji(
                text: _homeController.listChat[index].userSent.toString() ==
                        'admin'
                    ? TextByNation.getStringByKey('admin_create')
                    : _homeController.listChat[index].content.toString(),
                // name chat
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: _homeController.listChat[index].unreadCount! > 0
                    ? Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.neutralColor
                    : Get.isDarkMode
                        ? ColorValue.colorTextDark_2
                        : ColorValue.colorBorder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      case 3: //image
        return Row(
          children: [
            if (_homeController.listChat[index].type == 2)
              Flexible(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  _homeController.listChat[index].fullName.toString() +
                      ':' +
                      ' ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.textColor,
                  ),
                ),
              ),
            FittedBox(
              fit: BoxFit.cover,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  height: 24,
                  width: 24,
                  child: Utils.getFileType(Constant.BASE_URL_IMAGE +
                              jsonDecode(_homeController.listChat[index].content
                                  .toString())[0]) ==
                          "Video"
                      ? GenThumbnailImage(
                          thumbnailRequest: ThumbnailRequest(
                            video: Constant.BASE_URL_IMAGE +
                                jsonDecode(_homeController
                                    .listChat[index].content
                                    .toString())[0],
                            thumbnailPath: null,
                            imageFormat: ImageFormat.JPEG,
                            maxHeight: 24,
                            // Set maxHeight và maxWidth theo kích thước của Container cha
                            maxWidth: 24,
                            timeMs: 20,
                            quality: 100,
                            attachHeaders: false,
                          ),
                        )
                      : Image.network(
                          Constant.BASE_URL_IMAGE +
                              jsonDecode(_homeController.listChat[index].content
                                  .toString())[0],
                          fit: BoxFit.cover,
                          // Đảm bảo hình ảnh cover toàn bộ kích thước
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              color: Colors.grey,
                            );
                          },
                        ),
                ),
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                Utils.getFileType(Constant.BASE_URL_IMAGE +
                            jsonDecode(_homeController.listChat[index].content
                                .toString())[0]) ==
                        "Image"
                    ? "Photo"
                    : 'Video',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _homeController.listChat[index].unreadCount! > 0
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
            jsonDecode(_homeController.listChat[index].content.toString())[0]);
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
            if (_homeController.listChat[index].type == 2)
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                _homeController.listChat[index].fullName.toString() + ':' + ' ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Get.isDarkMode
                      ? ColorValue.colorTextDark
                      : ColorValue.textColor,
                ),
              ),
            SvgPicture.asset(
              typeThumbnail,
              width: 24,
              height: 24,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 6,
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
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _homeController.listChat[index].unreadCount! > 0
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
            if (_homeController.listChat[index].type == 2)
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                _homeController.listChat[index].fullName.toString() + ':' + ' ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Get.isDarkMode
                      ? ColorValue.colorTextDark
                      : ColorValue.textColor,
                ),
              ),
            Icon(
              Icons.mic,
              size: 18,
              color: ColorValue.colorBorder,
            ),
            SizedBox(
              width: 2,
            ),
            Text(TextByNation.getStringByKey('audio'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _homeController.listChat[index].unreadCount! > 0
                        ? Get.isDarkMode
                            ? ColorValue.colorTextDark
                            : ColorValue.neutralColor
                        : Get.isDarkMode
                            ? ColorValue.colorTextDark_2
                            : ColorValue.colorBorder)),
          ],
        );
      case 6:
        return RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: <TextSpan>[
              if (_homeController.listChat[index].type == 2)
                TextSpan(
                  text: _homeController.listChat[index].userSent.toString() ==
                          'admin'
                      ? '$stickerString Sticker'
                      : '${_homeController.listChat[index].fullName}: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.textColor,
                    fontFamily: 'NotoColorEmoji',
                  ),
                ),
              TextSpan(
                text: _homeController.listChat[index].userSent.toString() ==
                        'admin'
                    ? AppLocalizations.of(context)!.admin_create
                    : '$stickerString Sticker', // name chat
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color:
                        (_homeController.listChat[index].unreadCount ?? 0) > 0
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
      case 7:
        return Row(
          children: [
            if (_homeController.listChat[index].userSent.toString() != 'admin')
              Text('${_homeController.listChat[index].fullName}: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.textColor,
                    fontWeight: FontWeight.w400,
                  )),
            CachedNetworkImage(
                imageUrl: _homeController.listChat[index].content!,
                height: 22,
                width: 22),
            SizedBox(width: 10),
            Text('Image Link',
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode
                      ? ColorValue.colorTextDark
                      : ColorValue.textColor,
                  fontWeight: FontWeight.w400,
                ))
          ],
        );
      case 8:
        return Row(
          children: [
            if (_homeController.listChat[index].userSent.toString() != 'admin')
              Text('${_homeController.listChat[index].fullName}: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.textColor,
                    fontWeight: FontWeight.w400,
                  )),
            CachedNetworkImage(
                imageUrl: _homeController.listChat[index].content!,
                height: 22,
                width: 22),
            SizedBox(width: 10),
            Text('GIF',
                style: TextStyle(
                  fontSize: 14,
                  color: Get.isDarkMode
                      ? ColorValue.colorTextDark
                      : ColorValue.textColor,
                  fontWeight: FontWeight.w400,
                ))
          ],
        );
      default:
        return Container();
    }
  }

  Widget selectThemeMode() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppLocalizations.of(context)!.choose_mode,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ColorValue.colorBorder),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(_homeController.listNode.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        if (index !=
                            _homeController.selectBrightnessMode.value) {
                          _homeController.selectBrightnessMode.value = index;
                          _homeController.changeTheme(index, context);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SvgPicture.asset(
                              _homeController.listNode[index].src!,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              _homeController.listNode[index].title!,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                            Radio(
                              groupValue:
                                  _homeController.selectBrightnessMode.value,
                              value: index,
                              onChanged: ((value) {
                                if (index !=
                                    _homeController
                                        .selectBrightnessMode.value) {
                                  _homeController.selectBrightnessMode.value =
                                      index;
                                  _homeController.changeTheme(index, context);
                                  setState(() {});
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
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ));
  }

  // Widget _videoThumbnail(String videoUrl) {
  //   if (_homeController.thumbnailCache.containsKey(videoUrl)) {
  //     // Sử dụng hình ảnh từ cache nếu có.
  //     return _buildThumbnailImage(_homeController.thumbnailCache[videoUrl]!);
  //   } else {
  //     return FutureBuilder<Uint8List?>(
  //       future: _generateThumbnail(videoUrl),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done &&
  //             snapshot.hasData) {
  //           // Lưu hình ảnh vào cache và hiển thị nó.
  //           _homeController.thumbnailCache[videoUrl] = snapshot.data!;
  //           return _buildThumbnailImage(snapshot.data!);
  //         } else {
  //           return Center(
  //             child: Container(
  //                 // margin: EdgeInsets.symmetric(vertical: 20),
  //                 // height: 30,
  //                 // width: 30,
  //                 // child: const CircularProgressIndicator(
  //                 //   strokeWidth: 3,
  //                 // ),
  //                 ),
  //           );
  //         }
  //       },
  //     );
  //   }
  // }

  Widget _buildThumbnailImage(Uint8List thumbnailData) {
    return Stack(children: [
      Image.memory(
        width: 24,
        height: 24,
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
                size: 14, color: Color.fromRGBO(255, 255, 255, 0.8)),
          ),
        ),
      )
    ]);
  }

  // Future<Uint8List?> _generateThumbnail(String videoUrl) async {
  //   final thumbnail = await VideoThumbnail.thumbnailData(
  //     video: videoUrl,
  //     imageFormat: ImageFormat.JPEG,
  //     quality: 100,
  //   );
  //   return thumbnail;
  // }

  Widget _createChatButton() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _homeController.isSelected.value == true
              ? null
              : LinearGradient(
                  colors: [Colors.blue, Colors.green],
                ),
        ),
        child: PopupMenuButton(
            offset: Offset(50, -60),
            tooltip: 'Create Chat',
            shadowColor: Colors.grey.withOpacity(0.5),
            color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
            padding: EdgeInsets.zero,
            icon: SvgPicture.asset(
              'asset/icons/add_chat.svg',
              color: ColorValue.white,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) {
              return [
                MyEntry(
                    icon: 'asset/icons/ic_new_message.svg',
                    title: 'New Message',
                    onTap: () async {
                      _homeController.updateFeature(
                          context: context, widget: ChatCreate());
                    }),
                MyEntry(
                    icon: 'asset/icons/ic_new_group.svg',
                    title: 'New Group',
                    onTap: () async {
                      _homeController.updateFeature(
                          context: context, widget: GroupCreate());
                    }),
              ];
            }));
  }
}
