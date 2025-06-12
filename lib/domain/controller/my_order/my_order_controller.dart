import 'package:ShapeCom/presentation/screens/check_out/widget/my_order_model.dart';
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
  MyOrderModel? myOrderModel;
  int currentPageNumber = 1;
  int pageSize = 10;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    initPreference();
    getMyOrderApi();
  }

  getMyOrderApi() async {
    try {
      bool isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      if (isGuestLogin) {
        token = null;
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
      }
      var requestBody = {
        "token": token,
        "ccy": "LBP",
        "lang": "en",
        "pageNumber": currentPageNumber,
        "pageSize": pageSize,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetOrders, method: MyConstants.POST, body: requestBody, showProgress: false);
      MyOrderModel tempMyOrderModel = MyOrderModel.fromJson(responseBody);
      if (tempMyOrderModel!.status == 1 && tempMyOrderModel!.data!.orders != null) {
        if (currentPageNumber == 1) {
          myOrderModel = tempMyOrderModel;
        } else {
          myOrderModel!.data!.orders!.addAll(tempMyOrderModel.data!.orders!);
        }
        totalMyOrderCount = myOrderModel!.data!.orders!.length;
        for (int i = 0; i < totalMyOrderCount; i++) {
          myOrderModel!.data!.orders![i].orderItemsLength = myOrderModel!.data!.orders![i].orderItems!.length;
        }
      } else {
        if (currentPageNumber == 1) {
          myOrderModel = null;
          totalMyOrderCount = 0;
          if (tempMyOrderModel.msg != null) {
            CustomSnackBar.error(errorList: [tempMyOrderModel.msg!]);
          }
        }
      }
    } catch (e) {
      print("getMyOrderApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> refreshItem() async {
    isLoading = true;
    update();
    currentPageNumber = 1;
    await Future.delayed(const Duration(seconds: 1));
    getMyOrderApi();
  }

  Future<void> refreshLoadMoreItem() async {
    if (myOrderModel == null || myOrderModel!.data!.orders!.length < (currentPageNumber * pageSize)) {
      // No more items to load
      return;
    }
    isLoading = true;
    update();
    currentPageNumber++;
    await Future.delayed(const Duration(seconds: 1));
    getMyOrderApi();
  }

  initPreference() async {
    await MyPrefrences.init();
  }
}
