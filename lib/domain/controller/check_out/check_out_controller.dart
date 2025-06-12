import 'package:ShapeCom/presentation/screens/check_out/model/order_summary_model.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/check_out/model/payment_method_model.dart';
import '../../../presentation/screens/check_out/model/place_order_model.dart';
import '../../../presentation/screens/check_out/model/shipping_method_model.dart';
import '../../../presentation/screens/my_cart/model/cart_count_model.dart';
import '../../../presentation/screens/my_cart/model/my_cart_item_model.dart';

class CheckOutController extends GetxController {
  double subTotal = 0;
  double discount = 0;
  double deliveryFee = 0;
  double vat = 0;
  double total = 0;
  int currentPayment = -1;
  int currentShipping = -1;
  String? shippingMethodName = "default";
  List<String> paymentMethod = ["default"];
  bool isShimmerShow = true;
  bool isShippingAddressShow = false;
  bool isPaymentMethodShow = false;
  bool isPlaceOrderButtonShow = false;
  bool isDeliveryFeeShow = false;
  String noDataFound = "";
  String SellingCurrencyLogo = "";
  int currentPageNumber = 1;
  int pageSize = 10;
  int cartCount = 0;
  var PaymentMethodID = -1;
  var ShippingMethodID = -1;
  int shippingMethodCount = 0;
  int paymentMethodCount = 0;
  ApiService apiService = ApiService(context: Get.context!);
  MyCartItemModel? myCartItemModel;
  ShippingMethodModel? shippingMethodModel;
  PaymentMethodModel? paymentMethodModel;
  OrderSummaryModel? orderSummaryModel;
  List<String> shippingMethod = ["default"];
  String currentShippingMethod = MyStrings.chooseShippingMethod;
  String currentPaymentMethod = MyStrings.choosePaymentMethod;
  CartCountModel? cartCountModel;
  PlaceOrderModel? placeOrderModel;

