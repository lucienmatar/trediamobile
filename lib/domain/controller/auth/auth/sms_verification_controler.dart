import 'dart:async';

import 'package:ShapeCom/config/utils/my_preferences.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:ShapeCom/presentation/screens/auth/registration/model/resend_code_model.dart';
import 'package:ShapeCom/presentation/screens/auth/registration/model/validate_registration_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../config/network/api_service.dart';
import '../../../../config/route/route.dart';
import '../../../../config/utils/my_constants.dart';

class SmsVerificationController extends GetxController {
  bool hasError = false;
  bool isLoading = true;
  String currentText = '';
  bool isProfileCompleteEnable = false;
  ApiService apiService = ApiService(context: Get.context!);
  ResendCodeModel? resendCodeModel;
  ValidateRegistrationModel? validateRegistrationModel;
  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  var otpController = TextEditingController();
  int _counter = 60; // Initial countdown time (seconds)
  late Timer _timer;
  bool _isResendButtonEnabled = false;
  int minute = 1;
  bool submitLoading = false;
  bool resendLoading = false;

  void startTimer() {
    print("startTimer");
    _isResendButtonEnabled = false;
    _counter = minute * 60; // Reset counter
    update();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        //print("_counter $_counter");
        _counter--;
      } else {
        minute = resendCodeModel!.data!.timeoutInMinutes!.toInt();
        print("minute updated $minute");
        resendLoading = false;
        _isResendButtonEnabled = true;
        update();
        _timer.cancel();
      }
    });
  }

  validateRegistrationApi() async {
    try {
      print("validateRegistrationApi");
      int registerUserID = MyPrefrences.getInt(MyPrefrences.registerUserID) ?? 0;
      print("registerUserID $registerUserID");
      hasError = false;
      update();
      var requestBody = {
        "UserID": registerUserID,
        "Id_College": MyConstants.Id_College,
        "lang": MyConstants.currentLanguage,
        "RegToken": currentText,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointValidateRegistration, method: MyConstants.POST, body: requestBody);
      validateRegistrationModel = ValidateRegistrationModel.fromJson(responseBody);
      if (validateRegistrationModel!.status == 1) {
        if (validateRegistrationModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [validateRegistrationModel!.msg!]);
        }
        Get.toNamed(RouteHelper.setUsernamePasswordScreen, arguments: false);
      } else {
        otpController.text = "";
        errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
        hasError = true;
        update();
        if (validateRegistrationModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [validateRegistrationModel!.msg!]);
        }
      }
    } catch (e) {
      print("validateRegistrationApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  resendCodeApi() async {
    try {
      int registerUserID = MyPrefrences.getInt(MyPrefrences.registerUserID) ?? 0;
      resendLoading = true;
      update();
      var requestBody = {
        "UserID": registerUserID,
        "Id_College": MyConstants.Id_College,
        "lang": MyConstants.currentLanguage,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointResendCodeRegistration, method: MyConstants.POST, body: requestBody);
      resendCodeModel = ResendCodeModel.fromJson(responseBody);
      if (resendCodeModel!.status == 0 || resendCodeModel!.status == 1) {
        minute = resendCodeModel!.data!.timeoutInMinutes!.toInt();
        startTimer();
        if (resendCodeModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [resendCodeModel!.msg!]);
        }
      } else {
        if (resendCodeModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [resendCodeModel!.msg!]);
        }
      }
    } catch (e) {
      print("resendCodeApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
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
