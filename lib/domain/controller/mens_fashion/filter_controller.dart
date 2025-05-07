import 'dart:ffi';

import 'package:ShapeCom/presentation/screens/mens_fashion/model/category_model.dart';
import 'package:ShapeCom/presentation/screens/mens_fashion/model/currency_model.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';

class FilterController extends GetxController {
  CategoryModel? categoryModel;
  CurrencyModel? currencyModel;
  CurrencyModel? maxOnlinePriceBasedOnCcyModel;
  int categoryCount = 0;
  int currencyCount = 0;
  int? selectedCurrencyValue; // Store the selected radio button's value
  Set<String> selectedCategoryIds = {};
  double rangeStartValue = 0;
  double rangeEndValue = 0;
  bool isRangeValueLoaded=false;
  ApiService apiService = ApiService(context: Get.context!);

  @override
  void onInit() {
    super.onInit();
    initPreference();
    getCategoriesApi();
    getCurrenciesApi();
  }

  initPreference() async {
    await MyPrefrences.init();
  }

  getCategoriesApi() async {
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
        "Id_College": MyConstants.Id_College,
        "token": token,
        "lang": MyConstants.currentLanguage,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetCategories, method: MyConstants.POST, body: requestBody);
      categoryModel = CategoryModel.fromJson(responseBody);
      if (categoryModel!.status == 1) {
        categoryCount = categoryModel!.data!.length;
        print("categoryCount $categoryCount");
        update();
        /*if (getItemModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [getItemModel.msg!]);
        }*/
      } else {
        if (categoryModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [categoryModel!.msg!]);
        }
      }
    } catch (e) {
      print("getCategoriesApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  getCurrenciesApi() async {
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
        "Id_College": MyConstants.Id_College,
        "token": token,
        "lang": MyConstants.currentLanguage,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetCurrencies, method: MyConstants.POST, body: requestBody);
      currencyModel = CurrencyModel.fromJson(responseBody);
      if (currencyModel!.status == 1) {
        currencyCount = currencyModel!.data!.length;
        String selectedCurrency = MyPrefrences.getString(MyPrefrences.currency) ?? "LBP";
        for (int i = 0; i < currencyCount; i++) {
          if (currencyModel!.data![i].display == selectedCurrency) {
            selectedCurrencyValue = i;
            getMaxOnlinePriceBasedOnCcyApi(selectedCurrency);
            break;
          }
        }
        update();
        /*if (getItemModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [getItemModel.msg!]);
        }*/
      } else {
        if (currencyModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [currencyModel!.msg!]);
        }
      }
    } catch (e) {
      print("getCurrenciesApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  getMaxOnlinePriceBasedOnCcyApi(String selectedCurrency) async {
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
        "Id_College": MyConstants.Id_College,
        "token": token,
        "lang": MyConstants.currentLanguage,
        "ccy": selectedCurrency,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointMaxOnlinePriceBasedOnCcy, method: MyConstants.POST, body: requestBody);
      maxOnlinePriceBasedOnCcyModel = CurrencyModel.fromJson(responseBody);
      if (maxOnlinePriceBasedOnCcyModel!.status == 1) {
        isRangeValueLoaded=true;
        rangeStartValue = 0;
        rangeEndValue = double.parse(maxOnlinePriceBasedOnCcyModel!.data![0].display!);
        update();
        /*if (getItemModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [getItemModel.msg!]);
        }*/
      } else {
        isRangeValueLoaded=false;
        if (maxOnlinePriceBasedOnCcyModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [maxOnlinePriceBasedOnCcyModel!.msg!]);
        }
      }
    } catch (e) {
      print("getMaxOnlinePriceBasedOnCcyApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  setStartAndEndValue(double startValue, double endValue) {
    rangeStartValue = startValue;
    rangeEndValue = endValue;
    update();
  }
}
