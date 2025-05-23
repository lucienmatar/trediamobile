import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/auth/change-password/model/change_password_model.dart';

class ChangePasswordController extends GetxController {
  String? currentPass, password, confirmPass;

  bool isLoading = false;
  List<String> errors = [];

  TextEditingController passController = TextEditingController();
  TextEditingController currentPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  FocusNode currentPassFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();
  ApiService apiService = ApiService(context: Get.context!);

  changePasswordApi() async {
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
        "OldPassword": currentPassController.text.toString().trim(),
        "NewPassword": passController.text.toString().trim(),
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointChangePassword, method: MyConstants.POST, body: requestBody);
      ChangePasswordModel changePasswordModel = ChangePasswordModel.fromJson(responseBody);
      if (changePasswordModel!.status == 1) {
        if (changePasswordModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [changePasswordModel!.msg!]);
        }
        Navigator.pop(Get.context!);
      } else {
        passController.text = "";
        currentPassController.text = "";
        confirmPassController.text = "";
        if (changePasswordModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [changePasswordModel!.msg!]);
        }
      }
    } catch (e) {
      print("changePasswordApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
      update();
    }
  }

  removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
      update();
    }
  }

  bool submitLoading = false;

  void clearData() {
    isLoading = false;
    errors.clear();
    currentPassController.text = '';
    passController.text = '';
    confirmPassController.text = '';
  }
}
