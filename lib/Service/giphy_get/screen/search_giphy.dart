import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../Controller/Chat/ChatDetailController.dart';

class SearchAppBar extends StatefulWidget {
  // Scroll Controller
  final ChatDetailController chatDetailController;
  final ScrollController scrollController;
  final TextEditingController textEditingController;
  SearchAppBar({
    Key? key,
    required this.chatDetailController,
    required this.textEditingController,
    required this.scrollController,
  }) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  // Input Focus
  final FocusNode _focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
      child: _searchWidget(),
    );
  }

  Widget _searchWidget() {
    return Column(
      children: [
        SizedBox(
          height: 40.h,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: widget.textEditingController,
                onTap: () {
                  if (!widget.chatDetailController.isExtendShowEmoji.value) {
                    widget.chatDetailController.isExtendShowEmoji = true.obs;
                    // widget.chatDetailController.tabHeight =
                    //     (Get.height * .796).obs;
                  }
                },
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _searchIcon(),
                  ),
                  hintText:
                      // TextByNation.getStringByKey(KeyByNation.search_GIPHY),


                  'Search GIPHY',
                  suffixIcon: IconButton(
                      icon: SvgPicture.asset('asset/icons/close.svg',
                          color: Colors.black),
                      onPressed: () {
                        setState(() {
                          widget.textEditingController.clear();
                        });
                      }),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                autocorrect: false,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchIcon() {
    if (kIsWeb) {
      return SvgPicture.asset(
        'asset/icons/search.svg',
      );
    } else {
      return ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFFF6666),
            Color(0xFF9933FF),
          ],
        ).createShader(bounds),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(pi),
          child: SvgPicture.asset('asset/icons/search.svg',),
        ),
      );
    }
  }
}
