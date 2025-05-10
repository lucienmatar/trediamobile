import 'dart:convert';

import 'package:ShapeCom/presentation/screens/auth/registration/model/register_model.dart';
import 'package:ShapeCom/presentation/screens/auth/registration/model/town_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../config/network/api_service.dart';
import '../../../../config/route/route.dart';
import '../../../../config/utils/my_constants.dart';
import '../../../../config/utils/my_preferences.dart';
import '../../../../presentation/screens/auth/registration/model/country_code_model.dart';

class RegistrationController extends GetxController {
  bool isLoading = true;
  bool agreeTC = false;
  bool checkPasswordStrength = false;
  bool isSearchCompleted = false;
  ApiService apiService = ApiService(context: Get.context!);
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode countryNameFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode companyNameFocusNode = FocusNode();
  final FocusNode countryFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  TextEditingController searchLocationController = TextEditingController();
  //final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  //final TextEditingController cPasswordController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();

  String? email;
  String? password;
  String? confirmPassword;
  String? countryName;
  String? countryCode;
  String? mobileCode;
  String? userName;
  String? phoneNo;
  String? firstName;
  String? lastName;
  String? mobileErrorMessage;

  RegExp regex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  bool submitLoading = false;
  String? selectedGender = "temp";
  TownModel? townModel;
  //List<Map<String, String>>? townList;
  List<String>? townList;
  String? selectedTownName = MyStrings.selectTown;
  String? selectedTown = MyStrings.selectTown;
  String? selectedCountryCode = "+961";
  CountryCodeModel? countryCodeModel;

  @override
  void onInit() {
    super.onInit();
    MyPrefrences.init(); // Call init separately if needed
    countryCodesApi();
    getAllTownApi();
  }

  countryCodesApi() async {
    try {
      var requestBody = {"Id_College": MyConstants.Id_College, "lang": MyConstants.currentLanguage};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetCountryCodes, method: MyConstants.POST, body: requestBody, showProgress: true);
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

  getAllTownApi() async {
    try {
      var requestBody = {"Id_College": MyConstants.Id_College, "lang": MyConstants.currentLanguage};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetTowns, method: MyConstants.POST, body: requestBody, showProgress: true);
      townModel = TownModel.fromJson(responseBody);
      if (townModel!.status == 1) {
        if (townModel!.msg!.isNotEmpty) {
          print("town len ${townModel!.data!.length}");
          townList = townModel?.data?.map((data) => data.display ?? '').toList() ?? [];
          /*townList = townModel!.data?.map((data) {
                return {
                  'display': data.display ?? '',
                  'value': data.value ?? '',
                };
              }).toList() ??
              [];*/
          selectedTown = townModel!.data![0].display!;
          update();
        }
      } else {
        CustomSnackBar.error(errorList: [townModel!.msg!]);
      }
    } catch (e) {
      print("getAllTownApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  registerApi(double? curLatitude, double? curLongitude) async {
    try {
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? guidData;
      if (isGuestLogin) {
        guidData = MyPrefrences.getString(MyPrefrences.guestGuidUser) ?? "";
      } else {
        guidData = null;
      }
      var requestBody = {
        "GuidUser": guidData,
        "Id_College": MyConstants.Id_College,
        "lang": MyConstants.currentLanguage,
        "FirstName": firstNameController.text.toString().trim(),
        "MiddleName": middleNameController.text.toString().trim(),
        "LastName": lastNameController.text.toString().trim(),
        "Email": emailController.text.toString().trim(),
        "PhoneNumber": "$selectedCountryCode ${mobileController.text.toString().trim()}",
        "Gender": selectedGender,
        "Id_Town": selectedTown,
        "AddressDetails": addressController.text.toString().trim(),
        "Longitude": curLongitude,
        "Latitude": curLatitude,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointRegister, method: MyConstants.POST, body: requestBody);
      RegisterModel registerModel = RegisterModel.fromJson(responseBody);
      if (registerModel.status == 0 || registerModel.status == 1) {
        MyPrefrences.saveInt(MyPrefrences.registerUserID, registerModel.data!.userID!.toInt());
        if (registerModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [registerModel.msg!]);
        }
        Get.offAllNamed(RouteHelper.smsVerificationScreen, arguments: {"phoneNumber": registerModel.data!.phoneNumber!});
      } else {
        if (registerModel.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [registerModel.msg!]);
        }
      }
    } catch (e) {
      print("registerApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  Future<List<dynamic>> fetchPlaceSuggestions(String query) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${MyConstants.GOOGLE_PLACE_API_KEY}';
    final response = await http.get(Uri.parse(url));
    print("fetchPlaceSuggestions statusCode ${response.statusCode}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print("fetchPlaceSuggestions statusCode ${jsonResponse.toString()}");
      return jsonResponse['predictions'];
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  // Fetch place details using Place Details API
  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${MyConstants.GOOGLE_PLACE_API_KEY}';
    final response = await http.get(Uri.parse(url));
    print("fetchPlaceDetails statusCode ${response.statusCode}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print("fetchPlaceDetails response ${jsonResponse.toString()}");
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to load place details');
    }
  }

  setCountryNameAndCode(String cName, String countryCode, String mobileCode) {
    countryName = cName;
    this.countryCode = countryCode;
    this.mobileCode = mobileCode;
    update();
  }

  updateAgreeTC() {
    agreeTC = !agreeTC;
    update();
  }

  void closeAllController() {
    isLoading = false;
    emailController.text = '';
    //passwordController.text = '';
    //cPasswordController.text = '';
    fNameController.text = '';
    lNameController.text = '';
    mobileController.text = '';
    countryController.text = '';
    firstNameController.text = '';
    middleNameController.text = '';
    lastNameController.text = '';
    companyNameController.text = '';
  }

  clearAllData() {
    closeAllController();
  }

  bool isCountryLoading = true;
  void initData() async {
    isLoading = true;
    update();

    isLoading = false;
    update();
  }

  bool countryLoading = true;

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

  bool noInternet = false;
  void changeInternet(bool hasInternet) {
    noInternet = false;
    initData();
    update();
  }

  bool hasPasswordFocus = false;
  void changePasswordFocus(bool hasFocus) {
    hasPasswordFocus = hasFocus;
    update();
  }
}
