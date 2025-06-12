import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/check_out/model/order_details_model.dart';

class TrackOrderController extends GetxController {
  ApiService apiService = ApiService(context: Get.context!);
  int currentPageNumber = 1;
  OrderDetailsModel? orderDetailsModel;

  getOrderDetailsApi(var OrderID) async {
    try {
      bool isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      if (isGuestLogin) {
        token = null;
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
      }
      var requestBody = {"token": token, "ccy": "LBP", "lang": "en", "OrderID": OrderID};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetOrderDetails, method: MyConstants.POST, body: requestBody);
      orderDetailsModel = OrderDetailsModel.fromJson(responseBody);
      if (orderDetailsModel!.status == 1) {
      } else {
        if (orderDetailsModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [orderDetailsModel!.msg!]);
        }
      }
    } catch (e) {
      print("getOrderDetailsApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }
}
