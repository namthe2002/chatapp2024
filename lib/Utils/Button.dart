import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final VoidCallback? onPressed;
  final Widget child;
  final MaterialStateProperty<Color?>? backgroundColor;

  const MyElevatedButton(
      {Key? key,
      required this.onPressed,
      required this.child,
      this.borderRadius,
      this.width,
      this.height,
      this.gradient,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        // style: ElevatedButton.styleFrom(
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        //   shadowColor: Colors.transparent,
        //   shape: RoundedRectangleBorder(borderRadius: borderRadius),
        // ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90).r,
            ),
          ),
          backgroundColor: backgroundColor,
          padding: MaterialStateProperty.all(EdgeInsets.all(14)),
        ),
        child: child,
      ),
    );
  }
}
