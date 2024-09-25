import 'package:flutter/material.dart';


enum LaunchType {
  LAUNCH_TYPE_WEB,
  LAUNCH_TYPE_EMAIL,
  LAUNCH_TYPE_PHONE,
  LAUNCH_TYPE_SMS
}

enum ToastType { SUCCESS, WARNING, ERROR, INFORM }

enum GuidePopupStep { STEP_1, STEP_2, STEP_3 }

extension GuidePopupStepExt on GuidePopupStep {
  int get position {
    switch (this) {
      case GuidePopupStep.STEP_1:
        return 1;
      case GuidePopupStep.STEP_2:
        return 2;
      default:
        return 3;
    }
  }

  GuidePopupStep getCurrentStepByPosition(int position) {
    switch (position) {
      case 1:
        return GuidePopupStep.STEP_1;
      case 2:
        return GuidePopupStep.STEP_2;
      default:
        return GuidePopupStep.STEP_3;
    }
  }
}

enum LanguageType {
  JAPANESE,
  ENGLISH,
}

extension LanguageTypeExt on LanguageType {
  String get languageCode {
    switch (this) {
      case LanguageType.ENGLISH:
        return 'en';
      case LanguageType.JAPANESE:
        return 'ja';
      default:
        return 'en';
    }
  }

  Locale get locale {
    switch (this) {
      case LanguageType.ENGLISH:
        return const Locale('en', 'US');
      case LanguageType.JAPANESE:
        return const Locale('ja', 'JP');
      default:
        return const Locale('en', 'US');
    }
  }

  static LanguageType getLanguageTypeFromCode(String languageCode) {
    switch (languageCode) {
      case 'en':
        return LanguageType.ENGLISH;
      case 'ja':
        return LanguageType.JAPANESE;
      default:
        return LanguageType.ENGLISH;
    }
  }
}

enum ResourcesAppPermissions {
  application_overlay,
  application_accessibility,
  application_storage
}

enum ResourcesOsCategory { ios, chromeos, android, windows }

enum ResourcesImportance { primary, secondary }