  @override
  void onInit() {
    super.onInit();
    getItemsInCartCountApi();
    getShippingMethodsApi(callback: () {});
  }

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
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItemsInCartCount, method: MyConstants.POST, body: requestBody);
      cartCountModel = CartCountModel.fromJson(responseBody);
      if (cartCountModel!.status == 1) {
        cartCount = cartCountModel!.data!.count!.toInt();
        pageSize = cartCount;
        getCartItemsApi();
      } else {
        if (cartCountModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [cartCountModel!.msg!]);
        }
      }
    } catch (e) {
      print("getItemsInCartCountApi 1 Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  getCartItemsApi() async {
    try {
      isShimmerShow = currentPageNumber == 1; // Only show shimmer on first page
      update();
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
        "pageNumber": currentPageNumber,
        "pageSize": pageSize,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItemsInCart, method: MyConstants.POST, body: requestBody);
      MyCartItemModel tempModel = MyCartItemModel.fromJson(responseBody);
      if (tempModel.status == 1 && tempModel.data!.items != null) {
        if (currentPageNumber == 1) {
          myCartItemModel = tempModel;
        } else {
          myCartItemModel!.data!.items!.addAll(tempModel.data!.items!);
        }
        cartCount = myCartItemModel!.data!.items!.length;
      } else {
        if (currentPageNumber == 1) {
          myCartItemModel = null;
          cartCount = 0;
        }
        noDataFound = tempModel.msg!;
      }
    } catch (e) {
      print("getCartItemsApi 2 Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isShimmerShow = false;
      update();
    }
  }

  getShippingMethodsApi({required Null Function() callback}) async {
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
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetShippingMethods, method: MyConstants.POST, body: requestBody);
      shippingMethodModel = ShippingMethodModel.fromJson(responseBody);
      if (shippingMethodModel!.status! == 1) {
        shippingMethodCount = shippingMethodModel!.data!.length;
        if (shippingMethodCount > 0) {
          shippingMethod.clear();
          shippingMethod = shippingMethodModel!.data
                  ?.where((item) => item.display != null) // Filter out null display values
                  .map((item) => item.display!) // Map to display string
                  .toList() ??
              [];
          if (currentShipping == -1) {
            currentShipping = 0;
            shippingMethodName = shippingMethod[0];
          }
          changeShipping();
        }
        callback();
      } else {
        if (shippingMethodModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [shippingMethodModel!.msg!]);
        }
      }
    } catch (e) {
      print("getShippingMethodsApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  getPaymentMethodsApi({required Null Function() callback}) async {
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
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetPaymentMethods, method: MyConstants.POST, body: requestBody);
      paymentMethodModel = PaymentMethodModel.fromJson(responseBody);
      if (paymentMethodModel!.status! == 1) {
        paymentMethodCount = paymentMethodModel!.data!.length;
        if (paymentMethodCount > 0) {
          paymentMethod.clear();
          paymentMethod = paymentMethodModel!.data?.where((item) => item.display != null).map((item) => item.display!).toList() ?? [];
        }
        if (paymentMethodCount == 1) {
          PaymentMethodID = int.tryParse(paymentMethodModel!.data![0].value!) ?? -1;
          currentPayment = 0;
          currentPaymentMethod = "${MyStrings.paymentMethod} : ${paymentMethodModel!.data![0].display}";
        }
        getOrderSummaryBeforeCheckoutApi();
        callback();
      } else {
        if (paymentMethodModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [paymentMethodModel!.msg!]);
        }
      }
    } catch (e) {
      print("getPaymentMethodsApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  getOrderSummaryBeforeCheckoutApi() async {
    try {
      bool isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      String? guidData;
      if (isGuestLogin) {
        token = null;
        guidData = MyPrefrences.getString(MyPrefrences.guestGuidUser) ?? "";
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
        guidData = MyPrefrences.getString(MyPrefrences.guidUser) ?? "";
      }
      var ShippingAddressID = 0;
      if (shippingMethodName != null && shippingMethodName!.isNotEmpty) {
        print("shippingMethodName $shippingMethodName");
        if ("In-Store Pickup".toLowerCase() == shippingMethodName!.toLowerCase()) {
          ShippingAddressID = 0;
          PaymentMethodID = 0;
        } else {
          ShippingAddressID = MyConstants.ShippingAddressID;
        }
      }
      var requestBody = {"token": token, "GuidUser": guidData, "ShippingAddressID": ShippingAddressID, "PaymentMethodID": PaymentMethodID, "ShippingMethodID": ShippingMethodID, "lang": "en", "ccy": "LBP"};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetOrderSummaryBeforeCheckout, method: MyConstants.POST, body: requestBody);
      orderSummaryModel = OrderSummaryModel.fromJson(responseBody);
      if (orderSummaryModel!.status! == 1) {
        SellingCurrencyLogo = orderSummaryModel!.data!.orderSummary!.sellingCurrencyLogo!;
        subTotal = orderSummaryModel!.data!.orderSummary!.subtotal!.toDouble();
        discount = orderSummaryModel!.data!.orderSummary!.discount!.toDouble();
        deliveryFee = orderSummaryModel!.data!.orderSummary!.shippingFee!.toDouble();
        vat = orderSummaryModel!.data!.orderSummary!.vat!.toDouble();
        total = orderSummaryModel!.data!.orderSummary!.total!.toDouble();
        if (shippingMethodName != null && shippingMethodName!.isNotEmpty) {
          if ("In-Store Pickup".toLowerCase() == shippingMethodName!.toLowerCase()) {
            isPlaceOrderButtonShow = true;
          } else {
            if (("In-Store Pickup".toLowerCase() != shippingMethodName!.toLowerCase()) && (ShippingAddressID != 0) && (ShippingMethodID != -1) && (PaymentMethodID != -1)) {
              isPlaceOrderButtonShow = true;
            }
          }
        }
      } else {
        if (orderSummaryModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [orderSummaryModel!.msg!]);
        }
      }
    } catch (e) {
      print("getOrderSummaryBeforeCheckoutApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  placeOrderApi({required Null Function() callback}) async {
    try {
      bool isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      String? guidData;
      if (isGuestLogin) {
        token = null;
        guidData = MyPrefrences.getString(MyPrefrences.guestGuidUser) ?? "";
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
        guidData = MyPrefrences.getString(MyPrefrences.guidUser) ?? "";
      }
      var ShippingAddressID = 0;
      if (shippingMethodName != null && shippingMethodName!.isNotEmpty) {
        print("shippingMethodName $shippingMethodName");
        if ("In-Store Pickup".toLowerCase() == shippingMethodName!.toLowerCase()) {
          ShippingAddressID = 0;
          PaymentMethodID = 0;
        } else {
          ShippingAddressID = MyConstants.ShippingAddressID;
        }
      }
      var requestBody = {"token": token, "GuidUser": guidData, "ShippingAddressID": ShippingAddressID, "ShippingMethodID": ShippingMethodID, "lang": "en"};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointPlaceOrder, method: MyConstants.POST, body: requestBody);
      placeOrderModel = PlaceOrderModel.fromJson(responseBody);
      if (placeOrderModel!.status! == 1) {
        callback();
        if (placeOrderModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [placeOrderModel!.msg!]);
        }
      } else {
        if (placeOrderModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [placeOrderModel!.msg!]);
        }
      }
    } catch (e) {
      print("placeOrderApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  void setPaymentMethode(int index) {
    currentPayment = index;
    PaymentMethodID = int.tryParse(paymentMethodModel!.data![index].value!) ?? -1;
    currentPaymentMethod = "${MyStrings.paymentMethod} : ${paymentMethodModel!.data![index].display}";
    update();
  }

  void setCurrentShipping(int index, String shippingMethodNameSelection) {
    print("setCurrentShipping");
    currentShipping = index;
    shippingMethodName = shippingMethodNameSelection;
    print("currentShipping $currentShipping");
    print("shippingMethodName $shippingMethodName");
    update();
  }

  void changeShipping() {
    print("changeShipping");
    currentShippingMethod = "${MyStrings.shippingMethod} : $shippingMethodName";
    print("currentShippingMethod $currentShippingMethod");
    for (int i = 0; i < shippingMethodModel!.data!.length; i++) {
      if (shippingMethod[i] == shippingMethodName) {
        ShippingMethodID = int.tryParse(shippingMethodModel!.data![i].value!) ?? -1;
        break;
      }
    }
    if ("In-Store Pickup".toLowerCase() == shippingMethodName!.toLowerCase()) {
      isShippingAddressShow = false;
      isPaymentMethodShow = false;
      isDeliveryFeeShow = false;
      isPlaceOrderButtonShow = false;
      update();
    }
    if ("Delivery".toLowerCase() == shippingMethodName!.toLowerCase()) {
      isShippingAddressShow = true;
      isPaymentMethodShow = true;
      isDeliveryFeeShow = true;
      isPlaceOrderButtonShow = false;
      update();
      getPaymentMethodsApi(callback: () {});
    }
    getOrderSummaryBeforeCheckoutApi();
  }
}
