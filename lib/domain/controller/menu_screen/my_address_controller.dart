import 'package:ShapeCom/presentation/screens/my_addresses/model/my_addresses_model.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/my_addresses/model/delete_address_model.dart';

class MyAddressController extends GetxController {
  ApiService apiService = ApiService(context: Get.context!);
  bool isLoading = true;
  MyAddressesModel? myAddressesModel;
  int myAddressesCount = 0;
  @override
  void onInit() {
    super.onInit();
    getMyAddresses();
  }

  getMyAddresses() async {
    try {
      MyConstants.mapLong = 0;
      MyConstants.mapLat = 0;
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
      } else {
        if (myAddressesModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [myAddressesModel!.msg!]);
        }
      }
    } catch (e) {
      print("getMyAddresses Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isLoading = false;
      update();
    }
  }

  deleteMyAddresses(var addressID) async {
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
        "AddressID": addressID,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointDeleteAddress, method: MyConstants.POST, body: requestBody);
      DeleteAddressModel? deleteAddressModel = DeleteAddressModel.fromJson(responseBody);
      if (deleteAddressModel!.status! == 1) {
        if (deleteAddressModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [deleteAddressModel!.msg!]);
        }
        myAddressesModel = null;
        myAddressesCount = 0;
        isLoading = true;
        update();
        getMyAddresses();
      } else {
        if (deleteAddressModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [deleteAddressModel!.msg!]);
        }
      }
    } catch (e) {
      print("deleteMyAddresses Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }
}
