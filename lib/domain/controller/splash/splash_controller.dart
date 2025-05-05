import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';

import '../../../config/utils/my_preferences.dart';

class SplashController extends GetxController {
  bool isLoading = true;
  @override
  void onInit() {
    super.onInit();
    initPreferences();
  }

  initPreferences() async {
    MyPrefrences.init();
  }

  gotoNextPage() async {
    Future.delayed(const Duration(seconds: 3), () {
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? guidData;
      if (isGuestLogin) {
        guidData = MyPrefrences.getString(MyPrefrences.guestGuidUser) ?? "";
      } else {
        guidData = MyPrefrences.getString(MyPrefrences.guidUser) ?? "";
      }
      if (guidData.isNotEmpty) {
        Get.offAllNamed(RouteHelper.bottomNavBar);
      } else {
        Get.toNamed(RouteHelper.loginScreen);
      }
    });
  }

  bool noInternet = false;
}
