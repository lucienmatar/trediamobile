import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:intl/intl.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/style.dart';
import '../../../presentation/screens/auth/profile_complete/model/edit_profile_model.dart';
import '../../../presentation/screens/auth/profile_complete/model/profile_details_model.dart';
import '../../../presentation/screens/mens_fashion/model/currency_model.dart';

class ProfileCompleteController extends GetxController {
  final genders = ['Male', 'Female'];
  var selectedGender = 'Male'.obs;
  void setGender(String gender) {
    print("gender=$gender");
    selectedGender.value = gender;
  }

  DateTime? dob;
  bool isSubmitDisable = true;
  ApiService apiService = ApiService(context: Get.context!);
  ProfileDetailsModel? profileDetailsModel;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  String? username = " ";

  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode mobileNoFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode stateFocusNode = FocusNode();
  FocusNode zipCodeFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode countryFocusNode = FocusNode();

  bool isLoading = false;
  bool submitLoading = false;
  String? phonenumber = "";
  String? serverDate = "";

  @override
  void onInit() {
    super.onInit();
    callApi();
  }

  callApi() {
    getProfileDetails();
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
        firstNameController.text = profileDetailsModel!.data!.firstName!;
        middleNameController.text = profileDetailsModel!.data!.middleName!;
        lastNameController.text = profileDetailsModel!.data!.lastName!;
        emailController.text = profileDetailsModel!.data!.email!;
        if (profileDetailsModel!.data!.dateOfBirth == null || profileDetailsModel!.data!.dateOfBirth!.isEmpty) {
          dobController.text = '';
        } else {
          DateTime parsedDate = DateTime.parse(profileDetailsModel!.data!.dateOfBirth!);
          dob = parsedDate;
          String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
          serverDate = DateFormat('yyyy-MM-dd').format(parsedDate);
          dobController.text = formattedDate;
        }
        //List<String> phoneNumber = profileDetailsModel!.data!.phoneNumber!.split(" ");
        //phonenumber = phoneNumber[1];
        phonenumber = profileDetailsModel!.data!.phoneNumber!;
        username = profileDetailsModel!.data!.username!;
        if (profileDetailsModel!.data!.gender == null || profileDetailsModel!.data!.gender!.isEmpty) {
          genderController.text = '';
          selectedGender.value = '';
        } else {
          if (profileDetailsModel!.data!.gender!.toLowerCase() == "m") {
            genderController.text = genders[0];
            selectedGender.value = genders[0];
          } else if (profileDetailsModel!.data!.gender!.toLowerCase() == "f") {
            genderController.text = genders[1];
            selectedGender.value = genders[1];
          }
        }
      } else {
        if (profileDetailsModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [profileDetailsModel!.msg!]);
        }
      }
      update();
    } catch (e) {
      print("getProfileDetails Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  editProfileDetails() async {
    if (firstNameController.text.toString().trim().isEmpty) {
      CustomSnackBar.error(errorList: ["${MyStrings.enterYour.tr} ${MyStrings.firstname.toLowerCase()}"]);
      return;
    } else if (middleNameController.text.toString().trim().isEmpty) {
      CustomSnackBar.error(errorList: ["${MyStrings.enterYour.tr} ${MyStrings.middleName.toLowerCase()}"]);
      return;
    } else if (lastNameController.text.toString().trim().isEmpty) {
      CustomSnackBar.error(errorList: ["${MyStrings.enterYour.tr} ${MyStrings.lastName.toLowerCase()}"]);
      return;
    } else if (emailController.text.toString().trim().isEmpty) {
      CustomSnackBar.error(errorList: ["${MyStrings.enterYour.tr} ${MyStrings.email.toLowerCase()}"]);
      return;
    }
    // else if (dobController.text.toString().trim().isEmpty) {
    //   CustomSnackBar.error(errorList: ["${MyStrings.enterYour.tr} ${MyStrings.dob.toLowerCase()}"]);
    //   return;
    // }
    else {
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
          "FirstName": firstNameController.text.toString().trim(),
          "MiddleName": middleNameController.text.toString().trim(),
          "LastName": lastNameController.text.toString().trim(),
          "Email": emailController.text.toString().trim(),
          "Gender": genderController.text.trim().isEmpty
              ? null
              : selectedGender.value.toLowerCase() == "male"
              ? "M"
              : "F",
          "DateOfBirth": dobController.text.trim().isEmpty
              ? null
              : dob?.toIso8601String(),
        };
        dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointEditProfile, method: MyConstants.POST, body: requestBody);
        EditProfileModel editProfileModel = EditProfileModel.fromJson(responseBody);
        if (editProfileModel!.status! == 1) {
          Get.back();
          if (editProfileModel!.msg!.isNotEmpty) {
            CustomSnackBar.twoSecondSuccess(successList: [editProfileModel!.msg!]);
          }
        } else {
          if (editProfileModel!.msg!.isNotEmpty) {
            CustomSnackBar.error(errorList: [editProfileModel!.msg!]);
          }
        }
      } catch (e) {
        print("editProfileDetails Error ${e.toString()}");
        CustomSnackBar.error(errorList: [MyStrings.networkError]);
      }
    }
  }

  updateProfile() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text.toString();
    String address = addressController.text.toString();
    String zip = zipCodeController.text.toString();
    String state = stateController.text.toString();

    if (firstName.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.kFirstNameNullError]);
      return;
    } else if (lastName.isEmpty) {
      CustomSnackBar.error(errorList: [MyStrings.kLastNameNullError]);
      return;
    }

    submitLoading = true;
    update();

    submitLoading = false;
    update();
  }
}
