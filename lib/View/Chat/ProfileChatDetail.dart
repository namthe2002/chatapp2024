import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/ProfileChatDetailController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../Models/Chat/Chat.dart';

class ProfileChatDetail extends StatefulWidget {
  final Chat? chatDetail;

  ProfileChatDetail({Key? key, this.chatDetail}) : super(key: key);

  @override
  State<ProfileChatDetail> createState() => _ProfileChatDetailState();
}

class _ProfileChatDetailState extends State<ProfileChatDetail> {
  Size size = const Size(0, 0);

  final controller = Get.put(ProfileChatDetailController());

  @override
  Widget build(BuildContext context) {
    controller.selectedChatDetail.value = widget.chatDetail;
    print('namthe12312 ${controller.selectedChatDetail.value?.fullName}');
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<ProfileChatDetailController>();
        return true;
      },
      child: Obx(() => Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: ColorValue.colorAppBar,
              elevation: 0,
              title: controller.isLoading.value
                  ? Container()
                  : Row(
                      children: [
                        controller.isEditGroup.value
                            ? GestureDetector(
                                onTap: () {
                                  controller.getImage();
                                },
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                    child: Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 16,
                                      ),
                                    )),
                              )
                            : controller.chatAvatar.isNotEmpty
                                ? ClipOval(
                                    child: Image.network(
                                      Constant.BASE_URL_IMAGE +
                                          controller.chatAvatar.value,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return SvgPicture.asset(
                                          width: 40,
                                          height: 40,
                                          'asset/images/default.svg',
                                          key: UniqueKey(),
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: Utils.getGradientForLetter(
                                            controller.chatName.value)),
                                    child: Center(
                                        child: Text(
                                      Utils.getInitialsName(
                                              controller.chatName.value)
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                        SizedBox(
                          width: 8,
                        ),
                        controller.isEditGroup.value
                            ? Expanded(
                                child: TextField(
                                controller: controller.textNameController,
                                autofocus: true,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      '${TextByNation.getStringByKey('enter_message')}',
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ))
                            : Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.chatName.value,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (controller.chatType == 2) ...[
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        '${controller.memberLength.value} ${TextByNation.getStringByKey('members').toLowerCase()}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ]
                                  ],
                                ),
                              )
                      ],
                    ),
              actions: [
                Visibility(
                  visible: controller.roleId == 1 && controller.chatType == 2,
                  child: IconButton(
                    onPressed: () async {
                      if (controller.isEditGroup.value) {
                        await controller.changeGroupInfo();
                      }
                      controller.textNameController.text =
                          controller.chatName.value;
                      controller.isEditGroup.value =
                          !controller.isEditGroup.value;
                    },
                    icon: Icon(controller.isEditGroup.value
                        ? Icons.check_rounded
                        : Icons.edit_outlined),
                    tooltip: 'Edit',
                  ),
                )
              ],
            ),
            body: Container(
              color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                      // if (controller.chatType == 2) ...[
                                      _tabBar(
                                          index: 5,
                                          title: TextByNation.getStringByKey(
                                              'members')),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      // ],
                                      _tabBar(
                                          index: 3,
                                          title: TextByNation.getStringByKey(
                                              'media')),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      _tabBar(
                                          index: 2,
                                          title: TextByNation.getStringByKey(
                                              'sharelink')),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      _tabBar(
                                          index: 4,
                                          title: TextByNation.getStringByKey(
                                              'document')),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              controller.isLoading.value
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : _content()
                            ],
                          ),
                        ),
                      ),
                      controller.tabIndex.value != 5
                          ? Container()
                          : Positioned(
                              bottom: 0,
                              right: 20,
                              child: Visibility(
                                visible: controller.showButton.value,
                                child: InkWell(
                                  onTap: () {
                                    bottomSheetChatItem();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color: ColorValue.colorAppBar,
                                        shape: BoxShape.circle),
                                    child: Icon(Icons.person_add_alt_1_outlined,
                                        color: Colors.white),
                                  ),
                                ),
                              ))
                    ],
                  )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    color:
                        Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
                    child: Column(
                      children: [
                        StaggeredGrid.count(
                          crossAxisCount:
                              controller.chatType == 2 && controller.roleId == 1
                                  ? 3
                                  : 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: [
                            if (controller.chatType == 2 &&
                                controller.roleId == 1) ...[
                              StaggeredGridTile.fit(
                                  crossAxisCellCount: 1,
                                  child: _button(
                                    axis: 1,
                                    icon: Icons.auto_delete_outlined,
                                    title: TextByNation.getStringByKey(
                                        'auto_delete'),
                                    onTap: () {
                                      bottomSheetAutoDelete();
                                    },
                                  ))
                            ],
                            StaggeredGridTile.fit(
                                crossAxisCellCount: 1,
                                child: _button(
                                  axis: 1,
                                  icon: Icons.cleaning_services_outlined,
                                  title: TextByNation.getStringByKey(
                                      'clear_history'),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => _dialogConfirm(
                                        title:
                                            "${TextByNation.getStringByKey('clear_history')} '${controller.chatName.value}'",
                                        description:
                                            TextByNation.getStringByKey(
                                                'clear_history_confirm'),
                                        onTap: () async {
                                          if (controller.isDialogLoading) {
                                            controller.isDialogLoading = false;
                                            await controller.clearMessage();
                                            //Navigator.pop(context);
                                            Navigation.navigateGetOffAll(
                                                page: "Chat");
                                            controller.isDialogLoading = true;
                                          }
                                        },
                                      ),
                                    );
                                  },
                                )),
                            StaggeredGridTile.fit(
                                crossAxisCellCount: 1,
                                child: _button(
                                  axis: 1,
                                  icon: Icons.delete_outline_rounded,
                                  title: TextByNation.getStringByKey('delete'),
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => _dialogConfirm(
                                        title:
                                            "${TextByNation.getStringByKey('delete_group')} '${controller.chatName.value}'",
                                        description:
                                            TextByNation.getStringByKey(
                                                'delete_group_confirm'),
                                        onTap: () async {
                                          if (controller.isDialogLoading) {
                                            controller.isDialogLoading = false;
                                            await controller.deleteMessage();
                                            //Navigator.pop(context);
                                            Navigation.navigateGetOffAll(
                                                page: "Chat");
                                            controller.isDialogLoading = true;
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ))
                          ],
                        ),
                        if (controller.chatType == 1) ...[
                          SizedBox(
                            height: 8,
                          ),
                          _button(
                            axis: 0,
                            icon: Icons.auto_delete_outlined,
                            title: TextByNation.getStringByKey('auto_delete'),
                            onTap: () {
                              bottomSheetAutoDelete();
                            },
                          )
                        ],
                        if (controller.chatType == 2) ...[
                          SizedBox(
                            height: 8,
                          ),
                          _button(
                            axis: 0,
                            icon: Icons.logout_rounded,
                            title: TextByNation.getStringByKey('leave_group'),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => _dialogConfirm(
                                  title: TextByNation.getStringByKey(
                                      'leave_group'),
                                  description: TextByNation.getStringByKey(
                                      'leave_group_confirm'),
                                  onTap: () async {
                                    if (controller.isDialogLoading) {
                                      controller.isDialogLoading = false;
                                      await controller.leaveGroup();
                                      //Navigator.pop(context);
                                      Navigation.navigateGetOffAll(
                                          page: "Chat");
                                      controller.isDialogLoading = true;
                                    }
                                  },
                                ),
                              );
                            },
                          )
                        ]
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  _button(
      {required IconData icon,
      required String title,
      required int axis,
      required GestureTapCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Color(0xff232323)
                : Color.fromRGBO(240, 243, 251, 1),
            borderRadius: BorderRadius.circular(8)),
        child: axis == 1
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 26,
                    color: Get.isDarkMode ? ColorValue.colorTextDark : null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color:
                            Get.isDarkMode ? ColorValue.colorTextDark : null),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 26,
                    color: Get.isDarkMode ? ColorValue.colorTextDark : null,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color:
                            Get.isDarkMode ? ColorValue.colorTextDark : null),
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
      ),
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
                    ? Color(0xff232323)
                    : Color.fromRGBO(228, 230, 236, 1)
                : Get.isDarkMode
                    ? ColorValue.neutralColor
                    : Colors.white,
            border: Border.all(
                width: 1.5,
                color: Get.isDarkMode
                    ? Color(0xff232323)
                    : Color.fromRGBO(228, 230, 236, 1))),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  _content() {
    switch (controller.tabIndex.value) {
      case 3:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: StaggeredGrid.count(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            children: List.generate(controller.listImage.length, (index) {
              if (index == controller.listImage.length - 1 &&
                  controller.hasMoreData.value == true &&
                  controller.listImage.length >= controller.pageSize) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigation.navigateTo(
                        page: 'MediaChatDetail',
                        arguments: Constant.BASE_URL_IMAGE +
                            controller.listImage[index]);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Utils.getFileType(Constant.BASE_URL_IMAGE +
                                controller.listImage[index]) ==
                            'Video'
                        ? _videoThumbnail(Constant.BASE_URL_IMAGE +
                            controller.listImage[index])
                        : Image.network(
                            Constant.BASE_URL_IMAGE +
                                controller.listImage[index],
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return SvgPicture.asset(
                                'asset/images/default.svg',
                                key: UniqueKey(),
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                  ),
                ),
              );
            }),
          ),
        );
      case 2:
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.linkPreviewList.length,
          separatorBuilder: (context, index) => Container(
            height: .5,
            color: Color.fromRGBO(228, 230, 236, 1),
          ),
          itemBuilder: (context, index) {
            if (index == controller.linkPreviewList.length - 1 &&
                controller.hasMoreData.value == true &&
                controller.linkPreviewList.length >= controller.pageSize) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return GestureDetector(
              onTap: () async {
                await launchUrl(Uri.parse(controller
                    .getLink('${controller.linkPreviewList[index].url}')));
              },
              child: _itemList(
                thumbnail: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      height: 48,
                      width: 48,
                      '${controller.linkPreviewList[index].image}',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return SvgPicture.asset(
                          'asset/images/default.svg',
                          key: UniqueKey(),
                          fit: BoxFit.cover,
                          width: 48,
                        );
                      },
                    )),
                title: '${controller.linkPreviewList[index].title}',
                description: Text(
                  '${controller.linkPreviewList[index].url}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Color.fromRGBO(17, 185, 145, 1)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
      case 4:
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.mediaList.length,
          separatorBuilder: (context, index) => Container(
            height: .5,
            color: Color.fromRGBO(228, 230, 236, 1),
          ),
          itemBuilder: (context, index) {
            String typeThumbnail = '';
            String dataLink =
                jsonDecode(controller.mediaList[index].content!)[0];
            String type = Utils.getFileType(Constant.BASE_URL_IMAGE + dataLink);
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

            if (index == controller.mediaList.length - 1 &&
                controller.hasMoreData.value == true &&
                controller.mediaList.length >= controller.pageSize) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return GestureDetector(
              onTap: () {
                controller.saveFile(
                    url: Constant.BASE_URL_IMAGE + dataLink,
                    fileName: '${controller.mediaList[index].mediaName}');
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
                description: _descriptionFile(
                    url: Constant.BASE_URL_IMAGE + dataLink, type: type),
              ),
            );
          },
        );
      case 5:
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.memberList.length,
          separatorBuilder: (context, index) => Container(
            height: .5,
            color: Color.fromRGBO(228, 230, 236, 1),
          ),
          itemBuilder: (context, index) {
            // if (index == controller.memberList.length - 1 &&
            //     controller.hasMoreData.value == true &&
            //     controller.memberList.length >= controller.pageSize) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            // return Text(
            //   index.toString(),
            //   style: TextStyle(color: ColorValue.colorYl),
            // );
            return _itemMember(
              avatar: controller.memberList[index].avatar,
              title: controller.memberList[index].fullName ??
                  controller.memberList[index].userName!,
              description: controller.memberList[index].roleId == 1
                  ? TextByNation.getStringByKey('leader')
                  : controller.memberList[index].uuid == controller.uuidUser
                      ? TextByNation.getStringByKey('me')
                      : controller.memberList[index].isFriend == true
                          ? TextByNation.getStringByKey('friend')
                          : TextByNation.getStringByKey('members'),
              unlock: Visibility(
                visible: controller.IsGroupAdmin == 1,
                child: Row(
                  children: [
                    Text(
                      TextByNation.getStringByKey('unlock_friend'),
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    Switch(
                      value: controller.memberList[index].canMakeFriend != 0,
                      activeColor: Color.fromRGBO(17, 185, 145, 1),
                      onChanged: (bool value) {
                        controller.changeStateFriend(index: index);
                      },
                    ),
                    SizedBox(width: 8),
                    Container(
                      color: Color.fromRGBO(228, 230, 236, 1),
                      width: .7,
                      height: 20,
                    )
                  ],
                ),
              ),
              popupMenuButton: Visibility(
                visible:
                    controller.memberList[index].uuid != controller.uuidUser &&
                            controller.roleId == 1 ||
                        (controller.memberList[index].roleId != 1 &&
                            controller.memberList[index].uuid !=
                                controller.uuidUser &&
                            controller.memberList[index].canMakeFriend == 1 &&
                            controller.memberList[index].isFriend == false &&
                            controller.makeFriendState != 0),
                child: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 1) {
                      controller.leaveGroup(
                          uuid: controller.memberList[index].uuid!,
                          index: index);
                    } else if (value == 2) {
                      controller.addFriend(
                          uuid: controller.memberList[index].uuid!);
                    }
                  },
                  icon: Icon(Icons.more_horiz_rounded,
                      color: Color.fromRGBO(146, 154, 169, 1)),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    if (controller.roleId == 1) ...[
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 22,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              TextByNation.getStringByKey('delete'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            )
                          ],
                        ),
                      )
                    ],
                    if (controller.roleId != 1 &&
                        controller.memberList[index].isFriend == false &&
                        controller.memberList[index].canMakeFriend == 1) ...[
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 22,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              TextByNation.getStringByKey('add_friend'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 14),
                            )
                          ],
                        ),
                      )
                    ],
                  ],
                ),
              ),
            );
          },
        );
      default:
        return Container();
    }
  }

  _videoThumbnail(String videoUrl) {
    if (controller.thumbnailCache.containsKey(videoUrl)) {
      // Sử dụng hình ảnh từ cache nếu có.
      return _buildThumbnailImage(controller.thumbnailCache[videoUrl]!);
    } else {
      return FutureBuilder<Uint8List?>(
        future: _generateThumbnail(videoUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            // Lưu hình ảnh vào cache và hiển thị nó.
            controller.thumbnailCache[videoUrl] = snapshot.data!;
            return _buildThumbnailImage(snapshot.data!);
          } else {
            return Center(
              child: Container(
                height: 30,
                width: 30,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildThumbnailImage(Uint8List thumbnailData) {
    return Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Image.memory(
          key: UniqueKey(),
          thumbnailData,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return SvgPicture.asset(
              'asset/images/default.svg',
              key: UniqueKey(),
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.3)),
            child: Icon(Icons.play_arrow_rounded,
                color: Color.fromRGBO(255, 255, 255, 0.8)),
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

  _itemList(
      {required Widget thumbnail,
      required String title,
      required Widget description,
      VoidCallback? onPressed}) {
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
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
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
              constraints: BoxConstraints(),
              icon: Icon(Icons.more_vert_rounded),
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
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: Color.fromRGBO(146, 154, 169, 1)),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return FutureBuilder<String?>(
        future: controller.fetchFileSize(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            controller.fileTrafficCache[url] = snapshot.data!;
            return Text(
              '${snapshot.data!} $type',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Color.fromRGBO(146, 154, 169, 1)),
              overflow: TextOverflow.ellipsis,
            );
          } else {
            return Text(
              '0mb $type',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: Color.fromRGBO(146, 154, 169, 1)),
              overflow: TextOverflow.ellipsis,
            );
          }
        },
      );
    }
  }

  _itemMember(
      {String? avatar,
      required String title,
      required String description,
      Widget? unlock,
      required Widget popupMenuButton}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          avatar != null
              ? ClipOval(
                  child: Image.network(
                    Constant.BASE_URL_IMAGE + avatar,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
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
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: Utils.getGradientForLetter(title)),
                  child: Center(
                      child: Text(
                    Utils.getInitialsName(title).toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  )),
                ),
          SizedBox(width: 12),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                description,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color.fromRGBO(146, 154, 169, 1)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )),
          SizedBox(width: 10),
          unlock ?? Container(),
          SizedBox(width: 8),
          popupMenuButton
        ],
      ),
    );
  }

  _itemFriend(
      {String? avatar,
      required String title,
      required GestureTapCallback onTap}) {
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
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
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
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: Utils.getGradientForLetter(title)),
                    child: Center(
                        child: Text(
                      Utils.getInitialsName(title).toUpperCase(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
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

  bottomSheetChatItem() {
    controller.textSearchController.clear();
    controller.resetDataFriend();
    return showModalBottomSheet(
      context: Get.context!,
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Obx(() => Column(
                children: [
                  Container(
                    width: 32,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color.fromRGBO(134, 140, 154, 1)),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 40,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Color(0xff2d383e)
                          : Color.fromRGBO(240, 243, 251, 1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: controller.textSearchController,
                      decoration: InputDecoration(
                        hintText:
                            '${TextByNation.getStringByKey('search_friend')}',
                        labelStyle: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        hintStyle: TextStyle(
                          color: Get.isDarkMode ? Colors.white70 : null,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(bottom: 8, left: 18, right: 18),
                      ),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                                  title: controller
                                              .friendList[index].fullName !=
                                          null
                                      ? controller.friendList[index].fullName!
                                      : controller.friendList[index].userName!,
                                  onTap: () {
                                    controller.leaveGroup(
                                        uuid:
                                            controller.friendList[index].uuid!,
                                        index: index,
                                        isAddMember: true);
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

  _dialogConfirm(
      {required String title,
      required String description,
      required GestureTapCallback onTap}) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              description,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(Get.context!);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      TextByNation.getStringByKey('cancel').toUpperCase(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      TextByNation.getStringByKey('confirm').toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(17, 185, 145, 1)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  bottomSheetAutoDelete() {
    return showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  width: 32,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color.fromRGBO(134, 140, 154, 1)),
                ),
              ),
              SizedBox(height: 12),
              Text(
                TextByNation.getStringByKey('auto_delete_title'),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                TextByNation.getStringByKey('auto_delete_content'),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.timeList.length,
                separatorBuilder: (context, index) => Container(
                  height: .5,
                  color: Color.fromRGBO(228, 230, 236, 1),
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await controller.autoDelete(
                          day: controller.timeList[index]);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        controller.timeList[index] == 0
                            ? TextByNation.getStringByKey('off')
                            : '${controller.timeList[index]} ${controller.timeList[index] > 1 ? TextByNation.getStringByKey('days') : TextByNation.getStringByKey('day')}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: controller.autoDeleteData ==
                                    controller.timeList[index]
                                ? Color.fromRGBO(17, 185, 145, 1)
                                : null),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }
}
