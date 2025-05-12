import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:ShapeCom/presentation/screens/my_cart/model/update_qty_cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/components/warning_aleart_dialog.dart';
import '../../../presentation/screens/my_cart/model/my_cart_item_model.dart';
import '../../../presentation/screens/my_cart/model/remove_item_from_cart_model.dart';
import '../../../presentation/screens/my_cart/model/sub_total_price_cart.dart';

class MyCartController extends GetxController {
  TextEditingController couponCodeController = TextEditingController();
  FocusNode couponCodeFocusNode = FocusNode();
  int productSize = 6;
  double productPrice = 245.00;
  double subTotal = 353.0;
  int currentPageNumber = 1;
  int pageSize = 10;
  int cartCount = 0;
  ApiService apiService = ApiService(context: Get.context!);
  MyCartItemModel? myCartItemModel;
  String noDataFound = "";
  SubTotalPriceCart? subTotalPriceCart;
  bool loadTotalPrice = false;
  bool isShimmerShow = true;

  @override
  void onInit() {
    super.onInit();
    loadCartApis();
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
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItemsInCart, method: MyConstants.POST, body: requestBody, showProgress: currentPageNumber > 1);
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
      print("getCartItemsApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isShimmerShow = false;
      update();
    }
  }

  updateQtyItemCartApi(int id_Item, int index, int quantity) async {
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
        "token": token,
        "lang": MyConstants.currentLanguage,
        "Id_Item": id_Item,
        "GuidUser": guidData,
        "Id_College": MyConstants.Id_College,
        "qty": quantity,
        "ccy": currency,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointUpdateQtyItemCart, method: MyConstants.POST, body: requestBody);
      UpdateQtyCartModel updateQtyCartModel = UpdateQtyCartModel.fromJson(responseBody);
      if (updateQtyCartModel.status == 1 || updateQtyCartModel.status == 0) {
        print("res qty ${updateQtyCartModel.data!.item!.qty!}");
        myCartItemModel!.data!.items![index].qty = updateQtyCartModel.data!.item!.qty!;
        myCartItemModel!.data!.items![index].sumOnlinePrice = updateQtyCartModel.data!.item!.sumOnlinePrice!;
        myCartItemModel!.data!.items![index].sumOnlinePriceBeforeDiscount = updateQtyCartModel.data!.item!.sumOnlinePriceBeforeDiscount!;
        getSubTotalPriceCartApi();
      } else {
        if (updateQtyCartModel.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [updateQtyCartModel.msg!]);
        }
      }
    } catch (e) {
      print("updateQtyItemCartApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  getSubTotalPriceCartApi() async {
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
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetSubTotalPriceCart, method: MyConstants.POST, body: requestBody, showProgress: false);
      subTotalPriceCart = SubTotalPriceCart.fromJson(responseBody);
      if (subTotalPriceCart!.status == 1) {
        loadTotalPrice = true;
      } else {
        loadTotalPrice = false;
        if (subTotalPriceCart!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [subTotalPriceCart!.msg!]);
        }
      }
    } catch (e) {
      print("getSubTotalPriceCartApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  removeItemFromCartApi(int id_Item) async {
    try {
      isShimmerShow = true;
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
        "Id_Item": id_Item,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointRemoveItemFromCart, method: MyConstants.POST, body: requestBody, showProgress: false);
      RemoveItemFromCartModel removeItemFromCartModel = RemoveItemFromCartModel.fromJson(responseBody);
      if (removeItemFromCartModel.status == 1) {
        if (removeItemFromCartModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [removeItemFromCartModel.msg!]);
        }
      } else {
        if (removeItemFromCartModel.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [removeItemFromCartModel.msg!]);
        }
      }
      refreshItem();
    } catch (e) {
      print("removeItemFromCartApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  // Function to refresh data
  Future<void> refreshItem() async {
    currentPageNumber = 1;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    loadCartApis();
  }

  Future<void> loadMoreItem() async {
    if (myCartItemModel == null || myCartItemModel!.data!.items!.length < (currentPageNumber * pageSize)) {
      // No more items to load
      return;
    }
    currentPageNumber += 1;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    await getCartItemsApi();
  }

  gotoCheckOutPage() {
    bool isGuestLogin = false;
    isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
    if (isGuestLogin) {
      const WarningAlertDialog().warningAlertDialog(subtitleMessage: "Please sign in", Get.context!, () {
        Get.toNamed(RouteHelper.loginScreen);
      });
    } else {
      Get.toNamed(RouteHelper.checkOutScreen);
    }
  }

  loadCartApis() async {
    await getCartItemsApi();
    await getSubTotalPriceCartApi();
  }

  void increaseQuantity(ProductModel product) {
    product.quantity++;
    update();
  }

  void decreaseQuantity(ProductModel product) {
    if (product.quantity > 1) {
      product.quantity--;
    }
    update();
  }
}