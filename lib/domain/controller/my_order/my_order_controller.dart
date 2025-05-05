import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/my_cart/model/get_item_model.dart';

class MyOrderController extends GetxController {
  String transectionId = "DW2458967847874";
  int productAmount = 05;
  int totalMyOrderCount = 1;
  List<String> orderStatus = ["Delivery", "Canceled", "In Progress"];
  ApiService apiService = ApiService(context: Get.context!);
  GetItemModel? getItemModel;

  @override
  void onInit() {
    super.onInit();
    initPreference();
    //getMyOrderApi();
  }

  getMyOrderApi() async {
    try {
      bool isGuestLogin = false;
      String currency = MyPrefrences.getString(MyPrefrences.currency) ?? "LBP";
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
        "Id_College": MyConstants.Id_College,
        "token": token,
        "GuidUser": guidData,
        "lang": MyConstants.currentLanguage,
        "ccy": currency,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItems, method: MyConstants.POST, body: requestBody);
      getItemModel = GetItemModel.fromJson(responseBody);
      if (getItemModel!.status == 1) {
        //totalMyOrderCount=getItemModel!.data!.count!.toInt();
      } else {
        if (getItemModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [getItemModel!.msg!]);
        }
      }
    } catch (e) {
      print("getMyOrderApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  initPreference() async {
    await MyPrefrences.init();
  }
}
