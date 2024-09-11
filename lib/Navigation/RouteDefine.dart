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
import 'package:live_yoko/View/Chat/ProfileChatDetail.dart';
import 'package:live_yoko/View/Chat/SearchChat.dart';
import 'package:live_yoko/View/Login/forgotPass/forgotPassword.dart';
import 'package:live_yoko/View/Login/login_qr.dart';
import 'package:live_yoko/View/Register/register.dart';

import '../Utils/Utils.dart';
import '../View/Chat/home_chat.dart';
import '../View/Chat/theme_mode_page.dart';

class RouteDefine {
  static Widget getPageByName(String pageName) {
    switch (pageName) {
      case 'Login':
        return Login();
      case 'Chat':
        // return Chat();
          return HomeChatWebsite();
      case 'HomeChatWebsite':
          return HomeChatWebsite();
      case 'SearchChat':
        return SearchChat();
      case 'ChatDetail':
        return ChatBoxDetail();
      case 'UpdateProfile':
        return UpdateProfile();
      case 'Friend':
        return Friend();
      case 'ManageFriends':
        return ManageFriends();
      case 'LanguageSettings':
        return LanguageSettings();
      case 'NotificationSetting':
        return NotificationSetting();
      case 'ChatSetting':
        return ChatSetting();
      case 'ChatCreate':
        return ChatCreate();
      case 'GroupCreate':
        return GroupCreate();
      case 'GroupCreateStep2':
        return GroupCreateStep2();
      case 'MediaChatDetail':
        return MediaChatDetail();
      case 'ProfileChatDetail':
        return ProfileChatDetail();
      case 'AdminAccount':
        return AdminAccount();
      case 'AddAccount':
        return AddAccount();
      case 'AccountDetail':
        return AccountDetail();
      case 'ChangePassword':
        return ChangePassword();
      case 'LoginQr':
        return LoginQr();
      case 'Register':
        return Register();
      case 'ForgotPassword':
        return ForgotPassword();
      case 'SelectThemeMode' :
        return SelectThemeMode();
      default:
        return Splash();
    }
  }
}
