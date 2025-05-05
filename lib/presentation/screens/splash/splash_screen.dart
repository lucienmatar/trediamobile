import 'dart:io';

import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/config/utils/util.dart';
import 'package:ShapeCom/domain/controller/splash/splash_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../domain/controller/cart_controller/cartController.dart';
import '../../components/stataus_bar_color_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getDeviceName();
    MyUtils.splashScreen();
    var controller = Get.put(SplashController());
    Get.put(CartCountController());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.gotoNextPage();
    });
  }

  Future<void> getDeviceName() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String selectedLanguage = sp.getString(MyPrefrences.language) ?? 'English';
    if (selectedLanguage == 'English') {
      MyConstants.currentLanguage = "en";
    } else if (selectedLanguage == 'French') {
      MyConstants.currentLanguage = "fr";
    } else if (selectedLanguage == 'Arabic') {
      MyConstants.currentLanguage = "ar";
    }

    print("selectedLanguage SplashScreen $selectedLanguage");
    print("MyConstants.currentLanguage ${MyConstants.currentLanguage}");
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      MyConstants.stOsVersion = androidInfo.model; // Get device model (e.g., "Pixel 6")
      MyConstants.stMobileType = "Android";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      MyConstants.stOsVersion = iosInfo.name; // Get iPhone name (e.g., "John's iPhone")
      MyConstants.stMobileType = "IOS";
    }
  }

  @override
  void dispose() {
    MyUtils.allScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (controller) => StatusBarColorWidget(
        color: MyColor.primaryColor,
        child: Scaffold(
          backgroundColor: controller.noInternet ? MyColor.colorWhite : MyColor.primaryColor,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(MyImages.splashLogo, height: context.width * .6, width: context.width * .6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
