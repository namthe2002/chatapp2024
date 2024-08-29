import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/SplashController.dart';

class Splash extends StatelessWidget {
  // final delete = Get.delete<SplashController>();
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SvgPicture.asset('asset/images/logo.svg'),
          ),
        ),
      ),
    );
  }
}
