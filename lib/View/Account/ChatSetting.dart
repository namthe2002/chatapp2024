import 'package:bottom_bar_matu/utils/app_utils.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Utils.dart' as Ut;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/ChatSettingController.dart';
import 'package:live_yoko/Global/ColorValue.dart';

class ChatSetting extends StatelessWidget {
  var delete = Get.delete<ChatSettingController>();
  ChatSettingController controller = Get.put(ChatSettingController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(),
          body: body(),
        )));
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(TextByNation.getStringByKey('chat_setting'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          )),
    );
  }

  SafeArea body() {
    return SafeArea(
        child: Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
        border: Border(
          // Thiết lập viền trên
          top: BorderSide(
              width: 1.0, color: ColorValue.colorBrCmr), // Thiết lập viền dưới
          // Thiết lập các viền khác nếu cần
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TextByNation.getStringByKey('prieview').toUpperCase(),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorValue.colorBorder),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: ColorValue.colorBrCmr,
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 16, top: 16, bottom: 12),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Color.fromRGBO(117, 117, 117, 1.0)
                                : ColorValue.colorBrSearch,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Chatapp.work@gmail.com',
                                style: TextStyle(
                                    fontSize:
                                        controller.currentSliderValue.value.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Get.isDarkMode
                                        ? Colors.white70
                                        : ColorValue.neutralColor),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.end, // Chỉnh sửa ở đây
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '9:12',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Get.isDarkMode
                                            ? Colors.white70
                                            : null),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.done_all_outlined,
                                    size: 14,
                                    color: ColorValue.colorPrimary,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 15,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: Get.width * 0.7),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Color.lerp(
                                      Color(controller
                                          .listThemeColor[
                                              controller.selectColor.value]
                                          .colorBackgr
                                          .toInt()),
                                      Colors.black,
                                      0.2)
                                  : Color(controller
                                      .listThemeColor[
                                          controller.selectColor.value]
                                      .colorBackgr
                                      .toInt()),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('https://chatapp.pro.vn',
                                    style: TextStyle(
                                      fontSize: controller
                                          .currentSliderValue.value.sp,
                                      fontWeight: FontWeight.w400,
                                    )),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            left: BorderSide(
                                                width: 2,
                                                color: Color(controller
                                                    .listThemeColor[controller
                                                        .selectColor.value]
                                                    .colorText
                                                    .toInt())))),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Admin',
                                            style: TextStyle(
                                                fontSize: controller
                                                    .currentSliderValue
                                                    .value
                                                    .sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color(controller
                                                    .listThemeColor[controller
                                                        .selectColor.value]
                                                    .colorText
                                                    .toInt())),
                                          ),
                                          Text(
                                            'Mobiplus provide the service for website and mobile app that ensure friendliness.',
                                            style: TextStyle(
                                                fontSize: controller
                                                    .currentSliderValue
                                                    .value
                                                    .sp,
                                                fontWeight: FontWeight.w400,
                                                color: ColorValue.textColor),
                                          )
                                        ],
                                      ),
                                    )),
                                SizedBox(
                                  height: 6,
                                ),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      '10:00',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    TextByNation.getStringByKey('mesage_text_size'),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 215, 216, 219)
                            : ColorValue.neutralColor),
                  ),
                  Spacer(),
                  Text(
                    controller.currentSliderValue.toInt().toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Get.isDarkMode
                            ? const Color.fromARGB(255, 215, 216, 219)
                            : ColorValue.neutralColor),
                  )
                ],
              ),
              Slider(
                activeColor:
                    ColorValue.colorPrimary, // Màu khi slider đang hoạt động
                inactiveColor:
                    Color(0xffC1D4E5), // Màu khi slider không hoạt động
                min: 12.0,
                value: controller.currentSliderValue.value,
                max: 20.0,
                divisions: 4,
                label: controller.currentSliderValue.value.round().toString(),
                onChanged: (double value) async {
                  controller.currentSliderValue.value = value;
                  await Ut.Utils.saveIntWithKey(
                      Constant.SIZE_TEXT, value.toInt());
                },
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                TextByNation.getStringByKey('color_theme'),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: ColorValue.neutralColor),
              ),
              SizedBox(
                height: 12,
              ),
              StaggeredGrid.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children:
                    List.generate(controller.listThemeColor.length, (index) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () async {
                        controller.selectColor.value = index;
                        await Ut.Utils.saveStringWithKey(Constant.BR_COLOR,
                            controller.listThemeColor[index].colorBackgr!);
                        await Ut.Utils.saveStringWithKey(Constant.TEXT_COLOR,
                            (controller.listThemeColor[index].colorText!));
                        await Ut.Utils.saveIntWithKey(
                            Constant.SELECT_COLOR, index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Color.lerp(
                                    Color(controller
                                        .listThemeColor[index].colorBackgr!
                                        .toInt()),
                                    Colors.black,
                                    0.2)
                                : Color(controller
                                    .listThemeColor[index].colorBackgr!
                                    .toInt()),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                width: 1.5,
                                color: Color(controller
                                    .listThemeColor[index].colorBorder!
                                    .toInt()))),
                        child: Center(
                            child: controller.selectColor.value == index
                                ? Icon(
                                    Icons.check_circle_sharp,
                                    size: 32,
                                    color: ColorValue.colorPrimary,
                                  )
                                : SizedBox(
                                    height: 32,
                                    width: 32,
                                  )),
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
