import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Global/ColorValue.dart';
import '../core/image/Images.dart';
import 'enum.dart';
import 'logger.dart';
import 'utils.dart';

mixin Validators {
  static final RegExp rtrwRegex = RegExp(r'[0-9/]');
  static final RegExp numberRegex = RegExp(r'[0-9]');
  static final RegExp digitRegex = RegExp(r'[a-zA-Z]');
  static final RegExp upperRegex = RegExp(r'[A-Z]');
  static final RegExp lowerRegex = RegExp(r'[a-z]');
  static final RegExp nameRegex = RegExp("[a-z A-Z á-ú Á-Ú]");
  static final RegExp alphanumericRegex = RegExp("[a-zA-Z0-9]");
  static final RegExp specialCharacterRegex = RegExp(r'([!@#$%^&*(),.?":{}|<>/])');
  static final RegExp phoneRegex = RegExp(r'(^(?:[+0])?[0-9]{10,12}$)');
  static final RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  bool isContainNumber(String? text) {
    if (Utils.isEmpty(text)) return false;
    return numberRegex.firstMatch(text!) != null;
  }

  bool isContainUpper(String? text) {
    if (Utils.isEmpty(text)) return false;
    return upperRegex.firstMatch(text!) != null;
  }

  bool isContainLower(String? text) {
    if (Utils.isEmpty(text)) return false;
    return lowerRegex.firstMatch(text!) != null;
  }

  bool isAlphabet(String? text) {
    if (Utils.isEmpty(text)) return false;
    return digitRegex.hasMatch(text!);
  }

  bool isSpecialCharacter(String? text) {
    if (Utils.isEmpty(text)) return false;
    return specialCharacterRegex.hasMatch(text!);
  }

  String? checkPhoneNumber(String? phoneNumber, {String? errorEmpty, String? errorInvalid}) {
    phoneNumber = phoneNumber?.trim();
    if (Utils.isEmpty(phoneNumber)) {
      return errorEmpty ?? 'Invalid Phone Number ';
    } else {
      return null;
    }
  }

  String? checkEmail(String? email) {
    email = email?.trim();
    if (Utils.isEmpty(email) || !emailRegex.hasMatch(email!)) {
      return 'Invalid Email';
    } else {
      return null;
    }
  }

  // String? checkPhoneNumberSpecific(String? phoneNumber, {String? errorEmpty, String? errorInvalid}) {
  //   phoneNumber = (phoneNumber ?? "").getPhoneNumberWithoutPrefix();
  //   if (Utils.isEmpty(phoneNumber) || digitRegex.hasMatch(phoneNumber!) || phoneNumber.length != 8) {
  //     return errorEmpty ?? R.string.msg_invalid_phone.tr();
  //   } else {
  //     return null;
  //   }
  // }
  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      logger.d('Internet not connect');
      return false;
    }
    return false;
  }

  static void showSnackBar(BuildContext context, String? text) {
    if (Utils.isEmpty(text)) return;
    final snackBar = SnackBar(
      content: Text(text ?? ""),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  static void showErrorSnackBar(BuildContext context, String? text) {
    onWidgetDidBuild(() => showSnackBar(context, text));
  }

  static bool isEmpty(Object? text) {
    if (text is String) return text.isEmpty;
    if (text is List) return text.isEmpty;
    return text == null;
  }

  static Future<String> loadStringTranslations(String fileName) async {
    return await rootBundle.loadString("lib/res/translations/$fileName");
  }

  // static Future updateBadge(int count) async {
  //   if (await FlutterAppBadger.isAppBadgeSupported()) {
  //     FlutterAppBadger.updateBadgeCount(count);
  //   }
  // }

  // static void showForegroundNotification(String? title, String? body,
  //     {VoidCallback? onTapNotification}) {
  //   if (Utils.isEmpty(title) && Utils.isEmpty(body)) {
  //     return;
  //   }
  //   showOverlayNotification((context) {
  //     return Card(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.r)),
  //       ),
  //       margin: EdgeInsets.symmetric(
  //           horizontal: 5, vertical: 5 + MediaQuery.of(context).padding.top),
  //       child: InkWell(
  //         onTap: () {
  //           OverlaySupportEntry.of(context)!.dismiss();
  //           onTapNotification?.call();
  //         },
  //         child: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
  //           child: Row(
  //             children: [
  //               Image.asset(R.drawable.logo, width: 32.w, fit: BoxFit.fitWidth),
  //               10.horizontalSpace,
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       title ?? "",
  //                       style: Theme.of(context).textTheme.headingMdStyle,
  //                     ),
  //                     Text(
  //                       body ?? "",
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: Theme.of(context)
  //                           .textTheme
  //                           .buttonMdStyle
  //                           .copyWith(color: R.color.numColor),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               10.horizontalSpace,
  //               IconButton(
  //                   icon: Icon(Icons.close, color: R.color.gray),
  //                   onPressed: () {
  //                     OverlaySupportEntry.of(context)!.dismiss();
  //                   })
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }, duration: const Duration(milliseconds: 4000));
  // }


  // static Future showPopupYesNoButton(
  //     {required BuildContext context,
  //       required String contentText,
  //       String? titleText,
  //       String? submitText,
  //       String? cancelText,
  //       VoidCallback? submitCallback,
  //       VoidCallback? cancelCallback,
  //       List<String>? args,
  //       bool dismissible = false,
  //       bool reversePosition = false}) {
  //   return showDialog(
  //       barrierDismissible: dismissible,
  //       context: context,
  //       builder: (context) {
  //         final List<String> contentSpeared = contentText.split("\{\}");
  //         return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15.r),
  //             ),
  //             title: Text(titleText ?? R.string.app_name.tr(),
  //                 style: Theme.of(context).textTheme.title2),
  //             content: args != null && args.isNotEmpty
  //                 ? Text.rich(
  //                 style: Theme.of(context)
  //                     .textTheme
  //                     .subTitle
  //                     .copyWith(color: R.color.black),
  //                 TextSpan(text: contentSpeared.first, children: [
  //                   TextSpan(
  //                       text: args.join(", "),
  //                       style: Theme.of(context)
  //                           .textTheme
  //                           .subTitle
  //                           .copyWith(
  //                           color: R.color.black,
  //                           fontWeight: FontWeight.w700)),
  //                   TextSpan(text: contentSpeared.last)
  //                 ]))
  //                 : Text(
  //               contentText,
  //               style: Theme.of(context)
  //                   .textTheme
  //                   .subTitle
  //                   .copyWith(color: R.color.black),
  //             ),
  //             actions: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   SingleTapDetector(
  //                     onTap: () {
  //                       NavigationUtils.popDialog(context);
  //                       if (reversePosition) {
  //                         submitCallback?.call();
  //                       } else {
  //                         cancelCallback?.call();
  //                       }
  //                     },
  //                     child: Center(
  //                       child: Padding(
  //                         padding: EdgeInsets.all(15.h),
  //                         child: Text(
  //                           reversePosition
  //                               ? submitText ?? R.string.yes.tr()
  //                               : cancelText ?? R.string.no.tr(),
  //                           style: Theme.of(context)
  //                               .textTheme
  //                               .labelHighLight
  //                               .copyWith(
  //                               color: reversePosition
  //                                   ? R.color.blue
  //                                   : R.color.red),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 10.w),
  //                   SingleTapDetector(
  //                     onTap: () {
  //                       NavigationUtils.popDialog(context);
  //                       if (reversePosition) {
  //                         cancelCallback?.call();
  //                       } else {
  //                         submitCallback?.call();
  //                       }
  //                     },
  //                     child: Center(
  //                       child: Padding(
  //                         padding: EdgeInsets.all(15.h),
  //                         child: Text(
  //                           reversePosition
  //                               ? cancelText ?? R.string.no.tr()
  //                               : submitText ?? R.string.yes.tr(),
  //                           style: Theme.of(context)
  //                               .textTheme
  //                               .labelHighLight
  //                               .copyWith(
  //                               color: reversePosition
  //                                   ? R.color.red
  //                                   : R.color.blue),
  //                           overflow: TextOverflow.ellipsis,
  //                           maxLines: 2,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ]);
  //       });
  // }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

