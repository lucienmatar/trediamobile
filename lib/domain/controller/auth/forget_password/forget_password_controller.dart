import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../config/network/api_service.dart';
import '../../../../config/route/route.dart';
import '../../../../config/utils/my_constants.dart';
import '../../../../config/utils/my_preferences.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../../presentation/screens/auth/forget_password/forget_password/model/forget_password_model.dart';

class ForgetPasswordController extends GetxController {
  bool submitLoading = false;
  TextEditingController usernameController = TextEditingController();
  ForgetPasswordModel? forgetPasswordModel;
  ApiService apiService = ApiService(context: Get.context!);
  String? phoneNumber;

  forgetPasswordApi() async {
    try {
      submitLoading = true;
      update();
      var requestBody = {
        "Id_College": MyConstants.Id_College,
        "lang": MyConstants.currentLanguage,
        "Username": usernameController.text.toString().trim(),
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointForgetPassword, method: MyConstants.POST, body: requestBody);
      forgetPasswordModel = ForgetPasswordModel.fromJson(responseBody);
      if (forgetPasswordModel!.status == 1) {
        MyPrefrences.saveInt(MyPrefrences.forgetPasswordID, forgetPasswordModel!.data!.forgetPasswordID!.toInt());
        MyPrefrences.saveInt(MyPrefrences.userID, forgetPasswordModel!.data!.userID!.toInt());
        phoneNumber = forgetPasswordModel!.data!.phoneNumber;
        if (forgetPasswordModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [forgetPasswordModel!.msg!]);
        }
        Get.toNamed(RouteHelper.verifyPassCodeScreen, arguments: {'phoneNumber': phoneNumber});
      } else {
        usernameController.text = "";
        if (forgetPasswordModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [forgetPasswordModel!.msg!]);
        }
      }
    } catch (e) {
      print("forgetPasswordApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      submitLoading = false;
      update();
    }
  }
}
