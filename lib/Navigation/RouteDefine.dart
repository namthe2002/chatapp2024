import 'package:flutter/material.dart';
import 'package:live_yoko/View/Account/AccountDetail.dart';
import 'package:live_yoko/View/Account/AddAccount.dart';
import 'package:live_yoko/View/Account/AdminAccount.dart';
import 'package:live_yoko/View/Account/ChangePassword.dart';
import 'package:live_yoko/View/Account/ChatSetting.dart';
import 'package:live_yoko/View/Account/Friend.dart';
import 'package:live_yoko/View/Account/LanguageSettings.dart';
import 'package:live_yoko/View/Chat/home_chat_2.dart';
import 'package:live_yoko/View/Login/Login.dart';
import 'package:live_yoko/View/Account/ManageFriends.dart';
import 'package:live_yoko/View/Account/NotificationSetting.dart';
import 'package:live_yoko/View/Account/Splash.dart';
import 'package:live_yoko/View/Account/UpdateProfile.dart';
import 'package:live_yoko/View/Chat/Chat.dart';
import 'package:live_yoko/View/Chat/ChatCreate.dart';
import 'package:live_yoko/View/Chat/ChatBoxDetail.dart';
import 'package:live_yoko/View/Chat/GroupCreate.dart';
import 'package:live_yoko/View/Chat/GroupCreateStep2.dart';
import 'package:live_yoko/View/Chat/MediaChatDetail.dart';
import 'package:live_yoko/View/Chat/SearchChat.dart';
import 'package:live_yoko/View/Login/forgotPass/forgotPassword.dart';
import 'package:live_yoko/View/Login/login_qr.dart';
import 'package:live_yoko/View/Register/register.dart';

import '../View/Chat/ProfileChatDetail.dart';
import '../View/Chat/home_chat.dart';
import '../View/Chat/theme_mode_page.dart';

class RouteDefine {
  // Định nghĩa tên route
  static const String login = '/login';
  static const String chat = '/chat';
  static const String searchChat = '/searchChat';
  static const String updateProfile = '/updateProfile';
  static const String friend = '/friend';
  static const String manageFriends = '/manageFriends';
  static const String languageSettings = '/languageSettings';
  static const String notificationSetting = '/notificationSetting';
  static const String chatSetting = '/chatSetting';
  static const String chatCreate = '/chatCreate';
  static const String groupCreate = '/groupCreate';
  static const String groupCreateStep2 = '/groupCreateStep2';
  static const String mediaChatDetail = '/mediaChatDetail';
  static const String profileChatDetail = '/profileChatDetail';
  static const String adminAccount = '/adminAccount';
  static const String addAccount = '/addAccount';
  static const String accountDetail = '/accountDetail';
  static const String changePassword = '/changePassword';
  static const String loginQr = '/loginQr';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';
  static const String selectThemeMode = '/selectThemeMode';
  static const String chatBoxDetail = '/chatBoxDetail';

  // Hàm trả về widget dựa trên tên route
  static Widget getPageByName(String pageName) {
    switch (pageName) {
      case login:
        return Login();
      case chat:
        return HomeChatWebsite();
      case searchChat:
        return SearchChat();
      case updateProfile:
        return UpdateProfile();
      case friend:
        return Friend();
      case manageFriends:
        return ManageFriends();
      case languageSettings:
        return LanguageSettings();
      case notificationSetting:
        return NotificationSetting();
      case chatSetting:
        return ChatSetting();
      case chatCreate:
        return ChatCreate();
      case groupCreate:
        return GroupCreate();
      case groupCreateStep2:
        return GroupCreateStep2();
      case mediaChatDetail:
        return MediaChatDetail();
      case profileChatDetail:
        return ProfileChatDetail();
      case adminAccount:
        return AdminAccount();
      case addAccount:
        return AddAccount();
      case accountDetail:
        return AccountDetail();
      case changePassword:
        return ChangePassword();
      case loginQr:
        return LoginQr();
      case register:
        return Register();
      case forgotPassword:
        return ForgotPassword();
      case selectThemeMode:
        return SelectThemeMode();
      case chatBoxDetail:
        return ChatBoxDetail();
      default:
        return Splash();
    }
  }
}
