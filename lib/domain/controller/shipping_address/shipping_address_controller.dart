import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/my_addresses/model/my_addresses_model.dart';

class ShippingAddressController extends GetxController {
  ApiService apiService = ApiService(context: Get.context!);
  bool isLoading = true;
  MyAddressesModel? myAddressesModel;
  int myAddressesCount = 0;
  int currentIndex = -1;
  @override
  void onInit() {
    super.onInit();
    getShippingAddressApi();
  }

  getShippingAddressApi() async {
    try {
      isLoading = true;
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
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetAddresses, method: MyConstants.POST, body: requestBody, showProgress: false);
      myAddressesModel = MyAddressesModel.fromJson(responseBody);
      if (myAddressesModel!.status! == 1) {
        if (myAddressesModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [myAddressesModel!.msg!]);
        }
        myAddressesCount = myAddressesModel!.data!.addresses!.length;
        if (myAddressesCount == 1) {
          currentIndex = 0;
        }
      } else {
        if (myAddressesModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [myAddressesModel!.msg!]);
        }
      }
    } catch (e) {
      print("getMyAddresses 2 Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isLoading = false;
      update();
    }
  }

  void setCurrentIndex(int index, var AddressID) {
    MyConstants.currentShippingAddress = "${MyStrings.shippingAddress} : ${myAddressesModel!.data!.addresses![index].qazaTown ?? ""}";
    MyConstants.ShippingAddressID = AddressID;
    currentIndex = index;
    update();
  }
}
