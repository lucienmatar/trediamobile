import 'package:get/get.dart';
import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/my_cart/model/cart_count_model.dart';

class CartCountController extends GetxController {
  int cartCount = 0;
  ApiService apiService = ApiService(context: Get.context!);
  CartCountModel? cartCountModel;

  getItemsInCartCountApi() async {
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
        "lang": MyConstants.currentLanguage,
        "GuidUser": guidData,
        "Id_College": MyConstants.Id_College,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItemsInCartCount, method: MyConstants.POST, body: requestBody, showProgress: false);
      cartCountModel = CartCountModel.fromJson(responseBody);
      if (cartCountModel!.status == 1) {
        cartCount = cartCountModel!.data!.count!.toInt();
        update();
        /*if (getItemModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [getItemModel.msg!]);
        }*/
      } else {
        if (cartCountModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [cartCountModel!.msg!]);
        }
      }
    } catch (e) {
      print("getItemsInCartCountApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  manageCartCount() {}
}
