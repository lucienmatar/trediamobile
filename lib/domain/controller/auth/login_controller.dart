import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:ShapeCom/domain/controller/auth/guest_login_model.dart';
import 'package:ShapeCom/presentation/screens/auth/login/model/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';

class LoginController extends GetxController {
  String selectedLanguage = 'English'; // Default language
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ApiService apiService = ApiService(context: Get.context!);
  final Map<String, Locale> languageMap = {
    'English': const Locale('en'),
    'Français': const Locale('fr'),
    'العربية': const Locale('ar'),
  };
  LoginModel? loginModel;

  @override
  void onInit() {
    super.onInit();
    initPreferences();
  }

  initPreferences() async {
    MyPrefrences.init();
    selectedLanguage = MyPrefrences.getString(MyPrefrences.language) ?? "English";
    update();
  }

  validateAndLogin() {
    if (emailController.text.toString().trim().isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterYourUsername]);
    } else if (passwordController.text.toString().trim().isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.enterYourPassword_]);
    } else {
      loginApi();
    }
  }

  guestLoginApi() async {
    try {
      var requestBody = {"Id_College": MyConstants.Id_College, "PushID": MyConstants.deviceToken, "OsVersion": MyConstants.stOsVersion, "MobileType": MyConstants.stMobileType, "MobVersion": MyConstants.mobVersion, "lang": MyConstants.currentLanguage};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGuestLogin, method: MyConstants.POST, body: requestBody);
      GuestLoginModel guestLoginModel = GuestLoginModel.fromJson(responseBody);
      if (guestLoginModel.status == 1) {
        MyPrefrences.saveBool(MyPrefrences.guestLogin, true);
        MyPrefrences.saveString(MyPrefrences.guestGuidUser, guestLoginModel.data!.guidUser!);
        MyPrefrences.saveString(MyPrefrences.currency, guestLoginModel.data!.currency!);
        if (guestLoginModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [guestLoginModel.msg!]);
        }
        Get.offAllNamed(RouteHelper.bottomNavBar);
      } else {
        CustomSnackBar.error(errorList: [guestLoginModel.msg!]);
      }
    } catch (e) {
      print("guestLoginApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  loginApi() async {
    try {
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? guidData;
      if (isGuestLogin) {
        guidData = MyPrefrences.getString(MyPrefrences.guestGuidUser) ?? "";
      } else {
        guidData = null;
      }

      var requestBody = {"GuidUser": guidData, "Username": emailController.text.toString().trim(), "Password": passwordController.text.toString().trim(), "Id_College": MyConstants.Id_College, "PushID": MyConstants.deviceToken, "OsVersion": MyConstants.stOsVersion, "MobileType": MyConstants.stMobileType, "MobVersion": MyConstants.mobVersion, "lang": MyConstants.currentLanguage};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointLogin, method: MyConstants.POST, body: requestBody);
      LoginModel loginModel = LoginModel.fromJson(responseBody);
      if (loginModel.status == 1) {
        //delete userid
        MyPrefrences.saveBool(MyPrefrences.guestLogin, false);
        MyPrefrences.saveString(MyPrefrences.guestGuidUser, "");
        MyPrefrences.saveString(MyPrefrences.token, loginModel.data!.token!);
        MyPrefrences.saveString(MyPrefrences.guidUser, loginModel.data!.guidUser!);
        MyPrefrences.saveString(MyPrefrences.currency, loginModel.data!.currency!);
        if (loginModel.msg!.isNotEmpty) {
          // CustomSnackBar.success(successList: [loginModel.msg!]);
        }
        Get.offAllNamed(RouteHelper.bottomNavBar);
      } else if(loginModel.status == -2){
        //open popup
      } else {
        CustomSnackBar.error(errorList: [loginModel.msg!]);
      }
    } catch (e) {
      print("loginApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  void forgetPassword() {
    Get.toNamed(RouteHelper.forgotPasswordScreen);
  }

  bool isSubmitLoading = false;
  void loginUser() async {
    isSubmitLoading = true;
    update();

    isSubmitLoading = false;
    update();
  }

  void clearTextField() {
    passwordController.text = '';
    emailController.text = '';
    update();
  }

  void setLocale(Locale locale, String languageName) {
    MyPrefrences.saveString(MyPrefrences.language, languageName);
    Get.updateLocale(locale);
    update();
  }
}
