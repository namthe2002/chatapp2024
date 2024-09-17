import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButtonCustom extends StatelessWidget {
  const IconButtonCustom(
      {super.key, required this.icon, required this.onTap, this.color});
  final String icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        icon,
        color: color,
      ),
    );
  }
}
