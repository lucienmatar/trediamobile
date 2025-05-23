import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/auth/forget_password/verify_forget_password/verify_forget_password_screen.dart';
import '../../../presentation/screens/auth/profile_complete/model/change_phone_number_model.dart';
import '../../../presentation/screens/auth/profile_complete/model/profile_details_model.dart';
import '../../../presentation/screens/auth/registration/model/country_code_model.dart';

class ChangePhoneNumberController extends GetxController {
  String? selectedCountryCode = "+961";
  CountryCodeModel? countryCodeModel;
  ApiService apiService = ApiService(context: Get.context!);
  ProfileDetailsModel? profileDetailsModel;
  String? phonenumber = "";
  String? mobileErrorMessage;
  bool submitLoading = false;
  bool isSubmit = true;
  final TextEditingController mobileController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    MyPrefrences.init(); // Call init separately if needed
    countryCodesApi();
    getProfileDetails();
  }

  countryCodesApi() async {
    try {
      var requestBody = {"Id_College": MyConstants.Id_College, "lang": MyConstants.currentLanguage};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetCountryCodes, method: MyConstants.POST, body: requestBody, showProgress: false);
      countryCodeModel = CountryCodeModel.fromJson(responseBody);
      if (countryCodeModel!.status == 1) {
        update();
      } else {
        CustomSnackBar.error(errorList: [countryCodeModel!.msg!]);
      }
    } catch (e) {
      print("countryCodesApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  getProfileDetails() async {
    try {
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      String? guidData;
      if (isGuestLogin) {
        token = null;
        guidData = MyPrefrences.getString(MyPrefrences.guestGuidUser) ?? "";
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
        guidData = MyPrefrences.getString(MyPrefrences.guidUser) ?? "";
      }
      var requestBody = {
        "token": token,
        "GuidUser": guidData,
        "lang": MyConstants.currentLanguage,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetProfileDetails, method: MyConstants.POST, body: requestBody);
      profileDetailsModel = ProfileDetailsModel.fromJson(responseBody);
      if (profileDetailsModel!.status! == 1) {
        if (profileDetailsModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [profileDetailsModel!.msg!]);
        }
        List<String> phoneNumber = profileDetailsModel!.data!.phoneNumber!.split(" ");
        phonenumber = phoneNumber[1];
        mobileController.text = phonenumber!;
      } else {
        if (profileDetailsModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [profileDetailsModel!.msg!]);
        }
      }
      update();
    } catch (e) {
      print("getProfileDetails 2 Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  changePhoneNumberApi() async {
    if (mobileController.text.toString().trim().length != 10) {
      CustomSnackBar.error(errorList: [MyStrings.mobileErrorMsg]);
    } else {
      try {
        bool isGuestLogin = false;
        isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
        String? token;
        if (isGuestLogin) {
          token = null;
        } else {
          token = MyPrefrences.getString(MyPrefrences.token) ?? "";
        }
        String? phoneNumber = "$selectedCountryCode ${mobileController.text.toString().trim()}";
        var requestBody = {"token": token, "lang": MyConstants.currentLanguage, "NewPhoneNumber": phoneNumber};
        dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointChangePhoneNumber, method: MyConstants.POST, body: requestBody);
        ChangePhoneNumberModel changePhoneNumberModel = ChangePhoneNumberModel.fromJson(responseBody);
        if ((changePhoneNumberModel!.status == 0) || (changePhoneNumberModel!.status == 1)) {
          if (changePhoneNumberModel!.msg!.isNotEmpty) {
            CustomSnackBar.success(successList: [changePhoneNumberModel!.msg!]);
          }
          MyPrefrences.saveInt(MyPrefrences.changePhoneNumberID, changePhoneNumberModel.data!.changePhoneNumberID!.toInt());
          Get.off(VerifyForgetPassScreen(), arguments: {'phoneNumber': changePhoneNumberModel.data!.phoneNumber!, 'isChangePhoneNumber': true});
          //Get.toNamed(RouteHelper.verifyPassCodeScreen, arguments: {'phoneNumber': changePhoneNumberModel.data!.phoneNumber!, 'isChangePhoneNumber': true});
        } else {
          if (changePhoneNumberModel!.msg!.isNotEmpty) {
            CustomSnackBar.error(errorList: [changePhoneNumberModel!.msg!]);
          }
        }
      } catch (e) {
        print("changePhoneNumberApi Error ${e.toString()}");
        CustomSnackBar.error(errorList: [MyStrings.networkError]);
      }
    }
  }
}
