import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Global/ColorValue.dart';
import '../main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UtilsWidget {
  static showModalBottomSheetCustom(List<Widget> widgets) {
    return showModalBottomSheet(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(15))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: ColorValue.colorPlaceholder),
              ),
            ),
            ...List.generate(widgets.length, (index) => widgets[index])
          ]),
        );
      },
    );
  }

  static showDialogCustomInChatScreen(
    RxBool isCheck,
    String title,
    String description,
    String option,
    Function(bool?)? onChange,
    VoidCallback onTap, {
    bool? isLock = false,
    bool? isLockProfile = false,
    bool? isUnLock = false,
    bool? isDelete = false,
    bool? isHiddenCheckbox = false,
    bool? isDeleteChat = false,
    bool? isClear = false,
    bool? isLeave = false,
    bool? isRemoveRole = false,
  }) {
    return showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(32),
              // insetPadding: const EdgeInsets.all(20),
              content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, height: 32 / 24, color: ColorValue.neutralColor)),
                isLock == true
                    ? Obx(() => isCheck.value == false
                        ? SizedBox(height: 48)
                        : Text(description,
                            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, height: 24 / 14, color: ColorValue.textColor)))
                    : Text(description, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, height: 24 / 14, color: ColorValue.textColor)),
                if (isHiddenCheckbox == false) ...[
                  SizedBox(height: 25,),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                            value: isCheck.value,
                            checkColor: Colors.white,
                            onChanged: onChange,
                            activeColor: ColorValue.colorPrimary,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: ColorValue.colorBorder, width: 2), borderRadius: BorderRadius.circular(4)),
                          )),
                      Text(option, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, height: 22 / 14, color: ColorValue.neutralColor)),
                    ],
                  ),
                ],
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: _button(() {
                      Navigator.pop(context);
                    }, context, isCancel: true)),

                    _button(onTap, context,
                        isDelete: isDelete,
                        isLock: isLock,
                        isUnLock: isUnLock,
                        isClear: isClear,
                        isDeleteChat: isDeleteChat,
                        isLeave: isLeave,
                        isLockProfile: isLockProfile,
                        isRemoveRole: isRemoveRole)
                  ],
                ),
              ]),
            ));
  }

  static _button(
    VoidCallback onTap,
    BuildContext context, {
    bool? isDelete = false,
    bool? isLock = false,
    bool? isUnLock = false,
    bool? isCancel = false,
    bool? isDeleteChat = false,
    bool? isClear = false,
    bool? isLeave = false,
    bool? isLockProfile = false,
    bool? isRemoveRole = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
          (isDelete == true || isDeleteChat == true
                  ? AppLocalizations.of(context)!.delete
                  : isLock == true
                      ? AppLocalizations.of(context)!.lock_account
                      : isUnLock == true
                          ? AppLocalizations.of(context)!.unlock_account
                          : isClear == true
                              ? AppLocalizations.of(context)!.clear
                              : isLeave == true
                                  ? AppLocalizations.of(context)!.leave_group
                                  : isLockProfile == true
                                      ? AppLocalizations.of(context)!.lock_account
                                      : isRemoveRole == true
                                          ? AppLocalizations.of(context)!.delete_chat
                                          : AppLocalizations.of(context)!.cancel)
              .toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 24 / 16,
              color: (isDelete == true || isLock == true || isLockProfile == true || isRemoveRole == true)
                  ? ColorValue.neutralLineIcon
                  : isUnLock == true
                      ? ColorValue.colorPrimary
                      : isDeleteChat == true || isClear == true || isLeave == true
                          ? ColorValue.colorPrimary
                          : ColorValue.textColor)),
    );
  }

  static itemShowBlockPopup(String title, String content, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Text(title, style: TextStyle(fontSize: 14, height: 24 / 14, color: ColorValue.neutralColor, fontWeight: FontWeight.w400)),
        SizedBox(height: 4),
        Text(content, style: TextStyle(fontSize: 12, height: 16 / 12, color: ColorValue.colorBorder, fontWeight: FontWeight.w400)),
      ]),
    );
  }
}
