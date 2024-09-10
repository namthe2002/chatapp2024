import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Component/ChatBubbleAudio.dart';
import 'package:live_yoko/Controller/Chat/ChatDetailController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Models/Chat/ChatDetail.dart' as cd;
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Speech2Text.dart';
import 'package:live_yoko/Utils/Translator.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/View/Chat/ProfileChatDetail.dart';
import 'package:live_yoko/widget/my_entry.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';
import 'package:lottie/lottie.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controller/Chat/ChatController.dart';
import '../../Models/Chat/Chat.dart';
import '../../Models/Chat/emoji/emoji_model.dart';
import '../../Service/SocketManager.dart';
import '../../Service/giphy_get/screen/giphy_detail.dart';
import '../../Utils/thumnail_generator.dart';
import '../../core/constant/sticker/sticker.dart';
import '../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/utils_widget.dart';

class ChatBoxDetail extends StatefulWidget {
  final Chat? chatDetail;

  ChatBoxDetail({Key? key, this.chatDetail}) : super(key: key);

  @override
  State<ChatBoxDetail> createState() => _ChatBoxDetailState();
}

class _ChatBoxDetailState extends State<ChatBoxDetail>
    with TickerProviderStateMixin {
  final controller = Get.put(ChatDetailController());
  late TabController _tabEmojiController;

  Size size = Size(0, 0);

  ImageFormat _format = ImageFormat.JPEG;

  int _quality = 200;

  bool _attachHeaders = false;

  int _timeMs = 0;

  GenThumbnailImage? futureImage;

  OverlayEntry? _overlayEntry;
  bool _isOverIcon = false;
  bool _isOverOverlay = false;

  Timer? _overlayTimer;
  bool _hasMouseEntered = false;

  List<String> listReaction = [
    'asset/icons/fire.svg',
    'asset/icons/heart.svg',
    'asset/icons/smiling_face_with_heart_eyes.svg',
    'asset/icons/smiling_face_with_sunglasses.svg',
    'asset/icons/loudly_crying_face.svg',
    'asset/icons/face_with_tears_of_joy.svg',
    'asset/icons/like.svg',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initChatData();
    _tabEmojiController = TabController(length: 3, vsync: this);
    _tabEmojiController.addListener(_updateTabHeight);
  }

  void _hideOverlay() {
    _overlayTimer?.cancel();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _hasMouseEntered = false;
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(context);
      Overlay.of(context)!.insert(_overlayEntry!);

      // Start the initial 2-second timer
      _overlayTimer = Timer(Duration(seconds: 2), () {
        if (!_hasMouseEntered) {
          _hideOverlay();
        }
      });
    }
  }

  void _updateOverlayVisibility() {
    if (!_isOverIcon && !_isOverOverlay) {
      // Start a 1-second timer when the mouse leaves
      _overlayTimer?.cancel();
      _overlayTimer = Timer(Duration(milliseconds: 100), _hideOverlay);
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: 70,
        left: Get.width / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _isOverOverlay = true;
                _hasMouseEntered = true;
              });
              _overlayTimer?.cancel(); // Cancel any existing timer
            },
            onExit: (_) {
              setState(() => _isOverOverlay = false);
              _updateOverlayVisibility();
            },
            child: Material(
              child: AnimatedContainer(
                width: 550,
                height: 350,
                duration: const Duration(milliseconds: 2000),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  // color: Colors.transparent.withOpacity(0.1),
                  border: Border.all(width: 0.5),
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                            controller: _tabEmojiController,
                            children: [
                              EmojiPicker(
                                textEditingController:
                                    controller.textMessageController,
                                config: Config(
                                  emojiTextStyle: TextStyle(
                                    fontFamily: 'NotoColorEmoji',
                                  ),
                                  emojiViewConfig: EmojiViewConfig(
                                    emojiSizeMax: 28 * 1.0,
                                    backgroundColor: Colors.transparent,
                                    // Sử dụng customWidget để điều khiển hiển thị emoji với font 'NotoColorEmoji'
                                  ),
                                  swapCategoryAndBottomBar: true,
                                  categoryViewConfig: CategoryViewConfig(
                                    backgroundColor: Colors.transparent,
                                    tabBarHeight: 46,
                                    dividerColor: Colors.transparent,
                                  ),
                                  bottomActionBarConfig:
                                      const BottomActionBarConfig(
                                    enabled: false,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: GiphyTabDetail(
                                    chatDetailController: controller,
                                    scrollController: ScrollController()),
                              ),
                              //stickers
                              DefaultTabController(
                                  length: stickerPacks.length,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                          height: 50,
                                          child: TabBar(
                                            tabAlignment: TabAlignment.start,
                                            dividerColor: Colors.transparent,
                                            isScrollable: true,
                                            tabs: List.generate(
                                                stickerPacks.length, (index) {
                                              return Image.asset(
                                                  stickerPacks[index]
                                                          ['tray_image_file']
                                                      as String);
                                            }),
                                          )),
                                      Expanded(
                                        child: TabBarView(
                                            children: List.generate(
                                                stickerPacks.length, (index) {
                                          return GridView.builder(
                                              itemCount: (stickerPacks[index]
                                                      ['stickers'] as List)
                                                  .length,
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      crossAxisSpacing: 10,
                                                      mainAxisSpacing: 10),
                                              itemBuilder: (context, indexStic) =>
                                                  InkWell(
                                                    onTap: () {
                                                      controller.sendMessage(
                                                          content: (stickerPacks[
                                                                          index]
                                                                      ['stickers']
                                                                  as List)[
                                                              indexStic]['text'],
                                                          type: 6);
                                                    },
                                                    child: Image.asset(
                                                        (stickerPacks[index]
                                                                    ['stickers']
                                                                as List)[indexStic]
                                                            ['image_file']),
                                                  ));
                                        })),
                                      )
                                    ],
                                  )),
                            ]),
                      ),
                      TabBar(
                        controller: _tabEmojiController,
                        tabs: const [
                          Tab(child: Text('Emoji')),
                          Tab(child: Text('GIFs')),
                          Tab(child: Text('Sticker')),
                        ],
                        unselectedLabelColor: ColorValue.colorTextDark,
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.transparent,
                        tabAlignment: TabAlignment.center,
                        labelColor: Get.isDarkMode
                            ? Colors.lightBlueAccent
                            : ColorValue.neutralLineIcon,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateTabHeight() {
    if (controller.isExtendShowEmoji.value) {
      if (_tabEmojiController.indexIsChanging) {
        if (_tabEmojiController.index == 0) {
          controller.isExtendShowEmoji.value =
              !controller.isExtendShowEmoji.value;
          controller.tabHeight = (256.0).obs;
        } else {
          controller.tabHeight = (Get.height * .796).obs;
        }
      } else {
        if (_tabEmojiController.index == 0) {
          controller.tabHeight = (256.0).obs;
          controller.isExtendShowEmoji.value =
              !controller.isExtendShowEmoji.value;
        } else {
          controller.tabHeight = (Get.height * .796).obs;
        }
      }
    } else {
      controller.tabHeight = 256.0.obs;
    }

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    controller.selectedChatDetail.value = widget.chatDetail;
    size = MediaQuery.of(context).size;
    return Obx(
      () => controller.selectedChatDetail.value == null
          ? Scaffold(body: emptyChat())
          : Scaffold(
              appBar: AppBar(
                backgroundColor: controller.isShowMultiselect.value
                    ? (Get.isDarkMode
                        ? Color(controller.textColor)
                        : Colors.white)
                    : Color(controller.textColor),
                title: controller.isShowMultiselect.value
                    ? Text(
                        '${controller.selectedItems.length} ${TextByNation.getStringByKey('select')}',
                      )
                    : controller.isSearch.value
                        ? TextField(
                            controller: controller.textSearchController,
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
                          )
                        : controller.isChatLoading.value
                            ? Container()
                            : SizedBox(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.showGroupInfoMode();
                                  },
                                  child: Row(
                                    children: [
                                      controller.chatAvatar.isNotEmpty
                                          ? Obx(
                                              () => Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    Constant.BASE_URL_IMAGE +
                                                        controller
                                                            .chatAvatar.value,
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return SvgPicture.asset(
                                                        width: 40,
                                                        height: 40,
                                                        'asset/images/default.svg',
                                                        key: UniqueKey(),
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Obx(
                                              () => Container(
                                                width: 40,
                                                height: 40,
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    gradient: Utils
                                                        .getGradientForLetter(
                                                            controller.chatName
                                                                .value)),
                                                child: Center(
                                                    child: Text(
                                                  Utils.getInitialsName(
                                                          controller
                                                              .chatName.value)
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                )),
                                              ),
                                            ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              const SizedBox(
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
                                ),
                              ),
                actions: [
                  if (controller.isShowMultiselect.value) ...[
                    IconButton(
                      onPressed: () async {
                        await controller.pinMessage(state: 1);
                        controller.isShowMultiselect.value = false;
                      },
                      icon: Icon(
                        Icons.push_pin_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (controller.isClickLoading) {
                          controller.isClickLoading = false;
                          await controller.deleteMessage();
                          controller.isShowMultiselect.value = false;
                          controller.isClickLoading = true;
                        }
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                      ),
                    ),
                  ] else ...[
                    controller.isSearch.value
                        ? const SizedBox()
                        : IconButton(
                            onPressed: () {
                              // controller.isSearch.value = !controller.isSearch.value;
                              // controller.textSearchController.clear();
                            },
                            icon: Icon(
                              Icons.call,
                            ),
                          ),
                    IconButton(
                      onPressed: () {
                        controller.isSearch.value = !controller.isSearch.value;
                        controller.textSearchController.clear();
                      },
                      icon: Icon(
                        controller.isSearch.value
                            ? Icons.close_rounded
                            : Icons.search,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.showGroupInfoMode();
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                      ),
                    ),
                  ]
                ],
              ),
              body: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(Get.isDarkMode
                                  ? 'asset/images/bg_dark.png'
                                  : 'asset/images/bg_light.png'),
                              fit: BoxFit.cover)),
                      child: Obx(() => Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.08),
                            child: Column(
                              children: [
                                Expanded(
                                    child: controller.isChatLoading.value
                                        ? Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : controller.chatList.isEmpty
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: size.width,
                                                  ),
                                                  SvgPicture.asset(
                                                      'asset/images/empty_chat_detail.svg'),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    '${TextByNation.getStringByKey('no_message')}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              )
                                            : Stack(
                                                children: [
                                                  // if (controller.chatList.isNotEmpty && controller.hasMoreData.value && controller.pageSize < controller.chatList.length) ...[
                                                  //   Center(
                                                  //     child: CircularProgressIndicator(
                                                  //       backgroundColor: Colors.white,
                                                  //     ),
                                                  //   )
                                                  // ],
                                                  Positioned(
                                                      top: 0,
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Column(
                                                        children: [
                                                          controller
                                                                  .isPinLoading
                                                                  .value
                                                              ? Container()
                                                              : controller
                                                                      .pinList
                                                                      .isEmpty
                                                                  ? Container()
                                                                  : Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          color: Get.isDarkMode
                                                                              ? Color(0xff232323)
                                                                              : Colors.white,
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.grey.withOpacity(0.5),
                                                                              spreadRadius: .1,
                                                                              blurRadius: 10,
                                                                              offset: Offset(0, 3), // changes position of shadow
                                                                            ),
                                                                          ]),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                20,
                                                                          ),
                                                                          SvgPicture.asset(
                                                                              'asset/icons/pin.svg',
                                                                              color: Color(controller.textColor)),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                              child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                TextByNation.getStringByKey('pinned_message'),
                                                                                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Color(controller.textColor)),
                                                                              ),
                                                                              SizedBox(height: 5),
                                                                              _chatContentType(message: controller.pinList[0], time: DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(controller.pinList[0].timeCreated.toString(), true).toLocal(), pinType: 1)
                                                                            ],
                                                                          )),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (context) => _dialogPin(),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                                              decoration: BoxDecoration(color: Get.isDarkMode ? Color.fromRGBO(152, 152, 152, 1.0) : Color.fromRGBO(228, 230, 236, 1), borderRadius: BorderRadius.circular(20)),
                                                                              child: Row(
                                                                                children: [
                                                                                  SvgPicture.asset(
                                                                                    'asset/icons/pin_note.svg',
                                                                                    color: Get.isDarkMode ? Colors.white : Colors.black,
                                                                                  ),
                                                                                  SizedBox(width: 8),
                                                                                  Text(
                                                                                    '${controller.pinList.length}',
                                                                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          // IconButton(
                                                                          //     onPressed:
                                                                          //         () async {
                                                                          //       controller
                                                                          //           .selectedItems
                                                                          //           .add(controller
                                                                          //               .pinList[0]
                                                                          //               .uuid!);
                                                                          //       await controller
                                                                          //           .pinMessage(
                                                                          //         state:
                                                                          //             0,
                                                                          //       );
                                                                          //     },
                                                                          //     icon: Icon(Icons
                                                                          //         .close_rounded))
                                                                        ],
                                                                      ),
                                                                    ),
                                                          Expanded(
                                                              child:
                                                                  ScrollablePositionedList
                                                                      .builder(
                                                            reverse: true,
                                                            itemScrollController:
                                                                controller
                                                                    .itemScrollController,
                                                            itemPositionsListener:
                                                                controller
                                                                    .itemPositionsListener,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            itemCount: controller
                                                                    .chatList
                                                                    .length +
                                                                1,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              if (index == 0) {
                                                                return Obx(() => controller
                                                                        .userTyping
                                                                        .value
                                                                        .isEmpty
                                                                    ? Container()
                                                                    : Row(
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              '${utf8.decode(base64Url.decode(controller.userTyping.value))} ${TextByNation.getStringByKey('is_typing')}',
                                                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          Lottie
                                                                              .asset(
                                                                            'asset/json/importing.json',
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                15,
                                                                          )
                                                                        ],
                                                                      ));
                                                              }
                                                              return _chatItem(
                                                                  context,
                                                                  index: index -
                                                                      1);
                                                            },
                                                          ))
                                                        ],
                                                      )),
                                                  Positioned(
                                                    bottom: 20,
                                                    right: 20,
                                                    child: Visibility(
                                                      visible: controller
                                                          .isNewMessage.value,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          controller
                                                                  .isNewMessage
                                                                  .value =
                                                              !controller
                                                                  .isNewMessage
                                                                  .value;
                                                          controller
                                                              .itemScrollController
                                                              .scrollTo(
                                                                  index: 0,
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  alignment:
                                                                      0.5);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? Colors.white70
                                                                : Colors
                                                                    .black26,
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                if (!controller.isSearch.value) ...[
                                  controller.replyChat.value.uuid == null
                                      ? Container()
                                      : Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? Color(0xff232323)
                                                : Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Get.isDarkMode
                                                        ? Colors.grey
                                                        : Color.fromRGBO(
                                                            228, 230, 236, 1))),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: .1,
                                                blurRadius: 10,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                controller.isEdit.value == 1
                                                    ? 'asset/icons/edit.svg'
                                                    : 'asset/icons/reply.svg',
                                                color:
                                                    Color(controller.textColor),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller.isEdit.value == 1
                                                        ? TextByNation
                                                            .getStringByKey(
                                                                'edit')
                                                        : '${TextByNation.getStringByKey('reply')} ${controller.decodedName(controller.replyChat.value.fullName ?? controller.replyChat.value.userSent!)}',
                                                    style: TextStyle(
                                                        color: Color(controller
                                                            .textColor),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  AbsorbPointer(
                                                    absorbing: true,
                                                    child: Opacity(
                                                      opacity: .5,
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: controller
                                                                        .replyChat
                                                                        .value
                                                                        .contentType ==
                                                                    3
                                                                ? 50
                                                                : 0),
                                                        child: _chatContentType(
                                                            message: controller
                                                                .replyChat
                                                                .value,
                                                            time: DateFormat(
                                                                    "yyyy-MM-dd'T'HH:mm:ss")
                                                                .parse(
                                                                    controller
                                                                        .replyChat
                                                                        .value
                                                                        .timeCreated
                                                                        .toString(),
                                                                    true)
                                                                .toLocal(),
                                                            replyShow: true),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                              IconButton(
                                                onPressed: () {
                                                  controller.isEdit.value = 0;
                                                  controller.replyChat.value =
                                                      cd.ChatDetail();
                                                },
                                                icon: Icon(
                                                  Icons.close_rounded,
                                                  color: Color.fromRGBO(
                                                      146, 154, 169, 1),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 16),
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? Color(0xff232323)
                                                : ColorValue.colorBrSearch,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: controller
                                                        .replyChat.value.uuid !=
                                                    null
                                                ? null
                                                : [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: .1,
                                                      blurRadius: 10,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // icon, gif, emoji
                                              MouseRegion(
                                                  onEnter: (event) =>
                                                      _showOverlay(context),
                                                  onExit: (event) {
                                                    setState(() =>
                                                        _isOverIcon = false);
                                                    _updateOverlayVisibility();
                                                  },
                                                  child: Icon(Icons
                                                      .emoji_emotions_outlined)),
                                              // I
                                              if (controller
                                                  .isRecording.value) ...[
                                                IconButton(
                                                  onPressed: () async {
                                                    if (controller
                                                        .isRecording.value) {
                                                      await controller.recorder
                                                          .stop();
                                                      controller.isRecording
                                                          .value = false;
                                                    }
                                                  },
                                                  icon: Icon(Icons
                                                      .delete_outline_rounded),
                                                ),
                                                Expanded(child: SizedBox()),
                                                IconButton(
                                                  onPressed: () async {
                                                    await controller
                                                        .startOrStopRecording(
                                                            isSend: true);
                                                  },
                                                  icon:
                                                      Icon(Icons.send_rounded),
                                                )
                                              ] else ...[
                                                Expanded(
                                                  child: TextField(
                                                    controller: controller
                                                        .textMessageController,
                                                    focusNode:
                                                        controller.focusNode,
                                                    onSubmitted: (value) async {
                                                      if (value
                                                          .trim()
                                                          .isNotEmpty) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                controller
                                                                    .focusNode);
                                                        controller
                                                            .isTextFieldFocused
                                                            .value = false;
                                                        Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    300), () {
                                                          controller.isVisible
                                                              .value = true;
                                                          Get.put(ChatController())
                                                              .selectedChatIndex
                                                              .value = 0;
                                                        });
                                                        if (controller
                                                                .isEdit.value ==
                                                            1) {
                                                          await controller
                                                              .editMessage();
                                                        } else {
                                                          await controller
                                                              .sendMessage(
                                                            content: controller
                                                                .textMessageController
                                                                .text,
                                                            type: controller.isImageLink(
                                                                    controller
                                                                        .textMessageController
                                                                        .text)
                                                                ? 7
                                                                : controller.isLink(
                                                                        controller
                                                                            .textMessageController
                                                                            .text)
                                                                    ? 2
                                                                    : 1,
                                                          );
                                                        }
                                                      }
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          '${TextByNation.getStringByKey('type_a_message')}',
                                                      hintStyle: TextStyle(
                                                        color: Get.isDarkMode
                                                            ? Colors.white70
                                                            : Colors.grey,
                                                        fontSize: 14, //
                                                      ),
                                                      labelStyle: TextStyle(
                                                        color: Get.isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 15),
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily:
                                                          'NotoColorEmoji',
                                                    ),
                                                  ),
                                                ),
                                                controller.isTextFieldFocused
                                                        .value
                                                    ? IconButton(
                                                        onPressed: () async {
                                                          Get.put(ChatController())
                                                              .selectedChatIndex
                                                              .value = 0;
                                                          if (controller.isEdit
                                                                  .value ==
                                                              1) {
                                                            await controller
                                                                .editMessage();
                                                          } else {
                                                            await controller
                                                                .sendMessage(
                                                                    content: controller
                                                                        .textMessageController
                                                                        .text,
                                                                    type: controller.isImageLink(controller
                                                                            .textMessageController
                                                                            .text)
                                                                        ? 2
                                                                        : controller.isLink(controller.textMessageController.text)
                                                                            ? 7
                                                                            : 1);
                                                          }
                                                        },
                                                        icon: Icon(
                                                          Icons.send_rounded,
                                                          size: 24,
                                                          color: Get.isDarkMode
                                                              ? Colors.white
                                                              : null,
                                                        ),
                                                      )
                                                    : IconButton(
                                                        onPressed: () async {
                                                          await controller
                                                              .startOrStopRecording();
                                                        },
                                                        icon: Icon(
                                                          controller.isRecording
                                                                  .value
                                                              ? Icons.stop
                                                              : Icons
                                                                  .mic_none_rounded,
                                                          color: Get.isDarkMode
                                                              ? Colors.white
                                                              : null,
                                                          size: 24,
                                                        ),
                                                      ),
                                              ]
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          _buildGetMediaIcon(),
                                        ],
                                      )
                                    ],
                                  )
                                ]
                              ],
                            ),
                          )),
                    ),
                  ),
                  Visibility(
                    visible: controller.isShowGroupInfo == true,
                    child: Expanded(
                        flex: 1,
                        child: ProfileChatDetail(
                          chatDetail: widget.chatDetail,
                        )),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildGetMediaIcon() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Color(0xff232323) : ColorValue.colorBrSearch,
          borderRadius: BorderRadius.circular(16),
        ),
        child: PopupMenuButton(
            offset: Offset(100, -150),
            icon: SvgPicture.asset(
              'asset/icons/file_picker.svg',
              color:
                  Get.isDarkMode ? ColorValue.white : ColorValue.neutralColor,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) {
              return [
                MyEntry(
                    icon: 'asset/icons/image.svg',
                    title: 'Photo',
                    onTap: () async {
                      await controller.getImageFiles(isCamera: false);
                    }),
                MyEntry(
                    icon: 'asset/icons/video_pick.svg',
                    title: 'Video',
                    onTap: () async {
                      await controller.getVideoFiles(isCamera: false);
                    }),
                MyEntry(
                    icon: 'asset/icons/file_picker.svg',
                    title: 'Document',
                    onTap: () async {
                      await controller.getFile();
                    }),
              ];
            }));
  }

  _chatItem(BuildContext context, {required int index}) {
    cd.ChatDetail message = controller.chatList[index];
    final bool isMe = message.userSent == controller.userName;

    cd.ChatDetail messageTime =
        controller.chatList[index - 1 == -1 ? index : index - 1];
    cd.ChatDetail messageTime2 = controller.chatList[index == 0
        ? controller.chatList.length == 1
            ? index
            : index + 1
        : index];
    cd.ChatDetail messageTime3 = controller
        .chatList[index == controller.chatList.length - 1 ? index : index + 1];

    DateFormat originalFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    final DateTime dt =
        originalFormat.parse(messageTime.timeCreated.toString(), true);
    final DateTime dt2 =
        originalFormat.parse(messageTime2.timeCreated.toString(), true);
    final DateTime dt3 =
        originalFormat.parse(messageTime3.timeCreated.toString(), true);
    final DateTime dtData = originalFormat
        .parse(controller.chatList[index].timeCreated.toString(), true)
        .toLocal();

    final bool isNewTime = dt3.isAfter(dt2.subtract(Duration(minutes: 20)));
    final bool isNewTime2 = dt2.isAfter(dt.subtract(Duration(minutes: 20)));

    final bool isSameUser =
        messageTime2.userSent == messageTime.userSent && isNewTime2;
    final bool isShowEnd = !isSameUser || index == 0;

    return Column(
      children: [
        Visibility(
          visible: !isNewTime,
          child: Center(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Color(0xff232323)
                    : Color.fromRGBO(240, 243, 251, 1),
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              DateFormat("HH:mm dd/MM").format(dt2.toLocal()),
              style: TextStyle(
                  color: Color.fromRGBO(146, 154, 169, 1),
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          )),
        ),
        Obx(() => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (controller.selectedItems.contains(message.uuid)) {
                  controller.selectedItems.remove(message.uuid);
                } else {
                  controller.selectedItems.add(message.uuid!);
                }
              },
              child: AbsorbPointer(
                absorbing: controller.isShowMultiselect.value,
                child: Row(
                  children: [
                    Visibility(
                      visible: controller.isShowMultiselect.value,
                      child: controller.selectedItems.contains(message.uuid)
                          ? Container(
                              height: 24,
                              width: 24,
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(controller.textColor)),
                              child: Center(
                                child: Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            )
                          : Container(
                              height: 24,
                              width: 24,
                              margin: EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(146, 154, 169, 1))),
                            ),
                    ),
                    if (isMe) ...[
                      Expanded(
                          child: Align(
                        alignment: Alignment.topRight,
                        child: _chatItemContent(context,
                            message: message,
                            isMe: isMe,
                            time: dtData,
                            isShowEnd: isShowEnd,
                            marginMessage:
                                messageTime2.userSent != messageTime.userSent
                                    ? 4
                                    : 0),
                      ))
                    ] else ...[
                      Expanded(
                          child: Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            isShowEnd
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(right: 6, bottom: 4),
                                    child: ClipOval(
                                      child: message.avatar != null &&
                                              message.avatar!.isNotEmpty
                                          ? Image.network(
                                              Constant.BASE_URL_IMAGE +
                                                  message.avatar!,
                                              key: UniqueKey(),
                                              width: 28,
                                              height: 28,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return SvgPicture.asset(
                                                  'asset/images/default.svg',
                                                  width: 28,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            )
                                          : Container(
                                              width: 28,
                                              height: 28,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: Utils
                                                      .getGradientForLetter(
                                                          controller.decodedName(
                                                              message.fullName ??
                                                                  message
                                                                      .userSent!))),
                                              child: Center(
                                                  child: Text(
                                                Utils.getInitialsName(controller
                                                        .decodedName(message
                                                                .fullName ??
                                                            message.userSent!))
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white),
                                                textAlign: TextAlign.center,
                                              )),
                                            ),
                                    ),
                                  )
                                : Container(
                                    width: 34,
                                    height: 32,
                                  ),
                            _chatItemContent(context,
                                message: message,
                                isMe: isMe,
                                time: dtData,
                                isNewTime: index == 0 &&
                                        messageTime.userSent !=
                                            messageTime3.userSent ||
                                    index == controller.chatList.length - 1 ||
                                    messageTime2.userSent !=
                                        messageTime3.userSent ||
                                    !isNewTime,
                                isShowEnd: isShowEnd,
                                marginMessage: messageTime2.userSent !=
                                        messageTime.userSent
                                    ? 4
                                    : 0)
                          ],
                        ),
                      ))
                    ]
                  ],
                ),
              ),
            ))
      ],
    );
  }

  _chatItemContent(BuildContext context,
      {required cd.ChatDetail message,
      required bool isMe,
      required DateTime time,
      bool isBottomSheet = false,
      bool isNewTime = false,
      bool? isShowEnd,
      double marginMessage = 0}) {
    String decoded = message.content ?? '';
    String decodedFullName = message.fullName ?? '';
    String? decodedForwardFrom = message.forwardFrom;

    try {
      decoded = utf8.decode(base64Url.decode(message.content!));
    } catch (e) {
      decoded = message.content ?? '';
    }

    try {
      decodedFullName = utf8.decode(base64Url.decode(message.fullName!));
    } catch (e) {
      decodedFullName = message.fullName ?? '';
    }

    try {
      decodedForwardFrom = utf8.decode(base64Url.decode(message.forwardFrom!));
    } catch (e) {
      decodedForwardFrom = message.forwardFrom;
    }

    Map<int, List<Emojis>> getListReaction = {};
    if (message.emojis != null && message.emojis!.isNotEmpty) {
      for (var item in message.emojis!) {
        if (getListReaction.isEmpty) {
          getListReaction.addEntries({
            item.id ?? 0: [item]
          }.entries);
        } else {
          if (getListReaction.containsKey(item.id)) {
            List<Emojis> list = getListReaction[item.id ?? 0] ?? [];
            list.add(item);
            getListReaction.update(item.id ?? 0, (value) => list);
          } else {
            getListReaction.addEntries({
              item.id ?? 0: [item]
            }.entries);
          }
        }
      }
    }

    return GestureDetector(
      onSecondaryTapDown: (details) {
        if (!isBottomSheet) {
          controller.focusNode.unfocus();
          controller.isShowEmoji.value = false;
          bottomSheetChatItem2(context,
              message: message, isMe: isMe, time: time);
        }
      },
      child: Stack(children: [
        Container(
          width: isBottomSheet ? double.infinity : null,
          constraints: isBottomSheet
              ? null
              : BoxConstraints(
                  maxWidth: size.width * 0.65,
                ),
          padding: EdgeInsets.symmetric(
              horizontal: message.contentType == 3 &&
                      (Utils.getFileType(Constant.BASE_URL_IMAGE +
                                  jsonDecode(decoded)[0]) ==
                              'Image' ||
                          Utils.getFileType(Constant.BASE_URL_IMAGE +
                                  jsonDecode(decoded)[0]) ==
                              'Video') &&
                      !(controller.chatType == 2 && !isMe && isNewTime)
                  ? 0
                  : (decoded.length < 4 && message.likeCount! > 0)
                      ? 16
                      : 6,
              vertical: message.contentType == 3 &&
                      (Utils.getFileType(Constant.BASE_URL_IMAGE +
                                  jsonDecode(decoded)[0]) ==
                              'Image' ||
                          Utils.getFileType(Constant.BASE_URL_IMAGE +
                                  jsonDecode(decoded)[0]) ==
                              'Video') &&
                      !(controller.chatType == 2 && !isMe && isNewTime)
                  ? 0
                  : 6),
          margin: EdgeInsets.only(
              top: 4, bottom: message.likeCount! > 0 ? 12 : marginMessage),
          decoration: message.contentType == 3 &&
                  (Utils.getFileType(Constant.BASE_URL_IMAGE +
                              jsonDecode(decoded)[0]) ==
                          'Image' ||
                      Utils.getFileType(Constant.BASE_URL_IMAGE +
                              jsonDecode(decoded)[0]) ==
                          'Video') &&
                  !(controller.chatType == 2 && !isMe && isNewTime)
              ? null
              : BoxDecoration(
                  color: isMe
                      ? Get.isDarkMode
                          ? Color.lerp(Color(controller.backgroundColor),
                              Colors.black, 0.2)
                          : Color(controller.backgroundColor)
                      : (Get.isDarkMode
                          ? Color.fromRGBO(31, 30, 30, 0.872)
                          : Color.fromRGBO(240, 243, 251, 1)),
                  borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.chatType == 2 && !isMe && isNewTime) ...[
                    Text(
                      '${decodedFullName}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: controller.sizeText.toDouble(),
                        color: Color(controller.textColor),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    )
                  ],
                  _chatContentType(
                      message: message,
                      time: time,
                      isBottomSheet: isBottomSheet,
                      isPaddingImage:
                          !(controller.chatType == 2 && !isMe && isNewTime))
                ],
              ),
              if (decodedForwardFrom != null) ...[
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${TextByNation.getStringByKey('forward_from')} ${decodedForwardFrom}',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: message.contentType == 3 &&
                              (Utils.getFileType(Constant.BASE_URL_IMAGE +
                                          jsonDecode(decoded)[0]) ==
                                      'Image' ||
                                  Utils.getFileType(Constant.BASE_URL_IMAGE +
                                          jsonDecode(decoded)[0]) ==
                                      'Video')
                          ? Colors.white60
                          : Get.isDarkMode
                              ? Colors.white60
                              : Colors.black54),
                )
              ],
              if (message.status == 2 ||
                  (isShowEnd != null && isShowEnd) &&
                      !(message.contentType == 3 &&
                          (Utils.getFileType(Constant.BASE_URL_IMAGE +
                                      jsonDecode(decoded)[0]) ==
                                  'Image' ||
                              Utils.getFileType(Constant.BASE_URL_IMAGE +
                                      jsonDecode(decoded)[0]) ==
                                  'Video'))) ...[
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${message.status == 2 ? TextByNation.getStringByKey('edited') : ''} ${DateFormat("HH:mm").format(time.toLocal())}',
                      style: TextStyle(
                          color: Get.isDarkMode
                              ? Colors.white70
                              : Color.fromRGBO(115, 121, 135, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 12),
                      textAlign: TextAlign.right,
                    ),
                    if (isMe) ...[
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        message.readState != 0
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 16,
                        color: Color(controller.textColor),
                      )
                    ]
                  ],
                )
              ]
            ],
          ),
        ),
        if (message.likeCount! > 0) ...[
          isMe
              ? Positioned(
                  left: 8,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 2),
                          //reaction
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              message.emojis != null &&
                                      message.emojis!.isNotEmpty
                                  ? isMe
                                      ? Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Color(
                                                  controller.backgroundColor),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        240, 243, 251, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.white)),

                                                ///column check
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(
                                                          getListReaction
                                                                      .length >
                                                                  3
                                                              ? 3
                                                              : getListReaction
                                                                  .length,
                                                          (index) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            // String uuidUser = await Utils
                                                            //     .getStringValueWithKey(
                                                            //     Constant.UUID_USER);
                                                            // controller.likeMessage(uuid: message.uuid!,
                                                            //     type: 0,
                                                            //     status: 0,
                                                            //     uuidUser: uuidUser);
                                                          },

                                                          ///column check
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                listReaction[
                                                                    getListReaction
                                                                            .keys
                                                                            .toList()[
                                                                        index]],
                                                                width: 14,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                              // Text('${e.value.length}',
                                                              //   style: const TextStyle(
                                                              //       fontSize: 10,
                                                              //       fontWeight: FontWeight.w400,
                                                              //       color: Colors.black),
                                                              // )
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    Text(
                                                      '${message.emojis!.length}',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '${message.status == 2 ? AppLocalizations.of(context)!.edited : ''} ${DateFormat("HH:mm").format(time.toLocal())}',
                                                style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? Colors.white70
                                                        : const Color.fromRGBO(
                                                            115, 121, 135, 1),
                                                    fontSize: 12),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        240, 243, 251, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.white)),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(
                                                        getListReaction.length >
                                                                3
                                                            ? 3
                                                            : getListReaction
                                                                .length,
                                                        (index) =>
                                                            GestureDetector(
                                                          onTap: () async {},
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                listReaction[
                                                                    getListReaction
                                                                            .keys
                                                                            .toList()[
                                                                        index]],
                                                                width: 14,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                              SizedBox(
                                                                  width: 3),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${message.emojis!.length}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              //time send
                                              Text(
                                                  '${message.status == 2 ? AppLocalizations.of(context)!.edited : ''} ${DateFormat("HH:mm").format(time.toLocal())}',
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Colors.white70
                                                          : const Color
                                                              .fromRGBO(
                                                              115, 121, 135, 1),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.right),
                                            ])
                                  :

                                  ///read message
                                  (isShowEnd != null && isShowEnd) &&
                                          !(message.contentType == 3)
                                      ? Container(
                                          padding: EdgeInsets.all(
                                              message.contentType == 6 ||
                                                      message.contentType == 8
                                                  ? 4
                                                  : 0),
                                          decoration: message.contentType ==
                                                      6 ||
                                                  message.contentType == 8
                                              ? BoxDecoration(
                                                  color: Color(controller
                                                      .backgroundColor),
                                                  borderRadius:
                                                      BorderRadius.circular(15))
                                              : null,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${message.status == 2 ? AppLocalizations.of(context)!.edited : ''} ${DateFormat("HH:mm").format(time.toLocal())}',
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? message.contentType ==
                                                                      6 ||
                                                                  message.contentType ==
                                                                      8
                                                              ? ColorValue
                                                                  .textColor
                                                              : Colors.white70
                                                          : const Color
                                                              .fromRGBO(
                                                              115, 121, 135, 1),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.right,
                                                ),
                                                if (isMe) ...[
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    message.readState != 0
                                                        ? Icons.done_all_rounded
                                                        : Icons.done_rounded,
                                                    size: 16,
                                                    color: Color(
                                                        controller.textColor),
                                                  )
                                                ]
                                              ]),
                                        )
                                      : const SizedBox()
                            ],
                          )
                        ]),
                  ),
                )
              : Positioned(
                  left: 8,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              message.emojis != null &&
                                      message.emojis!.isNotEmpty
                                  ? isMe
                                      ? Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Color(
                                                  controller.backgroundColor),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        240, 243, 251, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.white)),

                                                ///column check
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(
                                                          getListReaction
                                                                      .length >
                                                                  3
                                                              ? 3
                                                              : getListReaction
                                                                  .length,
                                                          (index) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            // String uuidUser = await Utils
                                                            //     .getStringValueWithKey(
                                                            //     Constant.UUID_USER);
                                                            // controller.likeMessage(uuid: message.uuid!,
                                                            //     type: 0,
                                                            //     status: 0,
                                                            //     uuidUser: uuidUser);
                                                          },

                                                          ///column check
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                listReaction[
                                                                    getListReaction
                                                                            .keys
                                                                            .toList()[
                                                                        index]],
                                                                width: 14,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                              // Text('${e.value.length}',
                                                              //   style: const TextStyle(
                                                              //       fontSize: 10,
                                                              //       fontWeight: FontWeight.w400,
                                                              //       color: Colors.black),
                                                              // )
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    Text(
                                                      '${message.emojis!.length}',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                '${message.status == 2 ? AppLocalizations.of(context)!.edited : ''} ${DateFormat("HH:mm").format(time.toLocal())}',
                                                style: TextStyle(
                                                    color: Get.isDarkMode
                                                        ? Colors.white70
                                                        : const Color.fromRGBO(
                                                            115, 121, 135, 1),
                                                    fontSize: 12),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(
                                                        240, 243, 251, 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: Colors.white)),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(
                                                        getListReaction.length >
                                                                3
                                                            ? 3
                                                            : getListReaction
                                                                .length,
                                                        (index) =>
                                                            GestureDetector(
                                                          onTap: () async {},
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                listReaction[
                                                                    getListReaction
                                                                            .keys
                                                                            .toList()[
                                                                        index]],
                                                                width: 14,
                                                                fit: BoxFit
                                                                    .fitWidth,
                                                              ),
                                                              SizedBox(
                                                                  width: 3),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${message.emojis!.length}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 2),
                                              //time send
                                              Text(
                                                  '${message.status == 2 ? AppLocalizations.of(context)!.edited : ''} ${DateFormat("HH:mm").format(time.toLocal())}',
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? Colors.white70
                                                          : const Color
                                                              .fromRGBO(
                                                              115, 121, 135, 1),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.right),
                                            ])
                                  :

                                  ///read message
                                  (isShowEnd != null && isShowEnd) &&
                                          !(message.contentType == 3)
                                      ? Container(
                                          padding: EdgeInsets.all(
                                              message.contentType == 6 ||
                                                      message.contentType == 8
                                                  ? 4
                                                  : 0),
                                          decoration: message.contentType ==
                                                      6 ||
                                                  message.contentType == 8
                                              ? BoxDecoration(
                                                  color: Color(controller
                                                      .backgroundColor),
                                                  borderRadius:
                                                      BorderRadius.circular(15))
                                              : null,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${message.status == 2 ? AppLocalizations.of(context)!.edited : ''} ${DateFormat("HH:mm").format(time.toLocal())}',
                                                  style: TextStyle(
                                                      color: Get.isDarkMode
                                                          ? message.contentType ==
                                                                      6 ||
                                                                  message.contentType ==
                                                                      8
                                                              ? ColorValue
                                                                  .textColor
                                                              : Colors.white70
                                                          : const Color
                                                              .fromRGBO(
                                                              115, 121, 135, 1),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.right,
                                                ),
                                                if (isMe) ...[
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    message.readState != 0
                                                        ? Icons.done_all_rounded
                                                        : Icons.done_rounded,
                                                    size: 16,
                                                    color: Color(
                                                        controller.textColor),
                                                  )
                                                ]
                                              ]),
                                        )
                                      : const SizedBox()
                            ],
                          )
                        ]),
                  ),
                ),
        ]
      ]),
    );
  }

  _chatContentType(
      {required cd.ChatDetail message,
      required DateTime time,
      bool reply = true,
      bool replyShow = false,
      int pinType = 0,
      bool isBottomSheet = false,
      bool isPaddingImage = false}) {
    if (!reply) {
      message = cd.ChatDetail(
          uuid: message.replyMsgUu!.uuid,
          userSent: message.replyMsgUu!.userSent,
          contentType: message.replyMsgUu!.contentType,
          content: message.replyMsgUu!.content,
          timeCreated: message.replyMsgUu!.timeCreated,
          status: message.replyMsgUu!.status,
          lastEdited: message.replyMsgUu!.lastEdited,
          msgRoomUuid: message.replyMsgUu!.msgRoomUuid,
          readState: message.replyMsgUu!.readState,
          likeCount: message.replyMsgUu!.likeCount,
          type: message.replyMsgUu!.type,
          avatar: message.replyMsgUu!.avatar,
          countryCode: message.replyMsgUu!.countryCode,
          fullName: message.replyMsgUu!.fullName,
          ownerUuid: message.replyMsgUu!.ownerUuid,
          roomName: message.replyMsgUu!.roomName);
    }
    final indexMessage = controller.chatList
        .indexWhere((element) => element.uuid! == message.uuid!);
    String decoded = message.content ?? '';

    try {
      decoded = utf8.decode(base64Url.decode(message.content!));
    } catch (e) {
      decoded = message.content ?? '';
    }
    String? decodedFullName;
    if (message.replyMsgUu != null && message.replyMsgUu!.fullName != null) {
      decodedFullName = message.replyMsgUu!.fullName;
      try {
        decodedFullName =
            utf8.decode(base64Url.decode(message.replyMsgUu!.fullName!));
      } catch (e) {
        decodedFullName = message.replyMsgUu!.fullName;
      }
    }

    if (message.contentType == 7) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleTapDetector(
            onTap: () async {
              await launchUrl(Uri.parse(controller.getLink('${decoded}')));
            },
            child: Container(
              width: Get.width * 0.22,
              child: Text(
                '${decoded}',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: controller.sizeText.toDouble(),
                    color: !reply && Get.isDarkMode ? Colors.black : null),
                maxLines: pinType == 1 ? 1 : null,
                overflow: pinType == 1 ? TextOverflow.ellipsis : null,
              ),
            ),
          ),
          if (pinType != 1) ...[
            SizedBox(
              height: 5,
            ),
            SingleTapDetector(
              onTap: () async {
                await launchUrl(Uri.parse(controller.getLink('${decoded}')));
              },
              child: Container(
                width: Get.width * 0.22,
                height: Get.height * 0.35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: controller.getLink('${decoded}'),
                  ),
                ),
              ),
            )
          ]
        ],
      );
    } else if (message.contentType == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse(controller.getLink('${decoded}')));
            },
            child: Container(
              width: Get.width * 0.22,
              child: Text(
                '${decoded}',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: controller.sizeText.toDouble(),
                    color: !reply && Get.isDarkMode ? Colors.black : null),
                maxLines: pinType == 1 ? 1 : null,
                overflow: pinType == 1 ? TextOverflow.ellipsis : null,
              ),
            ),
          ),
          if (pinType != 1) ...[
            SizedBox(
              height: 5,
            ),
            Container(
              width: Get.width * 0.22,
              child: AnyLinkPreview(
                key: ValueKey(message.uuid),
                onTap: () async {
                  await launchUrl(Uri.parse(controller.getLink('${decoded}')));
                },
                link: controller.getLink('${decoded}'),
                displayDirection: UIDirection.uiDirectionVertical,
                cache: Duration(hours: 2),
                backgroundColor: Colors.white,
                proxyUrl: 'https://cors-anywhere.herokuapp.com/',
                errorWidget: SizedBox(),
                titleStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                bodyStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            )
          ]
        ],
      );
    } else if (message.contentType == 3) {
      List<dynamic> array = jsonDecode(decoded);
      switch (Utils.getFileType(array[0])) {
        case 'Image':
          return pinType == 1
              ? Row(
                  children: [
                    Icon(Icons.image_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      message.content!,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: controller.sizeText.toDouble(),
                          color:
                              !reply && Get.isDarkMode ? Colors.black : null),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              : Container(
                  width: Get.width * 0.22,
                  padding: isBottomSheet
                      ? null
                      : (message.userSent == controller.userName
                          ? EdgeInsets.only(left: array.length <= 1 ? 90 : 0)
                          : EdgeInsets.only(
                              right: array.length <= 1
                                  ? isPaddingImage
                                      ? 90
                                      : 0
                                  : 0)),
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: StaggeredGrid.count(
                            crossAxisCount: array.length > 2
                                ? 3
                                : array.length > 1
                                    ? 2
                                    : 1,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            children: List.generate(array.length, (index) {
                              return StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: array.length <= 1
                                    ? 1.2
                                    : array.length <= 2
                                        ? 1.4
                                        : 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: _imageView(
                                      url: Constant.BASE_URL_IMAGE +
                                          array[index]),
                                ),
                              );
                            }),
                          )),
                      !reply
                          ? Container()
                          : Positioned(
                              right: 5,
                              bottom: 5,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      DateFormat("HH:mm")
                                          .format(time.toLocal()),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                    if (message.userSent ==
                                        controller.userName) ...[
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        message.readState != 0
                                            ? Icons.done_all_rounded
                                            : Icons.done_rounded,
                                        size: 16,
                                        color: Color(controller.textColor),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                );
        case 'Video':
          return pinType == 1
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_camera_back_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      TextByNation.getStringByKey('video'),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: controller.sizeText.toDouble(),
                          color:
                              !reply && Get.isDarkMode ? Colors.black : null),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              : Container(
                  width: Get.width * 0.22,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: array.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigation.navigateTo(
                              page: 'MediaChatDetail',
                              arguments:
                                  Constant.BASE_URL_IMAGE + array[index]);
                        },
                        child: Container(
                          height: Get.height * 0.3,
                          width: Get.width * 0.22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: GenThumbnailImage(
                                thumbnailRequest: ThumbnailRequest(
                                  video: Constant.BASE_URL_IMAGE + array[index],
                                  thumbnailPath: null,
                                  imageFormat: _format,
                                  maxHeight: (Get.height).toInt(),
                                  maxWidth: (Get.width).toInt(),
                                  timeMs: 1000,
                                  quality: _quality,
                                  attachHeaders: _attachHeaders,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
        default:
          return Container();
      }
    } else if (message.contentType == 4) {
      String type =
          Utils.getFileType(Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0]);
      switch (type) {
        case 'PDF':
        case 'Microsoft Word':
        case 'Microsoft Excel':
        case 'Microsoft PowerPoint':
        case 'Text':
        case 'ZIP':
        case 'RAR':
          return pinType == 1
              ? Row(
                  children: [
                    SvgPicture.asset(
                      'asset/icons/file.svg',
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      TextByNation.getStringByKey('file'),
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: controller.sizeText.toDouble(),
                          color:
                              !reply && Get.isDarkMode ? Colors.black : null),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              : GestureDetector(
                  onTap: () async {
                    await controller.saveFile(
                        url: Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0],
                        fileName: '${message.mediaName}');
                    print(
                        'urlpdf ${Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0]}');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Color(controller.textColor),
                            borderRadius: BorderRadius.circular(12)),
                        child: Icon(
                          Icons.download_outlined,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${message.mediaName}',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          if (controller.fileTrafficCache.containsKey(
                              Constant.BASE_URL_IMAGE +
                                  jsonDecode(decoded)[0])) ...[
                            Obx(() => Text(
                                  controller.isDownload ==
                                          '${TextByNation.getStringByKey('downloading')} ${Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0]}'
                                      ? '${controller.progress.value}% ${controller.isDownload.value.substring(0, controller.isDownload.value.indexOf(' ${Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0]}')).toLowerCase()}'
                                      : '${controller.fileTrafficCache[Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0]]} $type',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(controller.textColor),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ))
                          ] else ...[
                            FutureBuilder<String?>(
                              future: controller.fetchFileSize(
                                  Constant.BASE_URL_IMAGE +
                                      jsonDecode(decoded)[0]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  controller.fileTrafficCache[Constant
                                          .BASE_URL_IMAGE +
                                      jsonDecode(decoded)[0]] = snapshot.data!;
                                  return Obx(() => Text(
                                        controller.isDownload ==
                                                '${TextByNation.getStringByKey('downloading')} ${Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0]}'
                                            ? '${controller.progress.value}% ${controller.isDownload.value.substring(0, controller.isDownload.value.indexOf(' ${Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0]}')).toLowerCase()}'
                                            : '${snapshot.data!} $type',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Color(controller.textColor),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                } else {
                                  return Text(
                                    '0mb $type',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Color(controller.textColor),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }
                              },
                            )
                          ]
                        ],
                      ),
                    ],
                  ),
                );
        default:
          return Container();
      }
    } else if (message.contentType == 8) {
      return pinType == 1
          ? Row(
              children: [
                SvgPicture.asset('asset/icons/image.svg'),
                SizedBox(width: 5),
                Text(
                  'GIF',
                  style: TextStyle(
                      fontSize: controller.sizeText.toDouble(),
                      color: !reply && Get.isDarkMode ? Colors.black : null),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
          : showImage(
              url: decoded, width: Get.width * 0.15, height: Get.height * 0.28);
    } else if (message.contentType == 5) {
      return pinType == 1
          ? Row(
              children: [
                Icon(Icons.mic_none_rounded),
                SizedBox(
                  width: 5,
                ),
                Text(
                  TextByNation.getStringByKey('audio'),
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: controller.sizeText.toDouble(),
                      color: !reply && Get.isDarkMode ? Colors.black : null),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChatBubbleAudio(
                  key: ValueKey(message.uuid),
                  url: Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0],
                  index: message.uuid!,
                  width: isBottomSheet
                      ? size.width - 150
                      : !reply
                          ? (pinType == 2
                              ? (size.width * 0.65) - 210
                              : (size.width * 0.65) - 130)
                          : pinType == 2
                              ? (size.width * 0.65) - 190
                              : (size.width * 0.65) - 110,
                ),
                SizedBox(
                  height: 8,
                ),
                Visibility(
                  visible: controller.countryCode != message.countryCode,
                  child: GestureDetector(
                    onTap: () async {
                      await controller.speech2text
                          .getTextFromAudio(
                              Constant.BASE_URL_IMAGE + jsonDecode(decoded)[0],
                              message.countryCode!)
                          .then(
                        (value) async {
                          String data =
                              await controller.translator.translate(value);
                          if (indexMessage != -1) {
                            controller.chatList[indexMessage].translate = data;
                            controller.chatList.refresh();
                          }
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Color.fromRGBO(152, 152, 152, 1.0)
                              : Color.fromRGBO(228, 230, 236, 1),
                          borderRadius: BorderRadius.circular(6)),
                      child: Icon(Icons.translate_rounded, size: 13),
                    ),
                  ),
                ),
                if (message.translate.isNotEmpty) ...[
                  SizedBox(
                    height: 8,
                  ),
                  Text(message.translate,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: controller.sizeText.toDouble(),
                          color:
                              !reply && Get.isDarkMode ? Colors.black : null)),
                ]
              ],
            );
    } else if (message.contentType == 6) {
      var index = int.tryParse(decoded.split('_')[1]) ?? -1;
      var indexSticker = int.tryParse(decoded.split('_')[2]) ?? -1;
      String stickerString = (stickerPacks[index - 1]['stickers']
          as List)[indexSticker - 1]['image_file'];
      return pinType == 1
          ? Row(
              children: [
                SvgPicture.asset('asset/icons/image.svg'),
                SizedBox(width: 5),
                Text(
                  'Sticker',
                  style: TextStyle(
                      fontSize: controller.sizeText.toDouble(),
                      color: !reply && Get.isDarkMode ? Colors.black : null),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )
          : Image.asset(stickerString);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.replyMsgUu != null && reply && pinType != 1) ...[
          GestureDetector(
            onTap: () {
              int index = controller.chatList.indexWhere(
                  (element) => element.uuid! == message.replyMsgUu!.uuid!);
              index = index != -1 ? index : 0;
              controller.itemScrollController.scrollTo(
                  index: index, duration: Duration(seconds: 1), alignment: 0.5);
            },
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        left: BorderSide(
                            color: Color(controller.textColor), width: 2))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${decodedFullName ?? message.replyMsgUu!.userSent}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Color(controller.textColor),
                        fontFamily: 'NotoColorEmoji',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _chatContentType(
                        message: message,
                        time: time,
                        reply: false,
                        pinType: pinType == 2 ? 2 : 0)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
        Text(
          '${decoded}',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: controller.sizeText.toDouble(),
            color: !reply && Get.isDarkMode ? Colors.black : null,
            fontFamily: 'NotoColorEmoji',
          ),
          overflow: replyShow || pinType == 1 ? TextOverflow.ellipsis : null,
          maxLines: replyShow
              ? 4
              : pinType == 1
                  ? 1
                  : null,
        ),
        if (controller.countryCode != message.countryCode &&
            reply &&
            pinType != 1) ...[
          SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              String value = await controller.translator.translate(decoded);
              if (indexMessage != -1) {
                if (controller.chatList[indexMessage].translateOrigin.isEmpty) {
                  controller.chatList[indexMessage].translateOrigin = decoded;
                }
                controller.chatList[indexMessage].content =
                    controller.chatList[indexMessage].isTranslate
                        ? controller.chatList[indexMessage].translateOrigin
                        : value;
                controller.chatList[indexMessage].isTranslate =
                    !controller.chatList[indexMessage].isTranslate;
                controller.chatList.refresh();
              }
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Color.fromRGBO(152, 152, 152, 1.0)
                      : Color.fromRGBO(228, 230, 236, 1),
                  borderRadius: BorderRadius.circular(6)),
              child: Icon(Icons.translate_rounded, size: 13),
            ),
          )
        ],
      ],
    );
  }

  _imageView({required String url}) {
    return GestureDetector(
      onTap: () {
        Navigation.navigateTo(page: 'MediaChatDetail', arguments: url);
      },
      child: Image.network(
        url,
        key: UniqueKey(),
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
    );
  }

  // Widget _videoThumbnail(String videoUrl) {
  Widget _buildThumbnailImage(Uint8List thumbnailData) {
    return Stack(children: [
      Image.memory(
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

  // Future<Uint8List?> _generateThumbnail(String videoUrl) async {
  _timeVideo({required String url}) {
    if (controller.timeVideoCache.containsKey(url)) {
      // Sử dụng cache nếu có.
      return Text(
        '${controller.formatDuration(controller.timeVideoCache[url]!)}',
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
      );
    }
    return FutureBuilder<Duration>(
      future: controller.timePlayer(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          controller.timeVideoCache[url] = snapshot.data!;
          return Text(
            '${controller.formatDuration(snapshot.data!)}',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
          );
        } else {
          return Text(
            '00:00',
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
          );
        }
      },
    );
  }

  bottomSheetChatItem(
      {required cd.ChatDetail message,
      required bool isMe,
      required DateTime time}) {
    final indexMessage = controller.chatList
        .indexWhere((element) => element.uuid! == message.uuid!);
    String uuidChat = controller.chatList[indexMessage].uuid!;

    String decoded = message.content ?? '';

    try {
      decoded = utf8.decode(base64Url.decode(message.content!));
    } catch (e) {
      decoded = message.content ?? '';
    }

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
              _chatItemContent(
                context,
                message: message,
                isMe: isMe,
                time: time,
                isBottomSheet: true,
                isNewTime: true,
                isShowEnd: true,
              ),
              SizedBox(height: 17),
              // StaggeredGrid.count(
              //   crossAxisCount: controller.emojiList.length,
              //   crossAxisSpacing: 20,
              //   mainAxisSpacing: 20,
              //   children: List.generate(controller.emojiList.length, (index) {
              //     return StaggeredGridTile.count(
              //       crossAxisCellCount: 1,
              //       mainAxisCellCount: 1,
              //       child: GestureDetector(
              //         onTap: () {},
              //         child: Image.network(controller.emojiList[index].path!),
              //       ),
              //     );
              //   }),
              // ),
              GestureDetector(
                onTap: () {
                  // controller.likeMessage(uuid: message.uuid!, type: null);
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  'asset/icons/heart.svg',
                  width: 30,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: 17),
              StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: [
                  StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: _optionItem(
                        title: '${TextByNation.getStringByKey('reply')}',
                        svg: 'asset/icons/reply.svg',
                        onTap: () {
                          controller.replyChat.value = message;
                          controller.isEdit.value = 2;
                          Navigator.pop(context);
                        },
                      )),
                  StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: _optionItem(
                        title: '${TextByNation.getStringByKey('copy')}',
                        svg: 'asset/icons/copy.svg',
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: decoded));
                          Navigator.pop(context);
                        },
                      )),
                  StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: _optionItem(
                        title: '${TextByNation.getStringByKey('forward')}',
                        svg: 'asset/icons/forward.svg',
                        onTap: () async {
                          Navigator.pop(context);
                          if (Get.isRegistered<ChatController>()) {
                            if (controller.isAppResume) {
                              controller.isAppResume = false;
                              // await SocketManager().connect();
                            }
                            ChatController chat = Get.find<ChatController>();
                            chat.forward = message;
                            await Navigation.navigateTo(
                                page: 'Chat', arguments: message);
                            chat.forward = cd.ChatDetail();
                            chat.update();
                          }
                        },
                      )),
                  // StaggeredGridTile.fit(
                  //   crossAxisCellCount: 1,
                  //   child: _optionItem(
                  //     title: '${TextByNation.getStringByKey('recall')}',
                  //     icon: Icons.delete_sweep_outlined,
                  //     onTap: () async {
                  //       controller.selectedItems.add(controller.chatList[indexMessage].uuid!);
                  //       await controller.deleteMessage();
                  //       Navigator.pop(context);
                  //     },
                  //   )
                  // ),
                  if (isMe &&
                      (message.contentType == 1 || message.contentType == 2) &&
                      message.forwardFrom == null) ...[
                    StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: _optionItem(
                          title: '${TextByNation.getStringByKey('edit')}',
                          svg: 'asset/icons/edit.svg',
                          onTap: () {
                            controller.replyChat.value = message;
                            controller.isEdit.value = 1;
                            controller.textMessageController.text = decoded;
                            Navigator.pop(context);
                          },
                        ))
                  ],
                  StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: _optionItem(
                        title: '${TextByNation.getStringByKey('pin')}',
                        svg: 'asset/icons/pin.svg',
                        onTap: () async {
                          controller.selectedItems.add(uuidChat);
                          await controller.pinMessage(
                            state: 1,
                          );
                          Navigator.pop(context);
                        },
                      )),
                  StaggeredGridTile.fit(
                      crossAxisCellCount: 1,
                      child: _optionItem(
                        title:
                            '${TextByNation.getStringByKey('multiple_select')}',
                        svg: 'asset/icons/multiple_select.svg',
                        onTap: () {
                          controller.selectedItems.clear();
                          controller.selectedItems.add(message.uuid!);
                          controller.isShowMultiselect.value = true;
                          Navigator.pop(context);
                        },
                      )),
                  if (isMe)
                    StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: _optionItem(
                          title: '${TextByNation.getStringByKey('delete')}',
                          svg: 'asset/icons/delete.svg',
                          onTap: () async {
                            if (controller.isClickLoading) {
                              controller.isClickLoading = false;
                              controller.selectedItems.clear();
                              controller.selectedItems.add(uuidChat);
                              await controller.deleteMessage();
                              Navigator.pop(context);
                              controller.isClickLoading = true;
                            }
                          },
                        )),
                  if (message.contentType == 3)
                    StaggeredGridTile.fit(
                        crossAxisCellCount: 1,
                        child: _optionItem(
                          title: TextByNation.getStringByKey('download'),
                          icon: Icons.download_outlined,
                          onTap: () async {
                            List<dynamic> arrays = jsonDecode(decoded);
                            for (String array in arrays) {
                              await controller
                                  .saveImage(Constant.BASE_URL_IMAGE + array);
                            }
                            Navigator.pop(context);
                          },
                        )),
                ],
              ),
              SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  bottomSheetChatItem2(BuildContext context,
      {required cd.ChatDetail message,
      required bool isMe,
      required DateTime time}) {
    final indexMessage = controller.chatList
        .indexWhere((element) => element.uuid! == message.uuid!);
    String uuidChat = controller.chatList[indexMessage].uuid!;

    String decoded = message.content ?? '';

    try {
      decoded = utf8.decode(base64Url.decode(message.content!));
    } catch (e) {
      decoded = message.content ?? '';
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: SizedBox(
              width: Get.width * .7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                            listReaction.length,
                            (index) => GestureDetector(
                                  onTap: () async {
                                    String uuidUser =
                                        await Utils.getStringValueWithKey(
                                            Constant.UUID_USER);
                                    controller.likeMessage(
                                        uuid: message.uuid!,
                                        type: index,
                                        status: 1,
                                        uuidUser: uuidUser);
                                    Navigator.pop(context);
                                  },
                                  child: SvgPicture.asset(
                                    listReaction[index],
                                    width: 30,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ))),
                  ),
                  Divider(
                    height: 4,
                    color: Colors.transparent,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _customChildShowDialog('asset/icons/reply.svg',
                            AppLocalizations.of(context)!.reply, () {
                          controller.focusNode.requestFocus();
                          controller.replyChat.value = message;
                          controller.isEdit.value = 2;
                          Navigator.of(context).pop();
                        }),
                        if (message.contentType != 6)
                          _customChildShowDialog('asset/icons/copy.svg',
                              AppLocalizations.of(context)!.copy, () {
                            Clipboard.setData(ClipboardData(text: decoded));
                            Navigator.of(context).pop();
                          }),
                        _customChildShowDialog('asset/icons/forward.svg',
                            AppLocalizations.of(context)!.forward, () async {
                          Navigator.of(context).pop();
                          if (Get.isRegistered<ChatController>()) {
                            if (controller.isAppResume) {
                              controller.isAppResume = false;
                            }
                            ChatController chat = Get.find<ChatController>();
                            chat.forward = message;
                            // await Navigation.navigateTo(
                            //     page: RouterName.chat, arguments: message);
                            chat.forward = cd.ChatDetail();
                            chat.update();
                          }
                        }),
                        if (isMe &&
                            (message.contentType == 1 ||
                                message.contentType == 2) &&
                            message.forwardFrom == null)
                          _customChildShowDialog('asset/icons/edit.svg',
                              AppLocalizations.of(context)!.edit, () {
                            controller.focusNode.requestFocus();
                            controller.replyChat.value = message;
                            controller.isEdit.value = 1;
                            controller.textMessageController.text = decoded;
                            Navigator.of(context).pop();
                          }),
                        _customChildShowDialog(
                            !controller.pinList.value.contains(message)
                                ? 'asset/icons/pin.svg'
                                : 'asset/icons/un_pin.svg',
                            !controller.pinList.value.contains(message)
                                ? AppLocalizations.of(context)!.pin
                                : AppLocalizations.of(context)!.un_pin, () {
                          Navigator.of(context).pop();
                          controller.selectedItems.value.add(uuidChat);
                          controller.pinMessage(
                              state: !controller.pinList.value.contains(message)
                                  ? 1
                                  : 0);
                        }),
                        if (controller.chatList.value.length > 1)
                          _customChildShowDialog(
                              'asset/icons/multiple_select.svg',
                              AppLocalizations.of(context)!.multiple_select,
                              () async {
                            controller.selectedItems.clear();
                            controller.selectedItems.add(message.uuid!);
                            controller.isShowMultiselect.value = true;
                            Navigator.of(context).pop();
                          }),
                        if (isMe)
                          _customChildShowDialog('asset/icons/delete.svg',
                              AppLocalizations.of(context)!.delete, () {
                            Navigator.pop(context);
                            UtilsWidget.showDialogCustomInChatScreen(
                                controller.isDeleteOwnOrMulti,
                                AppLocalizations.of(context)!.delete_message,
                                AppLocalizations.of(context)!.delete_message,
                                AppLocalizations.of(context)!
                                    .delete_group_confirm,
                                (value) => controller.isDeleteOwnOrMulti.value =
                                    !controller.isDeleteOwnOrMulti.value, () {
                              if (controller.isClickLoading) {
                                controller.isClickLoading = false;
                                controller.selectedItems.value.clear();
                                controller.selectedItems.value.add(uuidChat);
                                controller.deleteMessage();
                                Navigator.of(context).pop();
                                controller.isClickLoading = true;
                              }
                            }, isDelete: true);
                          }),
                        if (roleId == 1 && !isMe)
                          _customChildShowDialog('asset/icons/copy.svg',
                              AppLocalizations.of(context)!.lock_account,
                              () async {
                            Navigator.pop(context);
                            UtilsWidget.showModalBottomSheetCustom([
                              SizedBox(height: 14),
                              Text(AppLocalizations.of(context)!.lock_account,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      height: 28 / 20,
                                      color: ColorValue.neutralColor)),
                              SizedBox(height: 4),
                              Text(
                                // TextByNation.getStringByKey(KeyByNation
                                //     .choose_one_of_the_reasons_below),

                                AppLocalizations.of(context)!.choose_mode,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 24 / 14,
                                    color: ColorValue.neutralColor),
                              ),
                              SizedBox(height: 14),
                              UtilsWidget.itemShowBlockPopup(
                                  // TextByNation.getStringByKey(
                                  //     KeyByNation.lock_message),
                                  AppLocalizations.of(context)!.delete_message,
                                  // TextByNation.getStringByKey(KeyByNation
                                  //     .block_this_account_messages_in_the_group),
                                  AppLocalizations.of(context)!.delete_message,
                                  () {
                                controller.blockMember(
                                    13,
                                    message.msgRoomUuid ?? '',
                                    message.userSent ?? '');
                              }),
                              SizedBox(height: 14),
                              UtilsWidget.itemShowBlockPopup(
                                  // TextByNation.getStringByKey(
                                  //     KeyByNation.lock_and_delete_messages),
                                  AppLocalizations.of(context)!.delete_message,

                                  // TextByNation.getStringByKey(KeyByNation
                                  //     .block_and_delete_this_account_messages_in_the_group),
                                  AppLocalizations.of(context)!
                                      .delete_group_confirm, () {
                                Navigator.pop(Get.context!);
                                UtilsWidget.showDialogCustomInChatScreen(
                                    controller.isBlockMemberCheck,
                                    // TextByNation.getStringByKey(
                                    //     KeyByNation.lock_message),
                                    AppLocalizations.of(context)!
                                        .delete_group_confirm,

                                    // TextByNation.getStringByKey(KeyByNation
                                    //     .block_and_delete_this_account_messages_in_the_group),
                                    AppLocalizations.of(context)!.delete_chat,

                                    // TextByNation.getStringByKey(
                                    //     KeyByNation.remove_account_from_group),
                                    AppLocalizations.of(context)!
                                        .delete_group_confirm, (p0) {
                                  controller.isBlockMemberCheck.value =
                                      !controller.isBlockMemberCheck.value;
                                }, () {
                                  controller.blockMember(
                                      16,
                                      message.msgRoomUuid ?? '',
                                      message.userSent ?? '');
                                }, isLock: true);
                              }),
                            ]);
                          }, isMore: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _customChildShowDialog(String icon, String title, VoidCallback? onTap,
      {bool? isMore = false}) {
    return InkWell(
      onTap: onTap,
      splashFactory: NoSplash.splashFactory,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              SvgPicture.asset(icon),
              SizedBox(width: 12),
              Text(title),
            ]),
            isMore == true
                ? Icon(Icons.arrow_forward_ios_outlined, size: 20)
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  _optionItem(
      {required GestureTapCallback onTap,
      IconData? icon,
      String? svg,
      required String title}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Color(0xff232323)
                : Color.fromRGBO(240, 243, 251, 1),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            icon != null
                ? Icon(
                    icon,
                    size: 22,
                  )
                : SvgPicture.asset(
                    svg!,
                    color: Get.isDarkMode ? Colors.white : null,
                  ),
            SizedBox(
              height: 6,
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }

  _dialogPin() {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Obx(() => Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        TextByNation.getStringByKey('pin_list'),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(Get.context!);
                          },
                          icon: Icon(Icons.close_rounded))
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: size.height * 0.5,
                    ),
                    child: ListView.separated(
                      itemCount: controller.pinList.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 4,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Color(0xff232323)
                                  : Color.fromRGBO(240, 243, 251, 1),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Color(controller.textColor)),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _chatContentType(
                                        message: controller.pinList[index],
                                        time:
                                            DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                                                .parse(
                                                    controller.pinList[index]
                                                        .timeCreated
                                                        .toString(),
                                                    true)
                                                .toLocal(),
                                        pinType: 2),
                                    SizedBox(height: 5),
                                    Text(
                                      '${TextByNation.getStringByKey('by')} ${controller.pinList[index].fullName}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  controller.selectedItems
                                      .add(controller.pinList[index].uuid!);
                                  await controller.pinMessage(
                                    state: 0,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(152, 152, 152, 1.0)
                                          : Color.fromRGBO(228, 230, 236, 1),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'asset/icons/un_pin.svg',
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                      // SizedBox(width: 8),
                                      // Text(
                                      //   'Unpin',
                                      //   style: TextStyle(
                                      //       fontWeight: FontWeight.w400,
                                      //       fontSize: 16),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          )),
    );
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

  Widget showImage(
      {required String url,
      double? height,
      double? width,
      BoxFit? fit,
      Widget? errorWidget}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      cacheKey: url,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) {
        return errorWidget ??
            SvgPicture.asset(
              'asset/images/default.svg',
              key: UniqueKey(),
              fit: BoxFit.cover,
              width: width,
              height: height,
            );
      },
    );
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    super.dispose();
  }
}
