import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/thumnail_generator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/Chat/ProfileChatDetailController.dart';
import '../../Global/ColorValue.dart';
import '../../Global/Constant.dart';
import '../../Global/TextByNation.dart';
import '../../Models/Chat/Chat.dart';
import '../../Models/Chat/ChatDetailMember.dart';
import '../../Utils/Utils.dart';
import '../../core/constant/theme/ThemeStyle.dart';
import '../../core/image/Images.dart';
import '../../widget/IconButtonCustom.dart';
import '../../widget/MediaCustom.dart';
import '../../widget/my_entry.dart';
import '../../widget/utils_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileChatDetail extends StatefulWidget {
  final Chat? chatDetail;

  ProfileChatDetail({Key? key, this.chatDetail}) : super(key: key);

  @override
  State<ProfileChatDetail> createState() => _ProfileChatDetailState();
}

class _ProfileChatDetailState extends State<ProfileChatDetail> with AutomaticKeepAliveClientMixin {
  final controller = Get.put(ProfileChatDetailController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initData();
    controller.selectedChatDetail.value = widget.chatDetail;
  }

  @override
  Widget build(BuildContext context) {
    controller.selectedChatDetail.value = widget.chatDetail;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<ProfileChatDetailController>();
        return true;
      },
      child: Obx(() => Scaffold(
            appBar: AppBar(
              backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : ColorValue.white,
              titleSpacing: 24,
              centerTitle: false,
              title: Text(
                'Group Info',
                style: TextStyle(
                  fontSize: 20,
                  height: 28 / 20,
                  fontWeight: FontWeight.w600,
                  color: Get.isDarkMode ? ColorValue.textColor : Color(0xFF101114),
                ),
              ),
              actions: [
                Visibility(
                    visible: controller.roleId == 1 && controller.chatType == 2,
                    child: IconButtonCustom(
                        icon: 'asset/icons/edit.svg',
                        color: Get.isDarkMode ? ColorValue.white : ColorValue.neutralLineIcon,
                        onTap: _showDialogRenameGroup)),
                Visibility(
                    visible: controller.roleId == 1 && controller.chatType == 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: IconButtonCustom(
                          icon: 'asset/icons/add_chat.svg',
                          color: Get.isDarkMode ? ColorValue.white : ColorValue.neutralLineIcon,
                          onTap: () {
                            //   show popup add member
                            bottomSheetChatItem(context);
                          }),
                    )),
                PopupMenuButton(
                  offset: Offset(-25, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  icon: SvgPicture.asset(
                    Images.three_dot_vertical_ic,
                    color: Get.isDarkMode ? ColorValue.white : ColorValue.neutralLineIcon,
                  ),
                  itemBuilder: (context) {
                    return [
                      if (controller.roleId == 1)
                        MyEntry(
                          icon: Images.auto_delete_ic,
                          title: AppLocalizations.of(context)!.auto_delete,
                          onTap: () {
                            UtilsWidget.showModalBottomSheetCustom([
                              SizedBox(height: 12),
                              Text(
                                AppLocalizations.of(context)!.auto_delete_title,
                                style: AppTextStyle.regularW500(size: 20, lineHeight: 24, color: ColorValue.neutralColor),
                              ),
                              SizedBox(height: 8),
                              Text(AppLocalizations.of(context)!.auto_delete_content,
                                  style: AppTextStyle.regularW400(
                                      size: 12, lineHeight: 12 / 16, fontStyle: FontStyle.italic, color: ColorValue.textColor)),
                              SizedBox(height: 8),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.timeList.length,
                                separatorBuilder: (context, index) => Container(
                                  height: (.5),
                                  color: ColorValue.colorBrCmr,
                                ),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      await controller.autoDelete(day: controller.timeList[index]);
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.timeList[index] == 0
                                                ? AppLocalizations.of(context)!.off
                                                : '${controller.timeList[index]} ${controller.timeList[index] > 1 ? AppLocalizations.of(context)!.days : AppLocalizations.of(context)!.day}',
                                            style: AppTextStyle.regularW400(
                                                size: 14,
                                                lineHeight: 14 / 24,
                                                color: controller.autoDeleteData == index ? ColorValue.colorPrimary : ColorValue.neutralColor),
                                          ),
                                          if (controller.autoDeleteData == index) SvgPicture.asset(Images.done_ic)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                            ]);
                          },
                        ),
                      MyEntry(
                        icon: Images.clear_history_ic,
                        title: AppLocalizations.of(context)!.clear_history,
                        onTap: () {
                          UtilsWidget.showDialogCustomInChatScreen(
                              controller.isDeleteConversation,
                              AppLocalizations.of(context)!.clear_history,
                              AppLocalizations.of(context)!.label_are_you_sure_you_want_to_clear_your_chat_history,
                              AppLocalizations.of(context)!.label_delete_converstation_chat, (p0) {
                            controller.isDeleteConversation.value = !controller.isDeleteConversation.value;
                          }, () async {
                            await controller.clearMessage();
                            Navigator.pop(context);
                          }, isClear: true);
                        },
                      ),
                      MyEntry(
                        icon: Images.delete_ic,
                        title: AppLocalizations.of(context)!.delete_chat,
                        onTap: () {
                          UtilsWidget.showDialogCustomInChatScreen(
                              controller.isDeleteConversation,
                              AppLocalizations.of(context)!.delete_chat,
                              AppLocalizations.of(context)!.label_you_cannot_undo_once_you_delete_this_copy_of_the_conversation,
                              '',
                              (p0) {}, () async {
                            // await controller.deleteChat();
                            Navigator.pop(context);
                          }, isDeleteChat: true, isHiddenCheckbox: true);
                        },
                      ),
                      if (controller.chatType == 2)
                        MyEntry(
                          icon: Images.leave_group_ic,
                          title: AppLocalizations.of(context)!.leave_group,
                          onTap: () {
                            UtilsWidget.showDialogCustomInChatScreen(
                                controller.isDeleteConversation,
                                AppLocalizations.of(context)!.leave_group,
                                AppLocalizations.of(context)!.label_are_you_sure_you_want_to_leave_and_delete_this_group_chat_on_your_end,
                                '',
                                (p0) {}, () async {
                              await controller.leaveGroup();
                              Navigator.pop(context);
                            }, isLeave: true, isHiddenCheckbox: true);
                          },
                        ),
                    ];
                  },
                ),
              ],
              actionsIconTheme: IconThemeData(
                color: Get.isDarkMode ? ColorValue.white : ColorValue.neutralLineIcon,
              ),
            ),
            body: Container(
              color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(gradient: LinearGradient(colors: [ColorValue.colorPrimary, ColorValue.colorAppBar])),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                controller.chatAvatar.isNotEmpty
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                            imageUrl: Constant.BASE_URL_IMAGE + controller.chatAvatar.value, width: 48, height: 48))
                                    : Container(
                                        width: 48,
                                        height: 48,
                                        decoration:
                                            BoxDecoration(shape: BoxShape.circle, gradient: Utils.getGradientForLetter(controller.chatName.value)),
                                        child: Center(
                                            child: Text(
                                          Utils.getInitialsName(controller.chatName.value).toUpperCase(),
                                          style: AppTextStyle.regularW600(size: 14, lineHeight: 24, color: Colors.white),
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                if (controller.isGroupAdmin.value == 1)
                                  Positioned(
                                      bottom: (-1.7),
                                      right: -1,
                                      child: PopupMenuButton(
                                          color: Get.isDarkMode ? ColorValue.colorBrCmr : Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          offset: Offset(-30, 20),
                                          child: Container(
                                            decoration: BoxDecoration(color: ColorValue.f0fad86, borderRadius: BorderRadius.circular(25)),
                                            padding: const EdgeInsets.all(2),
                                            child: Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
                                              child: SvgPicture.asset(Images.camera_v1_ic),
                                            ),
                                          ),
                                          itemBuilder: (context) => [
                                                MyEntry(
                                                  icon: Images.take_photo_ic,
                                                  title: AppLocalizations.of(context)!.label_select_photo,
                                                  onTap: () {
                                                    Utils.getImage();
                                                  },
                                                ),
                                                MyEntry(
                                                  icon: Images.camera_ic,
                                                  title: AppLocalizations.of(context)!.label_take_a_picture,
                                                  onTap: () {
                                                    Utils.getMedia(isCamera: true);
                                                  },
                                                ),
                                              ]))
                              ],
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.chatName.value,
                                    style: AppTextStyle.regularW500(size: 16, lineHeight: 20, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (controller.chatType == 2) ...[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${controller.memberLength.value} ${AppLocalizations.of(context)!.members.toLowerCase()}',
                                      style: AppTextStyle.regularW400(size: 12, lineHeight: 16, color: ColorValue.fc9fad9),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ]
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      if (controller.chatType == 2) ...[
                                        _tabBar(index: 5, title: AppLocalizations.of(context)!.members),
                                        SizedBox(
                                          width: 8,
                                        )
                                      ],
                                      _tabBar(index: 3, title: AppLocalizations.of(context)!.media),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      _tabBar(index: 2, title: AppLocalizations.of(context)!.sharelink),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      _tabBar(index: 4, title: AppLocalizations.of(context)!.document),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // controller.isLoading.value
                              //     ? Center(
                              //         child: CircularProgressIndicator(),
                              //       )
                              //     :
                              _content()
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          )),
    );
  }

  _tabBar({required int index, required String title}) {
    return GestureDetector(
      onTap: () async {
        if (controller.tabIndex.value != index) {
          controller.tabIndex.value = index;
          controller.resetData();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: controller.tabIndex.value == index
                ? Get.isDarkMode
                    ? ColorValue.neutralColor
                    : ColorValue.colorBrCmr
                : Get.isDarkMode
                    ? ColorValue.neutralColor
                    : Colors.white,
            border: Border.all(width: (1.5), color: Get.isDarkMode ? ColorValue.neutralColor : ColorValue.colorBrCmr)),
        child: Text(
          title,
          style: AppTextStyle.regularW400(size: 12, lineHeight: 16),
        ),
      ),
    );
  }

  _content() {
    switch (controller.tabIndex.value) {
      case 3:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 17),
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            children: List.generate(controller.listImage.length, (index) {
              if (index == controller.listImage.length - 1 &&
                  controller.hasMoreData.value == true &&
                  controller.listImage.length >= controller.pageSize) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigation.navigateTo(page: 'MediaChatDetail', arguments: Constant.BASE_URL_IMAGE + controller.listImage[index]);
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Utils.getFileType(Constant.BASE_URL_IMAGE + controller.listImage[index]) == 'Video'
                          ? GenThumbnailImage(
                              thumbnailRequest: ThumbnailRequest(
                                  video: Constant.BASE_URL_IMAGE + controller.listImage[index],
                                  thumbnailPath: null,
                                  imageFormat: ImageFormat.WEBP,
                                  maxHeight: (Get.width).toInt(),
                                  maxWidth: (Get.width).toInt(),
                                  timeMs: 1000,
                                  quality: 200,
                                  attachHeaders: false),
                              videoUrl: Constant.BASE_URL_IMAGE + controller.listImage[index])
                          : MediaCustom.showImage(url: Constant.BASE_URL_IMAGE + controller.listImage[index])),
                ),
              );
            }),
          ),
        );
      case 2:
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.linkPreviewList.length,
          separatorBuilder: (context, index) => Container(
            height: 1,
            color: ColorValue.colorBrCmr,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(controller.getLink('${controller.linkPreviewList[index].url}')));
              },
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _itemList(
                    thumbnail: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: MediaCustom.showImage(
                            url: controller.linkPreviewList[index].image ?? '',
                            height: 48,
                            width: 48,
                            errorWidget: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: ColorValue.fffecbb),
                                child: SvgPicture.asset('asset/images/default.svg')))),
                    title: controller.linkPreviewList[index].title ?? AppLocalizations.of(context)!.label_no_title,
                    description: Text(
                      '${controller.linkPreviewList[index].url}',
                      style: AppTextStyle.regularW400(size: 10, lineHeight: 14, color: ColorValue.colorPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
            );
          },
        );
      case 4:
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.mediaList.length,
          separatorBuilder: (context, index) => Container(
            height: (.5),
            color: ColorValue.colorBrCmr,
          ),
          itemBuilder: (context, index) {
            String typeThumbnail = '';
            String dataLink = jsonDecode(controller.mediaList[index].content ?? '')[0];
            String type = Utils.getFileType(Constant.BASE_URL_IMAGE + dataLink);
            switch (type) {
              case 'Microsoft Word':
                typeThumbnail = Images.docx_ic;
                break;
              case 'Microsoft Excel':
                typeThumbnail = Images.xlsm_ic;
                break;
              case 'Microsoft PowerPoint':
                typeThumbnail = Images.pdfx_ic;
                break;
              case 'Text':
                typeThumbnail = Images.txt_ic;
                break;
              // case 'ZIP':
              //   typeThumbnail = 'asset/icons/file.svg';
              //   break;
              default:
                typeThumbnail = Images.file_ic;
            }

            return GestureDetector(
              onTap: () {
                controller.saveFile(url: Constant.BASE_URL_IMAGE + dataLink, fileName: '${controller.mediaList[index].mediaName}');
              },
              child: _itemList(
                thumbnail: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SvgPicture.asset(
                      height: 48,
                      width: 48,
                      typeThumbnail,
                      fit: BoxFit.cover,
                    )),
                title: '${controller.mediaList[index].mediaName}',
                description: _descriptionFile(url: Constant.BASE_URL_IMAGE + dataLink, type: type),
              ),
            );
          },
        );
      case 5:
        return Obx(
          () => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _itemMember(contact: controller.adminChat.value, popupMenuButton: const SizedBox()),
              ),
              if (controller.adminChat.value.uuid != null)
                Container(
                  color: ColorValue.f9fafb,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      _showTabItemUtilGroup(
                        AppLocalizations.of(context)!.label_member,
                        controller.memberList.length,
                        1,
                        () {
                          if (controller.tabSelected.value != 1) {
                            controller.tabSelected.value = 1;
                          }
                        },
                      ),
                      _showTabItemUtilGroup(
                        AppLocalizations.of(context)!.label_locked,
                        0,
                        2,
                        () {
                          if (controller.tabSelected.value != 2) {
                            controller.tabSelected.value = 2;
                            controller.isListMemberLocked = true;
                            controller.getMember();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              if (controller.tabSelected.value == 1)
                SizedBox(
                  width: Get.width,
                  height: Get.height * .9,
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    addAutomaticKeepAlives: true,
                    itemCount: controller.memberList.length,
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: ColorValue.colorBrCmr,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: _itemMember(
                          contact: controller.memberList[index],
                          popupMenuButton: controller.roleId != 1 &&
                                  controller.memberList[index].isFriend == false &&
                                  controller.memberList[index].canMakeFriend == 1
                              ? InkWell(
                                  onTap: () {
                                    controller.addFriend(uuid: controller.memberList[index].uuid!);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        gradient: const LinearGradient(
                                            colors: [ColorValue.f0cbe8c, ColorValue.f5b72de], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                                    child: Text(
                                      controller.memberList[index].isFriend == false
                                          ? AppLocalizations.of(context)!.add_friend
                                          : AppLocalizations.of(context)!.cancel_friend,
                                      style: AppTextStyle.regularW600(size: 14, color: Colors.white, lineHeight: 16),
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: controller.memberList[index].uuid != controller.uuidUser && controller.roleId == 1 ||
                                      (controller.memberList[index].roleId != 1 &&
                                          controller.memberList[index].uuid != controller.uuidUser &&
                                          controller.memberList[index].canMakeFriend == 1 &&
                                          controller.memberList[index].isFriend == false &&
                                          controller.makeFriendState != 0),
                                  child: PopupMenuButton(
                                    color: Colors.white,
                                    offset: Offset(-10, 40),
                                    onSelected: (value) {
                                      if (value == 1) {
                                        controller.leaveGroup(uuid: controller.memberList[index].uuid!, index: index);
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      Images.three_dot_horizontal_ic,
                                      color: Get.isDarkMode ? ColorValue.white : ColorValue.neutralLineIcon,
                                    ),
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                      MyEntry(
                                        widgetCustom: Visibility(
                                            visible: controller.isGroupAdmin.value == 1,
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                              decoration: BoxDecoration(color: ColorValue.f9fafb, borderRadius: BorderRadius.circular(10)),
                                              child: _customShowSwitch(
                                                  check: controller.memberList[index].canMakeFriend != 0,
                                                  title: AppLocalizations.of(context)!.unlock_friend,
                                                  onChanged: (p0) async {
                                                    await controller.changeStateFriend(index: index);
                                                    Navigator.of(context).pop();
                                                  },
                                                  isLast: true),
                                            )),
                                      ),
                                      if (controller.roleId == 1) ...[
                                        MyEntry(
                                            icon: Images.delete_ic,
                                            title: AppLocalizations.of(context)!.delete,
                                            onTap: () {
                                              UtilsWidget.showDialogCustomInChatScreen(
                                                  controller.isDeleteMember,
                                                  AppLocalizations.of(context)!.label_delete_member,
                                                  AppLocalizations.of(context)!.label_are_you_sure_you_want_to_delete_this_member,
                                                  AppLocalizations.of(context)!.label_delete_all_messages_from_the_group, (p0) {
                                                controller.isDeleteMember.value = !controller.isDeleteMember.value;
                                              }, () {
                                                Navigator.pop(context);
                                                controller.leaveGroup(uuid: controller.memberList[index].uuid!, index: index);
                                              }, isDelete: true);
                                            }),
                                        if (controller.memberList[index].isBlock == false)
                                          MyEntry(
                                              icon: Images.lock_message_ic,
                                              title: AppLocalizations.of(context)!.label_lock,
                                              onTap: () {
                                                UtilsWidget.showDialogCustomInChatScreen(
                                                    controller.isLockMember,
                                                    AppLocalizations.of(context)!.label_lock_member,
                                                    AppLocalizations.of(context)!.label_are_you_sure_you_want_to_delete_this_member,
                                                    AppLocalizations.of(context)!.label_delete_all_messages_from_the_group, (p0) {
                                                  controller.isLockMember.value = !controller.isLockMember.value;
                                                }, () {
                                                  Navigator.pop(context);
                                                }, isLockProfile: true, isHiddenCheckbox: true);
                                              }),
                                      ],
                                    ],
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              if (controller.tabSelected.value == 2)
                SizedBox(
                    width: Get.width,
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Images.no_member_locked),
                        SizedBox(height: 10),
                        Text(AppLocalizations.of(context)!.label_no_members_are_locked,
                            style: AppTextStyle.regularW400(size: 10, lineHeight: 12, color: ColorValue.textColor)),
                      ],
                    )
                    // ListView.separated(
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   addAutomaticKeepAlives: true,
                    //   itemCount: controller.memberList.length,
                    //   separatorBuilder: (context, index) => Container(
                    //     height: (.5).h,
                    //     color: ColorValue.colorBrCmr,
                    //   ),
                    //   itemBuilder: (context, index) {
                    //     // if (index == 0) {
                    //     //   return Column(
                    //     //     mainAxisSize: MainAxisSize.min,
                    //     //     children: [
                    //     //
                    //     //     ],
                    //     //   );
                    //     // }
                    //     return Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 20.w),
                    //       child: _itemMember(
                    //         contact: controller.memberList[index],
                    //         // unlock: Visibility(
                    //         //   visible: controller.isGroupAdmin == 1,
                    //         //   child: Row(
                    //         //     children: [
                    //         //       Text(
                    //         //         TextByNation.getStringByKey(KeyByNation.unlock_friend),
                    //         //         style: const TextStyle(
                    //         //             fontWeight: FontWeight.w400, fontSize: 12),
                    //         //       ),
                    //         //       const SizedBox(width: 8),
                    //         //       Switch(
                    //         //         value: controller.memberList[index].canMakeFriend != 0,
                    //         //         activeColor: const Color.fromRGBO(17, 185, 145, 1),
                    //         //         onChanged: (bool value) {
                    //         //           controller.changeStateFriend(index: index);
                    //         //         },
                    //         //       ),
                    //         //       const SizedBox(width: 8),
                    //         //       Container(
                    //         //         color: const Color.fromRGBO(228, 230, 236, 1),
                    //         //         width: .7,
                    //         //         height: 20,
                    //         //       )
                    //         //     ],
                    //         //   ),
                    //         // ),
                    //         popupMenuButton: Visibility(
                    //           visible: controller.memberList[index].uuid !=
                    //               controller.uuidUser &&
                    //               controller.roleId == 1 ||
                    //               (controller.memberList[index].roleId != 1 &&
                    //                   controller.memberList[index].uuid !=
                    //                       controller.uuidUser &&
                    //                   controller
                    //                       .memberList[index].canMakeFriend ==
                    //                       1 &&
                    //                   controller.memberList[index].isFriend ==
                    //                       false &&
                    //                   controller.makeFriendState != 0),
                    //           child: PopupMenuButton(
                    //             color: Colors.white,
                    //             offset: Offset(-10.w, 40.h),
                    //             onSelected: (value) {
                    //               // if (value == 1) {
                    //               //   controller.leaveGroup(
                    //               //       uuid: controller.memberList[index].uuid!,
                    //               //       index: index);
                    //               // } else if (value == 2) {
                    //               //   controller.addFriend(
                    //               //       uuid: controller.memberList[index].uuid!);
                    //               // }
                    //             },
                    //             icon: const Icon(Icons.more_horiz_rounded,
                    //                 color: Color.fromRGBO(146, 154, 169, 1)),
                    //             itemBuilder: (BuildContext context) =>
                    //             <PopupMenuEntry>[
                    //               if (controller.roleId == 1) ...[
                    //                 MyEntry(
                    //                     icon: Images.promote_role_ic,
                    //                     title: TextByNation.getStringByKey(
                    //                         KeyByNation.remove_admin_rights),
                    //                     onTap: () {}),
                    //                 MyEntry(
                    //                     icon: Images.delete_ic,
                    //                     title: TextByNation.getStringByKey(
                    //                         KeyByNation.delete),
                    //                     onTap: () {
                    //                       // controller.leaveGroup(
                    //                       //   uuid: controller.memberList[index].uuid!,
                    //                       //   index: index);
                    //                     }),
                    //                 MyEntry(
                    //                     icon: Images.lock_message_ic,
                    //                     title: TextByNation.getStringByKey(
                    //                         KeyByNation.lock),
                    //                     onTap: () {
                    //                       // controller.leaveGroup(
                    //                       //   uuid: controller.memberList[index].uuid!,
                    //                       //   index: index);
                    //                     }),
                    //                 // PopupMenuItem(
                    //                 //   value: 1,
                    //                 //   child: Row(
                    //                 //     children: [
                    //                 //       Icon(
                    //                 //         Icons.delete_outline_rounded,
                    //                 //         size: 22.sp,
                    //                 //       ),
                    //                 //       SizedBox(
                    //                 //         width: 12.w,
                    //                 //       ),
                    //                 //       Text(
                    //                 //         TextByNation.getStringByKey(
                    //                 //             KeyByNation.delete),
                    //                 //         style: TextStyle(
                    //                 //             fontWeight: FontWeight.w400,
                    //                 //             fontSize: 14.sp),
                    //                 //       )
                    //                 //     ],
                    //                 //   ),
                    //                 // )
                    //               ],
                    //               if (controller.roleId != 1 &&
                    //                   controller.memberList[index].isFriend ==
                    //                       false &&
                    //                   controller
                    //                       .memberList[index].canMakeFriend ==
                    //                       1) ...[
                    //                 PopupMenuItem(
                    //                   value: 2,
                    //                   child: Row(
                    //                     children: [
                    //                       Icon(
                    //                         Icons.person_add_alt_1_outlined,
                    //                         size: 22.sp,
                    //                       ),
                    //                       SizedBox(
                    //                         width: 12.w,
                    //                       ),
                    //                       Text(
                    //                         TextByNation.getStringByKey(
                    //                             KeyByNation.add_friend),
                    //                         style: const TextStyle(
                    //                             fontWeight: FontWeight.w400,
                    //                             fontSize: 14),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 )
                    //               ],
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    )
            ],
          ),
        );
      default:
        return Container();
    }
  }

  _customShowSwitch({required String title, required bool check, required Function(bool)? onChanged, bool? isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyle.regularW400(size: 14, lineHeight: 24, color: ColorValue.neutralColor)),
              Theme(
                data: Theme.of(context).copyWith(
                    switchTheme: SwitchThemeData(
                  trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                )),
                child: Switch(
                  value: check,
                  activeColor: Colors.white,
                  onChanged: onChanged,
                  activeTrackColor: ColorValue.colorPrimary,
                  inactiveTrackColor: ColorValue.colorBrCmr,
                  inactiveThumbColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        if (isLast != true)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Divider(height: 1, color: ColorValue.colorBrCmr),
          )
      ],
    );
  }

  _showTabItemUtilGroup(String title, int number, index, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Text(
          '$title ($number)'.toUpperCase(),
          style: AppTextStyle.regularW600(
            size: 12,
            lineHeight: 16,
            color: controller.tabSelected.value == index ? ColorValue.colorPrimary : ColorValue.textColor,
          ),
        ),
      ),
    );
  }

  _itemList({required Widget thumbnail, required String title, required Widget description, VoidCallback? onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          thumbnail,
          SizedBox(width: 8),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.regularW400(size: 16, lineHeight: 24, color: !Get.isDarkMode ? ColorValue.neutralColor : Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 6,
              ),
              description,
            ],
          )),
          SizedBox(width: 8),
          Visibility(
            visible: onPressed != null,
            child: IconButton(
              onPressed: onPressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.more_vert_rounded),
            ),
          )
        ],
      ),
    );
  }

  _descriptionFile({required String url, required String type}) {
    if (controller.fileTrafficCache.containsKey(url)) {
      return Text(
        '${controller.fileTrafficCache[url]} $type',
        style: AppTextStyle.regularW400(size: 10, lineHeight: 14, color: ColorValue.colorBorder),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return FutureBuilder<String?>(
        future: controller.fetchFileSize(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            controller.fileTrafficCache[url] = snapshot.data!;
            return Text(
              '${snapshot.data!} $type',
              style: AppTextStyle.regularW400(size: 10, lineHeight: 14, color: ColorValue.colorBorder),
              overflow: TextOverflow.ellipsis,
            );
          } else {
            return Text(
              '0mb $type',
              style: AppTextStyle.regularW400(size: 10, lineHeight: 14, color: ColorValue.colorBorder),
              overflow: TextOverflow.ellipsis,
            );
          }
        },
      );
    }
  }

  _itemMember({required ChatDetailMember contact, required Widget popupMenuButton}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          contact.avatar != null && contact.avatar != ''
              ? ClipOval(child: MediaCustom.showImage(url: Constant.BASE_URL_IMAGE + contact.avatar!, width: 48, height: 48))
              : Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: Utils.getGradientForLetter(contact.fullName ?? '')),
                  child: Center(
                      child: Text(
                    Utils.getInitialsName(contact.fullName ?? '').toUpperCase(),
                    style: AppTextStyle.regularW600(size: 14, color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
                ),
          SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.fullName ?? '',
                style: AppTextStyle.regularW500(size: 16, color: Get.isDarkMode ? Colors.white : ColorValue.textColor),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  if (contact.uuid != null)
                    Text(
                      contact.isOnline == true ? 'Online' : AppLocalizations.of(context)!.label_last_seen_recently,
                      style: AppTextStyle.regularW400(size: 14, color: ColorValue.colorPrimary
                          // Get.isDarkMode ? Colors.white : ColorValue.colorBorder
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Visibility(
                      visible: controller.uuidUser == contact.uuid,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            height: 4,
                            width: 4,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Get.isDarkMode ? Colors.white : ColorValue.textColor),
                          ),
                          Text(
                            'Owner',
                            style: AppTextStyle.regularW400(size: 14, lineHeight: 24, color: ColorValue.colorPrimary),
                          )
                        ],
                      ))
                ],
              ),
            ],
          )),
          if (contact.isBlock == true)
            InkWell(
                onTap: () {
                  UtilsWidget.showDialogCustomInChatScreen(false.obs, AppLocalizations.of(context)!.unlock_account,
                      AppLocalizations.of(context)!.label_are_you_sure_you_want_to_unlock_this_member, '', (p0) {}, () {},
                      isUnLock: true, isHiddenCheckbox: true);
                },
                child: SvgPicture.asset(Images.lock_message_ic, color: ColorValue.colorBorder)),
          popupMenuButton
        ],
      ),
    );
  }

  // _itemFriend(
  _showDialogRenameGroup() {
    return showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 20),
              contentPadding: const EdgeInsets.all(26),
              content: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: controller.formState,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.label_rename_the_group,
                        style: AppTextStyle.regularW500(size: 24, lineHeight: 32, color: ColorValue.neutralColor),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return AppLocalizations.of(context)!.label_please_enter_the_group_name;
                          } else if (value == controller.chatName.value) {
                            return AppLocalizations.of(context)!.label_the_group_name_is_duplicated;
                          } else {
                            return null;
                          }
                        },
                        controller: controller.textNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ColorValue.colorBorder, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ColorValue.colorBorder, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: ColorValue.spacingColorNeutralNotifyError, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ColorValue.colorBorder, width: 1)),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buttonSelectRename(() {
                            controller.textNameController.text = controller.chatName.value;
                          }, isReset: true),
                          Row(
                            children: [
                              _buttonSelectRename(
                                () {
                                  Navigator.pop(Get.context!);
                                },
                              ),
                              SizedBox(width: 16),
                              _buttonSelectRename(() async {
                                if (controller.formState.currentState!.validate()) {
                                  await controller.changeGroupInfo();
                                  Navigator.pop(Get.context!);
                                }
                              }, isSave: true)
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  _buttonSelectRename(VoidCallback? onTap, {bool? isReset = false, bool? isSave = false}) {
    return InkWell(
      onTap: onTap,
      child: Text(
        (isReset == true
                ? AppLocalizations.of(context)!.label_reset
                : isSave == true
                    ? AppLocalizations.of(context)!.label_save
                    : AppLocalizations.of(context)!.cancel)
            .toUpperCase(),
        style: AppTextStyle.regularW500(
            size: 16,
            lineHeight: 24,
            color: isReset == true
                ? ColorValue.colorAmber
                : isSave == true
                    ? ColorValue.colorPrimary
                    : ColorValue.textColor),
      ),
    );
  }

  // Expanded(
  // child: Stack(
  // children: [
  // Positioned(
  // top: 0,
  // bottom: 0,
  // left: 0,
  // right: 0,
  // child: SingleChildScrollView(
  // controller: controller.scrollController,
  // child: Column(
  // crossAxisAlignment: CrossAxisAlignment.start,
  // children: [
  // Padding(
  // padding: EdgeInsets.symmetric(vertical: 12.h),
  // child: SingleChildScrollView(
  // scrollDirection: Axis.horizontal,
  // child: Row(
  // children: [
  // SizedBox(
  // width: 20.w,
  // ),
  // if (controller.chatType == 2) ...[
  // _tabBar(
  // index: 5,
  // title: TextByNation.getStringByKey(
  // KeyByNation.members)),
  // SizedBox(
  // width: 8.w,
  // )
  // ],
  // _tabBar(
  // index: 3,
  // title: TextByNation.getStringByKey(
  // KeyByNation.media)),
  // SizedBox(
  // width: 8.w,
  // ),
  // _tabBar(
  // index: 2,
  // title: TextByNation.getStringByKey(
  // KeyByNation.sharelink)),
  // SizedBox(
  // width: 8.w,
  // ),
  // _tabBar(
  // index: 4,
  // title: TextByNation.getStringByKey(
  // KeyByNation.document)),
  // SizedBox(
  // width: 20.w,
  // ),
  // ],
  // ),
  // ),
  // ),
  // controller.isLoading.value
  // ? const Center(
  // child: CircularProgressIndicator(),
  // )
  //     : _content()
  // ],
  // ),
  // ),
  // ),
  // // controller.tabIndex.value != 5
  // //     ? Container()
  // //     : Positioned(
  // //         bottom: 0,
  // //         right: 20,
  // //         child: Visibility(
  // //           visible: controller.showButton.value,
  // //           child: InkWell(
  // //             onTap: () {
  // //               bottomSheetChatItem();
  // //             },
  // //             child: Container(
  // //               padding: const EdgeInsets.all(15),
  // //               decoration: const BoxDecoration(
  // //                   color: ColorValue.colorAppBar,
  // //                   shape: BoxShape.circle),
  // //               child: const Icon(
  // //                   Icons.person_add_alt_1_outlined,
  // //                   color: Colors.white),
  // //             ),
  // //           ),
  // //         ))
  // ],
  // )),

// Container(
  //   padding: const EdgeInsets.symmetric(
  //       horizontal: 20, vertical: 14),
  //   color:
  //       Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
  //   child: Column(
  //     children: [
  //       StaggeredGrid.count(
  //         crossAxisCount:
  //             controller.chatType == 2 && controller.roleId == 1
  //                 ? 3
  //                 : 2,
  //         crossAxisSpacing: 8,
  //         mainAxisSpacing: 8,
  //         children: [
  //           if (controller.chatType == 2 &&
  //               controller.roleId == 1) ...[
  //             StaggeredGridTile.fit(
  //                 crossAxisCellCount: 1,
  //                 child: _button(
  //                   axis: 1,
  //                   icon: Icons.auto_delete_outlined,
  //                   title: TextByNation.getStringByKey(
  //                       KeyByNation.auto_delete),
  //                   onTap: () {
  //                     bottomSheetAutoDelete();
  //                   },
  //                 ))
  //           ],
  //           StaggeredGridTile.fit(
  //               crossAxisCellCount: 1,
  //               child: _button(
  //                 axis: 1,
  //                 icon: Icons.cleaning_services_outlined,
  //                 title: TextByNation.getStringByKey(
  //                     KeyByNation.clear_history),
  //                 onTap: () async {
  //                   await showDialog(
  //                     context: context,
  //                     builder: (context) => _dialogConfirm(
  //                       title:
  //                           "${TextByNation.getStringByKey(KeyByNation.clear_history)} '${controller.chatName.value}'",
  //                       description:
  //                           TextByNation.getStringByKey(
  //                               KeyByNation
  //                                   .clear_history_confirm),
  //                       onTap: () async {
  //                         if (controller.isDialogLoading) {
  //                           controller.isDialogLoading = false;
  //                           await controller.clearMessage();
  //                           //Navigator.pop(context);
  //                           Navigation.navigateGetOffAll(
  //                               page: "Chat");
  //                           controller.isDialogLoading = true;
  //                         }
  //                       },
  //                     ),
  //                   );
  //                 },
  //               )),
  //           StaggeredGridTile.fit(
  //               crossAxisCellCount: 1,
  //               child: _button(
  //                 axis: 1,
  //                 icon: Icons.delete_outline_rounded,
  //                 title: TextByNation.getStringByKey(
  //                     KeyByNation.delete),
  //                 onTap: () async {
  //                   await showDialog(
  //                     context: context,
  //                     builder: (context) => _dialogConfirm(
  //                       title:
  //                           "${TextByNation.getStringByKey(KeyByNation.delete_group)} '${controller.chatName.value}'",
  //                       description:
  //                           TextByNation.getStringByKey(
  //                               KeyByNation
  //                                   .delete_group_confirm),
  //                       onTap: () async {
  //                         if (controller.isDialogLoading) {
  //                           controller.isDialogLoading = false;
  //                           await controller.deleteMessage();
  //                           //Navigator.pop(context);
  //                           Navigation.navigateGetOffAll(
  //                               page: "Chat");
  //                           controller.isDialogLoading = true;
  //                         }
  //                       },
  //                     ),
  //                   );
  //                 },
  //               ))
  //         ],
  //       ),
  //       if (controller.chatType == 1) ...[
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         _button(
  //           axis: 0,
  //           icon: Icons.auto_delete_outlined,
  //           title: TextByNation.getStringByKey(
  //               KeyByNation.auto_delete),
  //           onTap: () {
  //             bottomSheetAutoDelete();
  //           },
  //         )
  //       ],
  //       if (controller.chatType == 2) ...[
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         _button(
  //           axis: 0,
  //           icon: Icons.logout_rounded,
  //           title: TextByNation.getStringByKey(
  //               KeyByNation.leave_group),
  //           onTap: () async {
  //             await showDialog(
  //               context: context,
  //               builder: (context) => _dialogConfirm(
  //                 title: TextByNation.getStringByKey(
  //                     KeyByNation.leave_group),
  //                 description: TextByNation.getStringByKey(
  //                     KeyByNation.leave_group_confirm),
  //                 onTap: () async {
  //                   if (controller.isDialogLoading) {
  //                     controller.isDialogLoading = false;
  //                     await controller.leaveGroup();
  //                     //Navigator.pop(context);
  //                     Navigation.navigateGetOffAll(
  //                         page: "Chat");
  //                     controller.isDialogLoading = true;
  //                   }
  //                 },
  //               ),
  //             );
  //           },
  //         )
  //       ]
  //     ],
  //   ),
  // )

  bottomSheetChatItem(BuildContext context) {
    controller.textSearchController.clear();
    controller.resetDataFriend();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Obx(() => Column(
                children: [
                  Container(
                    width: 32,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Color.fromRGBO(134, 140, 154, 1)),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Color(0xff2d383e) : Color.fromRGBO(240, 243, 251, 1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: controller.textSearchController,
                      decoration: InputDecoration(
                        hintText: '${TextByNation.getStringByKey('search_friend')}',
                        labelStyle: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Get.isDarkMode ? Colors.white70 : null,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 8, left: 18, right: 18),
                      ),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 12),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => controller.resetDataFriend(),
                      child: controller.isFriendLoading.value
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.separated(
                              controller: controller.friendScrollController,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: controller.friendList.length,
                              separatorBuilder: (context, index) => Container(
                                height: .5,
                                color: Color.fromRGBO(228, 230, 236, 1),
                              ),
                              itemBuilder: (context, index) {
                                // if (index == controller.friendList.length - 1 &&
                                //     controller.hasMoreDataFriend.value ==
                                //         true &&
                                //     controller.friendList.length >=
                                //         controller.pageSize) {
                                //   return Center(
                                //     child: CircularProgressIndicator(),
                                //   );
                                // }
                                return _itemFriend(
                                  avatar: controller.friendList[index].avatar,
                                  title: controller.friendList[index].fullName != null
                                      ? controller.friendList[index].fullName!
                                      : controller.friendList[index].userName!,
                                  onTap: () {
                                    controller.leaveGroup(uuid: controller.friendList[index].uuid!, index: index, isAddMember: true);
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _itemFriend({String? avatar, required String title, required GestureTapCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            avatar != null && avatar.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      Constant.BASE_URL_IMAGE + avatar,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        return SvgPicture.asset(
                          'asset/images/default.svg',
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                        );
                      },
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: Utils.getGradientForLetter(title)),
                    child: Center(
                        child: Text(
                      Utils.getInitialsName(title).toUpperCase(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                  ),
            SizedBox(width: 12),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
