import 'dart:async';

import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/presentation/components/snack_bar/show_custom_snackbar.dart';

class EmailVerificationController extends GetxController {

  bool needSmsVerification     = false;
  bool isProfileCompleteEnable = false;

  String currentText = "";
  bool needTwoFactor = false;
  bool submitLoading = false;
  bool isLoading     = true;
  bool resendLoading = false;


  Future<void> verifyEmail(String text) async {

    if (text.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading=true;
    update();

    submitLoading=false;
    update();
  }

}
