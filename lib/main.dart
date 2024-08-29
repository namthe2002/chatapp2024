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
import 'package:live_yoko/View/Account/Splash.dart';
import 'package:live_yoko/View/Chat/ProfileChatDetail.dart';
import 'package:live_yoko/View/Chat/home_chat.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'Global/Themes.dart';
import 'Service/PushNotification/firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'View/Login/Login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  bool isDarkMode = await Utils.getBoolValueWithKey(Constant.DARK_MODE);
  bool isAutoMode = await Utils.getBoolValueWithKey(Constant.AUTO_MODE);
  Locale? locale;
  String language =
      await Utils.getStringValueWithKey(Constant.LANGUAGE_SYSTEM_INDEX);
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
          initialRoute: '/',
          routes: {
            '/': (context) => Login(),
            '/home': (context) => HomeChatWebsite(), // Sửa route từ /widget thành /home
            '/profile': (context) => ProfileChatDetail(),
          },
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
    notificationIcon: AndroidResource(
        name: 'background_icon',
        defType: 'drawable'), // Default is ic_launcher from folder mipmap
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

  final RemoteMessage? message = await FirebaseMessaging.instance
      .getInitialMessage(); // gọi hàm  này khi thông báo được nhấn vào từ trạng thái app đang đóng
  if (message != null) {
    PushNotifications.navigationInNotification(message.data);
  }
}
