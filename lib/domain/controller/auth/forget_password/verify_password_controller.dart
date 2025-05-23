import 'dart:async';

import 'package:ShapeCom/presentation/screens/auth/forget_password/verify_forget_password/model/resend_code_forget_password_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../config/network/api_service.dart';
import '../../../../config/route/route.dart';
import '../../../../config/utils/my_constants.dart';
import '../../../../config/utils/my_preferences.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../../presentation/screens/auth/forget_password/verify_forget_password/model/forget_password_validation_model.dart';
import '../../../../presentation/screens/auth/profile_complete/profile_complete_screen.dart';

class VerifyPasswordController extends GetxController {
  String email = '';
  String password = '';
  bool isLoading = false;
  bool remember = false;
  bool hasError = false;
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  List<String> errors = [];
  String currentText = "";
  String confirmPassword = '';
  bool isResendLoading = false;
  ApiService apiService = ApiService(context: Get.context!);
  ResendCodeForgetPassword? resendCodeForgetPassword;
  var otpController = TextEditingController();
  RxInt counter = 60.obs; // Initial countdown time (seconds)
  late Timer _timer;
  int minute = 1;
  bool verifyLoading = false;
  bool isChangePhoneNumber = false;
  ForgetPasswordValidationModel? forgetPasswordValidationModel;

  void startTimer() {
    print("startTimer");
    counter.value = minute * 60; // Reset counter
    update();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter.value > 0) {
        //print("_counter $_counter");
        counter.value--;
      } else {
        minute = resendCodeForgetPassword!.data!.timeoutInMinutes!.toInt();
        print("minute updated $minute");
        isResendLoading = false;
        update();
        _timer.cancel();
      }
    });
  }

  forgetPasswordValidationApi() async {
    try {
      int forgetPasswordID = MyPrefrences.getInt(MyPrefrences.forgetPasswordID) ?? 0;
      hasError = false;
      var requestBody = {
        "ForgetPasswordID": forgetPasswordID,
        "Id_College": MyConstants.Id_College,
        "lang": MyConstants.currentLanguage,
        "RegToken": currentText,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointForgetPasswordValidation, method: MyConstants.POST, body: requestBody);
      forgetPasswordValidationModel = ForgetPasswordValidationModel.fromJson(responseBody);
      if (forgetPasswordValidationModel!.status == 1) {
        if (forgetPasswordValidationModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [forgetPasswordValidationModel!.msg!]);
        }
        Get.toNamed(RouteHelper.resetPasswordScreen);
      } else {
        otpController.text = "";
        errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
        hasError = true;
        update();
        if (forgetPasswordValidationModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [forgetPasswordValidationModel!.msg!]);
        }
      }
    } catch (e) {
      print("forgetPasswordValidationApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  changePhoneNumberValidationApi() async {
    try {
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      if (isGuestLogin) {
        token = null;
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
      }
      int changePhoneNumberID = MyPrefrences.getInt(MyPrefrences.changePhoneNumberID) ?? 0;
      hasError = false;
      var requestBody = {
        "token": token,
        "lang": MyConstants.currentLanguage,
        "ChangePhoneNumberID": changePhoneNumberID,
        "RegToken": currentText,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointChangePhoneNumberValidation, method: MyConstants.POST, body: requestBody);
      forgetPasswordValidationModel = ForgetPasswordValidationModel.fromJson(responseBody);
      print("forgetPasswordValidationModel!.status ${forgetPasswordValidationModel!.status}");
      if (forgetPasswordValidationModel!.status == 1) {
        /*if (forgetPasswordValidationModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [forgetPasswordValidationModel!.msg!]);
        }*/
        Get.off(ProfileCompleteScreen());
      } else {
        if (forgetPasswordValidationModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [forgetPasswordValidationModel!.msg!]);
        }
        otpController.text = "";
        errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
        hasError = true;
        update();
      }
    } catch (e) {
      print("changePhoneNumberValidationApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  reSendCodePasswordApi() async {
    try {
      int forgetPasswordID = MyPrefrences.getInt(MyPrefrences.forgetPasswordID) ?? 0;
      int userID = MyPrefrences.getInt(MyPrefrences.userID) ?? 0;
      hasError = false;
      update();
      var requestBody = {
        "ForgetPasswordID": forgetPasswordID,
        "UserID": userID,
        "Id_College": MyConstants.Id_College,
        "lang": MyConstants.currentLanguage,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointResendCodeForgetPassword, method: MyConstants.POST, body: requestBody);
      resendCodeForgetPassword = ResendCodeForgetPassword.fromJson(responseBody);
      if (resendCodeForgetPassword!.status == 1) {
        isResendLoading = true;
        update();
        minute = resendCodeForgetPassword!.data!.timeoutInMinutes!.toInt();
        startTimer();
        if (resendCodeForgetPassword!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [resendCodeForgetPassword!.msg!]);
        }
      } else {
        otpController.text = "";
        errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
        hasError = true;
        if (resendCodeForgetPassword!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [resendCodeForgetPassword!.msg!]);
        }
        update();
      }
    } catch (e) {
      print("reSendCodePasswordApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  reSendCodeChangePhoneNumberApi() async {
    try {
      int changePhoneNumberID = MyPrefrences.getInt(MyPrefrences.changePhoneNumberID) ?? 0;
      hasError = false;
      update();
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
        "ChangePhoneNumberID": changePhoneNumberID,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointResendCodeChangePhoneNumber, method: MyConstants.POST, body: requestBody);
      resendCodeForgetPassword = ResendCodeForgetPassword.fromJson(responseBody);
      if (resendCodeForgetPassword!.status == 1) {
        isResendLoading = true;
        update();
        minute = resendCodeForgetPassword!.data!.timeoutInMinutes!.toInt();
        startTimer();
        if (resendCodeForgetPassword!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [resendCodeForgetPassword!.msg!]);
        }
      } else {
        otpController.text = "";
        errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
        hasError = true;
        if (resendCodeForgetPassword!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [resendCodeForgetPassword!.msg!]);
        }
        update();
      }
    } catch (e) {
      print("reSendCodePasswordApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  @override
  void onInit() {
    super.onInit();
    MyPrefrences.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }
}
