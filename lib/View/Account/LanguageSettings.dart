import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Utils.dart';

import '../../Controller/Account/LanguageSettingsController.dart';
import '../../Global/ColorValue.dart';

class LanguageSettings extends StatelessWidget {
  var delete = Get.delete<LanguageSettingsController>();
  LanguageSettingsController controller = Get.put(LanguageSettingsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => (Scaffold(
          appBar: appBar(),
          body: body(context),
        )));
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
        child: Container(
      color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      width: Get.width,
      height: Get.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3,
            color: Get.isDarkMode
                ? ColorValue.colorTextDark
                : ColorValue.colorBrCmr,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      TextByNation.getStringByKey('translate_mesages'),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : ColorValue.neutralColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                flagSize: 25,
                                // backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                    fontSize: 14, color: Colors.blueGrey),
                                // bottomSheetHeight:
                                //     500, // Optional. Country list modal height
                                //Optional. Sets the border radius for the bottomsheet.
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                                //Optional. Styles the search field.
                                inputDecoration: InputDecoration(
                                  hintStyle: TextStyle(fontSize: 14),
                                  contentPadding: EdgeInsets.all(0),
                                  labelText:
                                      TextByNation.getStringByKey('search'),
                                  hintText: TextByNation.getStringByKey(
                                      'search_nation'),
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                              onSelect: (Country country) async {
                                await Utils.saveStringWithKey(
                                    Constant.LANGUAGE_TRANSLATE_NAME,
                                    country.name);
                                await Utils.saveStringWithKey(
                                    Constant.LANGUAGE_TRANSLATE_CODE,
                                    LanguageSettingsController
                                            .countryTranslations[
                                        country.countryCode.toString()]!);

                                controller.selectTranslateName.value =
                                    country.name;
                                Utils.setTranslate();
                              });
                        },
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                controller.selectTranslateName.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorValue.colorPrimary),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 20,
                              color: ColorValue.colorBorder,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  width: 212,
                  child: Text(
                    TextByNation.getStringByKey('translate_content'),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12,
                        color: Get.isDarkMode
                            ? ColorValue.colorBorder.withOpacity(0.5)
                            : ColorValue.colorBorder),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 3,
            color: Get.isDarkMode
                ? ColorValue.colorTextDark
                : ColorValue.colorBrCmr,
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              TextByNation.getStringByKey('laguage_systems').toUpperCase(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorValue.colorBorder),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Column(
              children: List.generate(controller.listNation.length, (index) {
            return buildLanguageItem(index);
          })),
        ],
      ),
    ));
  }

  InkWell buildLanguageItem(int index) {
    return InkWell(
      onTap: () async {
        controller.selectLanguuage.value = index;
        if (index == 0) {
          TextByNation.nationCode.value = 'en';
          Utils.saveStringWithKey(Constant.LANGUAGE_SYSTEM_INDEX, 'en');
          Get.updateLocale(const Locale('en'));
        } else if (index == 1) {
          TextByNation.nationCode.value = 'vi';
          Utils.saveStringWithKey(Constant.LANGUAGE_SYSTEM_INDEX, 'vi');
          Get.updateLocale(const Locale('vi'));
        } else {
          TextByNation.nationCode.value = 'zh';
          Utils.saveStringWithKey(Constant.LANGUAGE_SYSTEM_INDEX, 'zh');
          Get.updateLocale(const Locale('zh'));
        }
        Utils.setTranslate();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Get.isDarkMode
                  ? ColorValue.colorTextDark
                  : ColorValue.colorBrCmr, // Màu của đường viền dưới cùng
              width: 1.0, // Độ dày của đường viền
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                controller.listNation[index].src!,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                controller.listNation[index].title!,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Get.isDarkMode
                        ? ColorValue.colorTextDark
                        : ColorValue.neutralColor),
              ),
              Spacer(),
              controller.selectLanguuage.value == index
                  ? Icon(
                      Icons.check,
                      size: 24,
                      color: ColorValue.colorPrimary,
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text(TextByNation.getStringByKey('language'),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          )),
    );
  }

  void showChooseLanguage(BuildContext context) {
    showModalBottomSheet(
        backgroundColor:
            Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Obx(() => (
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          height: 4,
                          width: 32,
                          decoration: BoxDecoration(
                              color: ColorValue.colorPlaceholder,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            TextByNation.getStringByKey('language_translate'),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.neutralColor),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.close(1);
                            },
                            child: Icon(Icons.close,
                                size: 24,
                                color: Get.isDarkMode
                                    ? ColorValue.colorTextDark
                                    : ColorValue.neutralColor),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        TextByNation.getStringByKey('translate_content'),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: ColorValue.colorBorder),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                        children: List.generate(controller.listNation.length,
                            (index) {
                      return buildTranslateItem(index);
                    })),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )));
        });
  }

  InkWell buildTranslateItem(int index) {
    return InkWell(
      onTap: () {
        controller.selectTranslationLanguage.value = index;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Ink(
          // padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Get.isDarkMode
                    ? ColorValue.colorTextDark
                    : ColorValue.colorBrCmr, // Màu của đường viền dưới cùng
                width: 1.0, // Độ dày của đường viền
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Row(
              children: [
                Text(
                  controller.listNation[index].title!,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: controller.selectTranslationLanguage.value == index
                          ? ColorValue.colorPrimary
                          : Get.isDarkMode
                              ? ColorValue.colorTextDark
                              : ColorValue.neutralColor
                  ),
                ),
                Spacer(),
                controller.selectTranslationLanguage.value == index
                    ? Icon(
                        Icons.check,
                        size: 24,
                        color: ColorValue.colorPrimary,
                      )
                    : SizedBox(
                        height: 24,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
