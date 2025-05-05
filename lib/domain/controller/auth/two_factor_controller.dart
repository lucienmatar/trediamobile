import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/presentation/components/snack_bar/show_custom_snackbar.dart';

class TwoFactorController extends GetxController {

  bool submitLoading = false;
  String currentText = '';

  bool isProfileCompleteEnable = false;

  verifyYourSms(String currentText) async {

    if (currentText.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
      return;
    }

    submitLoading = true;
    update();

    submitLoading = false;
    update();

  }

}