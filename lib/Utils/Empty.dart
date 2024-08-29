import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_yoko/Global/ColorValue.dart';

class Empty extends StatelessWidget {
  const Empty({
    Key? key,
    required this.title,
    required this.imgSrc,
    required this.content,
  }) : super(key: key);

  final String title, imgSrc, content;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imgSrc,
          width: 120.w,
          height: 120.h,
          fit: BoxFit.fill,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
