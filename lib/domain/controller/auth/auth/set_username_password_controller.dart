import 'package:ShapeCom/presentation/screens/auth/set_username_password/model/create_account_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../config/network/api_service.dart';
import '../../../../config/route/route.dart';
import '../../../../config/utils/my_constants.dart';
import '../../../../config/utils/my_preferences.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../../presentation/screens/auth/login/model/login_model.dart';

class SetUsernamePasswordController extends GetxController {
  bool submitLoading = false;
  bool checkPasswordStrength = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{6,}$');
  ApiService apiService = ApiService(context: Get.context!);
  CreateAccountModel? createAccountModel;

  Future<int> createAccountApi() async {
    if (passController.text.toLowerCase() != confirmPassController.text.toLowerCase()) {
      CustomSnackBar.error(errorList: [MyStrings.kMatchPassError]);
      return 0;
    } else {
      try {
        int registerUserID = MyPrefrences.getInt(MyPrefrences.registerUserID) ?? 0;
        var requestBody = {
          "UserID": registerUserID,
          "Id_College": MyConstants.Id_College,
          "lang": MyConstants.currentLanguage,
          "Username": usernameController.text.toString().trim(),
          "Password": passController.text.toString().trim(),
        };
        dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointCreateAccount, method: MyConstants.POST, body: requestBody);
        createAccountModel = CreateAccountModel.fromJson(responseBody);
        if (createAccountModel!.status == 1) {
          print("createAccountModel!.status ${createAccountModel!.status}");
          if (createAccountModel!.msg!.isNotEmpty) {
            CustomSnackBar.success(successList: [createAccountModel!.msg!]);
          }
        } else {
          if (createAccountModel!.msg!.isNotEmpty) {
            CustomSnackBar.error(errorList: [createAccountModel!.msg!]);
          }
        }
        return createAccountModel!.status!.toInt();
      } catch (e) {
        print("createAccountApi Error ${e.toString()}");
        CustomSnackBar.error(errorList: [MyStrings.networkError]);
        return 0;
      }
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

      var requestBody = {"GuidUser": guidData, "Username": usernameController.text.toString().trim(), "Password": passController.text.toString().trim(), "Id_College": MyConstants.Id_College, "PushID": MyConstants.deviceToken, "OsVersion": MyConstants.stOsVersion, "MobileType": MyConstants.stMobileType, "MobVersion": MyConstants.mobVersion, "lang": MyConstants.currentLanguage};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointLogin, method: MyConstants.POST, body: requestBody);
      LoginModel loginModel = LoginModel.fromJson(responseBody);
      if (loginModel.status == 1) {
        MyPrefrences.saveInt(MyPrefrences.registerUserID, 0);
        MyPrefrences.saveBool(MyPrefrences.guestLogin, false);
        MyPrefrences.saveString(MyPrefrences.guestGuidUser, "");
        MyPrefrences.saveString(MyPrefrences.token, loginModel.data!.token!);
        MyPrefrences.saveString(MyPrefrences.guidUser, loginModel.data!.guidUser!);
        MyPrefrences.saveString(MyPrefrences.currency, loginModel.data!.currency!);
        if (loginModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [loginModel.msg!]);
        }
        Get.offAllNamed(RouteHelper.bottomNavBar);
      } else {
        CustomSnackBar.error(errorList: [loginModel.msg!]);
      }
    } catch (e) {
      print("loginApi 2 Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return MyStrings.enterYourPassword_.tr;
    } else {
      if (checkPasswordStrength) {
        if (!regex.hasMatch(value)) {
          return MyStrings.invalidPassMsg.tr;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    MyPrefrences.init();
  }
}
