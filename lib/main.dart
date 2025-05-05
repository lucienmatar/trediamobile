import 'package:ShapeCom/config/service/notification_service.dart';
import 'package:ShapeCom/config/utils/my_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/theme_data.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/utils/translation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NotificationService notificationServices = NotificationService();
  late String SelectedLanguage = 'English';
  Map<String, Locale> languageToLocale = {
    'English': const Locale('en', 'US'),
    'French': const Locale('fr', 'FR'),
    'Arabic': const Locale('ar', 'SA'),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLanguage();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    print("_initializeNotifications");
    await notificationServices.requestNotificationPermission();
    notificationServices.initLocalNotifications();
    notificationServices.firebaseInit();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Fetch and print the device token
    String? deviceToken = await notificationServices.getDeviceToken();
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('fcmtoken', deviceToken ?? '');
    // print('Device Token: main.dart $deviceToken');
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // Handle the message when the app is opened from a terminated state
      //navigateToScreen(initialMessage.data);
    }
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (kDebugMode) {
      print("Notifications  " + message.notification!.title.toString());
      print("Notifications  " + message.notification!.body.toString());
    }
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: languageToLocale[SelectedLanguage] ?? const Locale('en', 'US'),
      title: MyStrings.appName,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
      translations: TranslationService(),
      fallbackLocale: const Locale('en'), // Fallback language
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      transitionDuration: const Duration(milliseconds: 200),
      initialRoute: RouteHelper.splashScreen,
      theme: AppTheme.lightThemeData,
      navigatorKey: Get.key,
      getPages: RouteHelper().routes,
    );
  }

  Future<void> setLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      final locale = PlatformDispatcher.instance.locale;
      final deviceLanguage = Intl.verifiedLocale(
        locale.toLanguageTag(),
        (locale) => true,
        onFailure: (_) => 'Unknown',
      )!
          .split('_')
          .first;
      List<String> language = deviceLanguage.split('-');
      //print("deviceLanguage ${language[0]}");
      if (language[0] == 'en') {
        SelectedLanguage = 'English';
        sp.setString(MyPrefrences.language, 'English');
      } else if (language[0] == 'fr') {
        SelectedLanguage = 'French';
        sp.setString(MyPrefrences.language, 'French');
      } else if (language[0] == 'ar') {
        SelectedLanguage = 'Arabic';
        sp.setString(MyPrefrences.language, 'Arabic');
      } else {
        SelectedLanguage = 'English';
        sp.setString(MyPrefrences.language, 'English');
      }
    } catch (e) {
      sp.setString(MyPrefrences.language, 'English');
    } finally {
      setState(() {
        SelectedLanguage = sp.getString(MyPrefrences.language) ?? 'English';
        print("SelectedLanguage $SelectedLanguage");
      });
    }
  }
}
