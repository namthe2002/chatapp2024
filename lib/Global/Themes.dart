import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live_yoko/Global/ColorValue.dart';

final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    bottomAppBarTheme: BottomAppBarTheme(color: Colors.white),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all(Color(0xfff3f4f8)),
      // thumbColor: MaterialStateProperty.all(ColorValue.bt_default),
    ),
    appBarTheme: AppBarTheme(
      titleSpacing: 0,
      titleTextStyle: TextStyle(
          fontSize: 20.sp, fontWeight: FontWeight.w500, color: Colors.black),
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ));

final ThemeData darkTheme = ThemeData(
    // scaffoldBackgroundColor: ColorValue.drank_br,
    // primaryColor: ColorValue.dark_cl,
    brightness: Brightness.dark,
    // bottomAppBarTheme: BottomAppBarTheme(color: ColorValue.dark_cl),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.all(Color(0xfff3f4f8)),
      // thumbColor: MaterialStateProperty.all(ColorValue.bt_default),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorValue.colorAppBar,
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleSpacing: 0,
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        // color: ColorValue.n1_title_br
      ),
      // color: ColorValue.dark_cl,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ));
