import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/AppController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Service/PushNotification/PushNotification.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:live_yoko/View/Account/Friend.dart';
import 'package:live_yoko/View/Chat/home_chat.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'Global/Themes.dart';
import 'Navigation/RouteDefine.dart';
import 'Service/PushNotification/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'View/Account/AccountDetail.dart';
import 'View/Account/AddAccount.dart';
import 'View/Account/AdminAccount.dart';
import 'View/Account/ChangePassword.dart';
import 'View/Account/ChatSetting.dart';
import 'View/Account/LanguageSettings.dart';
import 'View/Account/ManageFriends.dart';
import 'View/Account/NotificationSetting.dart';
import 'View/Account/Splash.dart';
import 'View/Account/UpdateProfile.dart';
import 'View/Chat/ChatCreate.dart';
import 'View/Chat/GroupCreate.dart';
import 'View/Chat/GroupCreateStep2.dart';
import 'View/Chat/MediaChatDetail.dart';
import 'View/Chat/ProfileChatDetail.dart';
import 'View/Chat/SearchChat.dart';
import 'View/Chat/theme_mode_page.dart';
import 'View/Login/Login.dart';
import 'View/Login/forgotPass/forgotPassword.dart';
import 'View/Login/login_qr.dart';
import 'View/Register/register.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
int roleId = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  bool isDarkMode = await Utils.getBoolValueWithKey(Constant.DARK_MODE);
  bool isAutoMode = await Utils.getBoolValueWithKey(Constant.AUTO_MODE);
  Locale? locale;
  String language = await Utils.getStringValueWithKey(Constant.LANGUAGE_SYSTEM_INDEX);
  if (language.isNotEmpty) {
    TextByNation.nationCode.value = language;
    locale = Locale(language);
  }
  Utils.setTranslate();
  runApp(ScreenUtilInit(
      designSize: kIsWeb ? Size(1728, 1117) : Size(390, 844),
      minTextAdapt: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          builder: (context, child) {
            if (kIsWeb) {
              return ResponsiveWrapper.builder(
                child,
                minWidth: 380,
                defaultScale: true,
                breakpoints: <ResponsiveBreakpoint>[
                  const ResponsiveBreakpoint.resize(500, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(768, name: TABLET),
                  const ResponsiveBreakpoint.resize(900, name: DESKTOP),
                ],
              );
            } else {
              return child ?? Container();
            }
          },
          navigatorKey: navigatorKey,
          title: 'ChatWeb',
          initialRoute: '/',
          getPages: [
            GetPage(name: RouteDefine.login, page: () => Login()),
            GetPage(name: RouteDefine.chat, popGesture: false, page: () => HomeChatWebsite()),
            GetPage(name: RouteDefine.searchChat, page: () => SearchChat()),
            GetPage(name: RouteDefine.updateProfile, page: () => UpdateProfile()),
            GetPage(name: RouteDefine.friend, page: () => Friend()),
            GetPage(name: RouteDefine.manageFriends, page: () => ManageFriends()),
            GetPage(name: RouteDefine.languageSettings, page: () => LanguageSettings()),
            GetPage(name: RouteDefine.notificationSetting, page: () => NotificationSetting()),
            GetPage(name: RouteDefine.chatSetting, page: () => ChatSetting()),
            GetPage(name: RouteDefine.chatCreate, page: () => ChatCreate()),
            GetPage(name: RouteDefine.groupCreate, page: () => GroupCreate()),
            GetPage(name: RouteDefine.groupCreateStep2, page: () => GroupCreateStep2()),
            GetPage(name: RouteDefine.mediaChatDetail, page: () => MediaChatDetail()),
            GetPage(name: RouteDefine.profileChatDetail, popGesture: false, page: () => ProfileChatDetail()),
            GetPage(name: RouteDefine.adminAccount, page: () => AdminAccount()),
            GetPage(name: RouteDefine.addAccount, page: () => AddAccount()),
            GetPage(name: RouteDefine.accountDetail, page: () => AccountDetail()),
            GetPage(name: RouteDefine.changePassword, page: () => ChangePassword()),
            GetPage(name: RouteDefine.loginQr, page: () => LoginQr()),
            GetPage(name: RouteDefine.register, page: () => Register()),
            GetPage(name: RouteDefine.forgotPassword, page: () => ForgotPassword()),
            GetPage(name: RouteDefine.selectThemeMode, page: () => SelectThemeMode()),
            GetPage(name: '/', page: () => Splash()),
          ],
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: isAutoMode == false
              ? isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light
              : MediaQuery.platformBrightnessOf(context) == Brightness.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          initialBinding: BindingsBuilder(() {
            Get.put(AppController());
          }),
        );
      }));
  // await startNotification();
}

Future<bool> startForegroundService() async {
  const androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: 'Title of the notification',
    notificationText: 'Text of the notification',
    notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'), // Default is ic_launcher from folder mipmap
  );
  await FlutterBackground.initialize(androidConfig: androidConfig);
  return FlutterBackground.enableBackgroundExecution();
}

Future firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    //do something by type
  }
}

Future startNotification() async {
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      name: "ChatApp",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await PushNotifications.localNotiInit();
  await PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    await PushNotifications.navigationInNotification(message.data);
  });

  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    PushNotifications.navigationInNotification(message.data);
  }
}
