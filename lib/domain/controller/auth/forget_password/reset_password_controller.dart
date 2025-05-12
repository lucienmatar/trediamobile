import 'package:ShapeCom/config/network/api_service.dart';
import 'package:ShapeCom/config/utils/my_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';

import '../../../../config/route/route.dart';
import '../../../../config/utils/my_constants.dart';
import '../../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../../presentation/screens/auth/forget_password/reset_password/model/reset_password_model.dart';

class ResetPasswordController extends GetxController {
  bool submitLoading = false;
  bool checkPasswordStrength = false;
  bool hasPasswordFocus = false;
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?":{}|<>]).{6,}$');
  ApiService apiService = ApiService(context: Get.context!);

  resetPasswordApi() async {
    if (passController.text.toLowerCase() != confirmPassController.text.toLowerCase()) {
      CustomSnackBar.error(errorList: [MyStrings.kMatchPassError]);
    } else {
      try {
        int userID = MyPrefrences.getInt(MyPrefrences.userID) ?? 0;
        var requestBody = {
          "UserID": userID,
          "Id_College": MyConstants.Id_College,
          "lang": MyConstants.currentLanguage,
          "Password": passController.text.toString().trim(),
        };
        dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointResetPassword, method: MyConstants.POST, body: requestBody);
        ResetPasswordModel? resetPasswordModel = ResetPasswordModel.fromJson(responseBody);
        if (resetPasswordModel.status == 1) {
          if (resetPasswordModel.msg!.isNotEmpty) {
            CustomSnackBar.success(successList: [resetPasswordModel.msg!]);
          }
          MyPrefrences.saveInt(MyPrefrences.userID, 0); //reset
          MyPrefrences.saveInt(MyPrefrences.forgetPasswordID, 0); //reset
          Get.offAllNamed(RouteHelper.loginScreen);
        } else {
          if (resetPasswordModel.msg!.isNotEmpty) {
            CustomSnackBar.error(errorList: [resetPasswordModel.msg!]);
          }
        }
      } catch (e) {
        print("resetPasswordApi Error ${e.toString()}");
        CustomSnackBar.error(errorList: [MyStrings.networkError]);
      }
    }
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return MyStrings.enterYourPassword_;
    } else {
      if (checkPasswordStrength) {
        if (!regex.hasMatch(value)) {
          return MyStrings.invalidPassMsg;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  void changePasswordFocus(bool hasFocus) {
    hasPasswordFocus = hasFocus;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    MyPrefrences.init();
  }
}