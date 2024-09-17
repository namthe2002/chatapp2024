import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppTextStyle {
  static TextStyle regular(
      {required double? size,
        FontWeight? fontWeight,
        Color? color,
        TextOverflow? overflow,
        double lineHeight = 16,
        FontStyle? fontStyle}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = (lineHeight).sp / size;
    }
    return Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
        fontSize: size,
        fontWeight: fontWeight,
        color: color,
        height: height,
        overflow: overflow,
        fontStyle: fontStyle);
  }

  static TextStyle regularW400(
      {required double? size,
        FontStyle? fontStyle,
        Color? color,
        double lineHeight = 16}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = (lineHeight).sp / size;
    }
    return Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
      fontStyle: fontStyle,
    );
  }

  static TextStyle regularW500(
      {required double? size,
        FontStyle? fontStyle,
        Color? color,
        double lineHeight = 16}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = (lineHeight).sp / size;
    }
    return Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
      fontStyle: fontStyle,
    );
  }

  static TextStyle regularW600(
      {required double? size,
        FontStyle? fontStyle,
        Color? color,
        double lineHeight = 16}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = (lineHeight).sp / size;
    }
    return Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
      fontStyle: fontStyle,
    );
  }

  static TextStyle regularW700(
      {required double? size,
        FontStyle? fontStyle,
        Color? color,
        double lineHeight = 16}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = (lineHeight).sp / size;
    }
    return Theme.of(Get.context!).textTheme.titleMedium!.copyWith(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      height: height,
      fontStyle: fontStyle,
    );
  }
}