// static bool isTablet() {
//   var size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
//   var diagonal =
//   sqrt((size.width * size.width) + (size.height * size.height));
//
//   var isTablet = diagonal > 1100.0;
//   return isTablet;
// }
//
// static String timeAgoString(String? time) {
//   if (Utils.isEmpty(time)) return "";
//   return timeago.format(DateTime.parse(time!),
//       locale: Localization.currentLanguage.languageCode);
// }

// static String timeAgo(DateTime? dateTime) {
//   if (Utils.isEmpty(dateTime)) return "";
//   return timeago.format(dateTime!,
//       locale: Localization.currentLanguage.languageCode);
// }

// static String timeAgoByDate(DateTime? dateTime, {String? locale}) {
//   if (Utils.isEmpty(dateTime)) return "";
//   timeago.setLocaleMessages(
//     locale ?? Localization.currentLanguage.languageCode,
//     TimeagoLookupMessagesWithoutPrefix(),
//   );
//   return timeago.format(dateTime!.subtract(dateTime.timeZoneOffset),
//       locale: locale);
// }

// static String timeAgo(String? date) {
//   if (date == null) return "";
//
//   final tempDate = DateTime.tryParse(date)?.toLocal();
//   if (tempDate == null) return "";
//
//   final now = DateTime.now();
//   final yesterday = now.subtract(Duration(days: 1));
//
//   if (now.day == tempDate.day && now.month == tempDate.month && now.year == tempDate.year) {
//     return '${R.string.label_today.tr()}, ${DateFormat("hh:mm").format(tempDate)}';
//   } else if (yesterday.day == tempDate.day && yesterday.month == tempDate.month && yesterday.year == tempDate.year) {
//     return '${R.string.label_yesterday.tr()}, ${DateFormat("hh:mm").format(tempDate)}';
//   } else {
//     return DateFormat("dd/MM/yyyy, hh:mm").format(tempDate);
//   }
// }
// static String getId() {
//   var uuid = const Uuid();
//   return uuid.v4();
// }
}


// String? toEmoji() => startsWith("U+") == true
//     ? String.fromCharCode(int.parse("0x${replaceAll("U+", "")}"))
//     : this;

//   String? getPhoneNumberWithoutPrefix() =>
//       replaceAll(" ", "").replaceAll(Utils.prefixPhoneNumber().trim(), "").trim();
//
// }
//
//
// extension StringExtenion on String {
//   String? toEmoji() => startsWith("U+") == true
//       ? String.fromCharCode(int.parse("0x${replaceAll("U+", "")}"))
//       : this;
//
//   String? getPhoneNumberWithoutPrefix() =>
//       replaceAll(" ", "").replaceAll(Utils.prefixPhoneNumber().trim(), "").trim();
//
// }
