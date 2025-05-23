import 'package:ShapeCom/presentation/screens/auth/profile_complete/model/logout_model.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/mens_fashion/model/currency_model.dart';

class MenuScreenController extends GetxController {
  bool isGuestLogin = true;
  CurrencyModel? currencyModel;
  RxInt selectedCurrencyValue = 0.obs; // Store the selected radio button's value
  int currencyCount = 0;
  ApiService apiService = ApiService(context: Get.context!);
  LogoutModel? logoutModel;
  @override
  void onInit() {
    super.onInit();
    initPreferences();
  }

  initPreferences() async {
    MyPrefrences.init();
    isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? true;
  }

  getCurrenciesApi({required Null Function() callback}) async {
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
        String selectedCurrency = "";
        selectedCurrency = MyPrefrences.getString(MyPrefrences.currency) ?? "LBP";
        for (int i = 0; i < currencyCount; i++) {
          if (currencyModel!.data![i].display == selectedCurrency) {
            selectedCurrencyValue.value = i!;
            //getMaxOnlinePriceBasedOnCcyApi(selectedCurrency);
            break;
          }
        }
        callback();
      } else {
        if (currencyModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [currencyModel!.msg!]);
        }
      }
    } catch (e) {
      print("getCurrenciesApi 2 Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  logoutApi({required Null Function() callback}) async {
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
        "PushID": MyConstants.deviceToken,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointLogout, method: MyConstants.POST, body: requestBody);
      logoutModel = LogoutModel.fromJson(responseBody);
      callback();
    } catch (e) {
      print("logoutModel Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }
}
