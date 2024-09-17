import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:live_yoko/widget/single_tap_detector.dart';

import '../Global/ColorValue.dart';

class MyEntry<T> extends StatefulWidget implements PopupMenuEntry<T> {
  MyEntry(
      {super.key,
       this.icon,
       this.title,
       this.onTap,
      this.value, this.widgetCustom});

  final String? icon;
  final String? title;
  final VoidCallback? onTap;
  final T? value;
  final Widget? widgetCustom;

  @override
  State<MyEntry> createState() => _MyEntryState();

  @override
  double get height => 36;

  @override
  bool represents(value) => value != null;
}

class _MyEntryState extends State<MyEntry> {
  @override
  Widget build(BuildContext context) {
    return widget.widgetCustom != null ? widget.widgetCustom! :  Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: SingleTapDetector(
        onTap: () {
          Navigator.of(context).pop(widget.value);
          widget.onTap?.call();
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          margin: EdgeInsets.symmetric(vertical: 2),
          height: widget.height,
          child: Row(
            children: [
              SvgPicture.asset(widget.icon ?? 'asset/images/default.svg',
              color:
                  Get.isDarkMode ? ColorValue.white : ColorValue.neutralColor,),
              SizedBox(width: 12),
              Text(widget.title ?? 'My entry',
                  style: TextStyle(
                    fontSize: 14,
                    height: 24 / 14,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
