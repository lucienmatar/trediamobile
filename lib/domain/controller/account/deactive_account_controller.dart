import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/auth/change-password/model/change_password_model.dart';
import '../../../presentation/screens/auth/deactive_account/model/deactive_account_model.dart';
import '../../../presentation/screens/auth/profile_complete/model/logout_model.dart';

class DeactiveAccountController extends GetxController {
  ApiService apiService = ApiService(context: Get.context!);

  deactiveAccountApi() async {
    try {
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      if (isGuestLogin) {
        token = null;
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
      }
      var requestBody = {
        "token": token,
        "lang": MyConstants.currentLanguage,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointDeactivateAccount, method: MyConstants.POST, body: requestBody);
      DeactiveAccountModel deactiveAccountModel = DeactiveAccountModel.fromJson(responseBody);
      if (deactiveAccountModel!.status == 1) {
        if (deactiveAccountModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [deactiveAccountModel!.msg!]);
        }
        logoutApi();
      } else {
        if (deactiveAccountModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [deactiveAccountModel!.msg!]);
        }
      }
    } catch (e) {
      print("deactiveAccountApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  logoutApi() async {
    try {
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      if (isGuestLogin) {
        token = null;
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
      }
      var requestBody = {
        "token": token,
        "lang": MyConstants.currentLanguage,
        "PushID": MyConstants.deviceToken,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointLogout, method: MyConstants.POST, body: requestBody);
      LogoutModel logoutModel = LogoutModel.fromJson(responseBody);
      if (logoutModel!.status == 1) {
        if (logoutModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [logoutModel!.msg!]);
        }
        MyPrefrences.clear();
        Get.offAllNamed(RouteHelper.loginScreen);
      } else {
        if (logoutModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [logoutModel!.msg!]);
        }
      }
    } catch (e) {
      print("logoutModel 2 Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }
}
