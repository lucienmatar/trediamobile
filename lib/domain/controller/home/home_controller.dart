import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/my_cart/model/add_item_to_cart_model.dart';
import '../../../presentation/screens/my_cart/model/get_item_model.dart';
import '../../product/my_product.dart';
import '../bottom nav bar/bottom_nav_bar_controller.dart';
import '../cart_controller/cartController.dart';

class HomeController extends GetxController {
  int carouselCurrentIndex = 0;
  final CarouselController carouselController = CarouselController();
  TextEditingController searchController = TextEditingController();
  final List<String> imageList = [
    MyImages.carousel,
    MyImages.headphoneBanner,
    MyImages.carousel,
  ];
  int visibleIndex = -1;
  int totalRating = 214;
  double productPrice = 280;
  List<int> productSize = [12, 13, 30, 45];
  List<String> productSizeName = ["D", "H", "M", "S"];
  ApiService apiService = ApiService(context: Get.context!);
  String? itemName = "";
  String? itemCategories = "";
  String? currency = "LBP";
  double? minimumPrice = 0;
  double? maximumPrice = 0;
  int currentPageNumber = 1;
  int pageSize = 10;
  GetItemModel? getItemModel;
  List<ProductModel> productModelList = [];
  int productCount = 0;
  int filtersCount = 0;
  CartCountController cartCountController = Get.put(CartCountController());
  bool isShimmerShow = true;
  bool isLoadingMore = false;
  bool isLastPage = false;


  @override
  void onInit() {
    super.onInit();
    initPreference();
    refreshItemAndCartCount();
  }

  refreshItemAndCartCount() async {
    await getItemsApi();
    await cartCountController.getItemsInCartCountApi();
  }

  getItemsApi() async {
    try {
      isShimmerShow = true;
      update();
      bool isGuestLogin = false;
      currency = MyPrefrences.getString(MyPrefrences.currency) ?? "LBP";
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
      print("MyConstants.filtersApplied ${MyConstants.filtersApplied}");
      if (MyConstants.filtersApplied) {
        itemCategories = MyConstants.filtersCategories;
        currency = MyConstants.filtersCurrency;
        minimumPrice = MyConstants.filtersRangeStartValue;
        maximumPrice = MyConstants.filtersRangeEndValue;
      }
      var requestBody = {
        "Id_College": MyConstants.Id_College,
        "token": token,
        "GuidUser": guidData,
        "lang": MyConstants.currentLanguage,
        "itmName": itemName,
        "stkCategories": itemCategories,
        "priceRangeFrom": minimumPrice,
        "priceRangeTo": maximumPrice,
        "ccy": currency,
        "pageNumber": currentPageNumber,
        "pageSize": pageSize,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItems, method: MyConstants.POST, body: requestBody, showProgress: false);
      getItemModel = GetItemModel.fromJson(responseBody);
      if (getItemModel!.status == 1) {
        if (getItemModel!.data!.items!.isNotEmpty) {
          print("getItemModel items is not empty");
          filtersCount = getItemModel!.data!.count!.toInt();
          productCount = getItemModel!.data!.items!.length;
          for (int i = 0; i < productCount; i++) {
            String imgURL = "${MyConstants.imageBaseURL}${getItemModel!.data!.items![i].imageURL!}";
            ProductModel productModel = ProductModel(image: imgURL, brand: getItemModel!.data!.items![i].categoryName!, title: getItemModel!.data!.items![i].itemName!, description: getItemModel!.data!.items![i].onlineDetails!, onlinePriceBeforeDiscount: getItemModel!.data!.items![i].onlinePriceBeforeDiscount!.toDouble(), price: getItemModel!.data!.items![i].onlinePrice!.toDouble(), sellingCurrencyLogo: getItemModel!.data!.items![i].sellingCurrencyLogo!, productID: getItemModel!.data!.items![i].idItem!.toInt());
            productModelList.add(productModel);
          }
          /*if (productModelList.isNotEmpty) {
            print("productModelList length ${productModelList.length}");
          }*/
          /*if (getItemModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [getItemModel.msg!]);
        }*/
        } else {
          productCount = 0;
          print("getItemModel items is empty");
        }
      } else {
        if (getItemModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [getItemModel!.msg!]);
        }
      }
    } catch (e) {
      print("getItemsApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isShimmerShow = false;
      update();
    }
  }

  Future<void> loadMoreItems() async {
    if (isLoadingMore || isLastPage) return;

    isLoadingMore = true;
    currentPageNumber++; // Load next page

    try {
      bool isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token = isGuestLogin ? null : MyPrefrences.getString(MyPrefrences.token) ?? "";
      String? guidData = isGuestLogin ? MyPrefrences.getString(MyPrefrences.guestGuidUser) : MyPrefrences.getString(MyPrefrences.guidUser);
      currency = MyPrefrences.getString(MyPrefrences.currency) ?? "LBP";
      if (MyConstants.filtersApplied) {
        itemCategories = MyConstants.filtersCategories;
        currency = MyConstants.filtersCurrency;
        minimumPrice = MyConstants.filtersRangeStartValue;
        maximumPrice = MyConstants.filtersRangeEndValue;
      }

      var requestBody = {
        "Id_College": MyConstants.Id_College,
        "token": token,
        "GuidUser": guidData,
        "lang": MyConstants.currentLanguage,
        "itmName": itemName,
        "stkCategories": itemCategories,
        "priceRangeFrom": minimumPrice,
        "priceRangeTo": maximumPrice,
        "ccy": currency,
        "pageNumber": currentPageNumber,
        "pageSize": pageSize,
      };

      dynamic responseBody = await apiService.makeRequest(
        endPoint: MyConstants.endpointGetItems,
        method: MyConstants.POST,
        body: requestBody,
        showProgress: true,
      );

      getItemModel = GetItemModel.fromJson(responseBody);

      if (getItemModel!.status == 1) {
        var items = getItemModel!.data!.items!;
        if (items.isEmpty) {
          isLastPage = true;
        } else {
          filtersCount = getItemModel!.data!.count!.toInt();
          productCount = items.length;

          for (var item in items) {
            productModelList.add(ProductModel(
              image: "${MyConstants.imageBaseURL}${item.imageURL}",
              brand: item.categoryName!,
              title: item.itemName!,
              description: item.onlineDetails!,
              onlinePriceBeforeDiscount: item.onlinePriceBeforeDiscount!.toDouble(),
              price: item.onlinePrice!.toDouble(),
              sellingCurrencyLogo: item.sellingCurrencyLogo!,
              productID: item.idItem!.toInt(),
            ));
          }
        }
      } else {
        if (getItemModel?.msg?.isNotEmpty ?? false) {
          CustomSnackBar.error(errorList: [getItemModel!.msg!]);
        }
      }
    } catch (e) {
      print("loadMoreItems Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isLoadingMore = false;
      update();
    }
  }

  addItemToCartApi(int id_Item, int quantity) async {
    try {
      bool isGuestLogin = false;
      currency = MyPrefrences.getString(MyPrefrences.currency) ?? "LBP";
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
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointAddItemToCart, method: MyConstants.POST, body: requestBody, showProgress: false);
      AddItemToCartModel? addItemToCartModel = AddItemToCartModel.fromJson(responseBody);
      if (addItemToCartModel!.status == 1) {
        cartCountController.getItemsInCartCountApi();
        if (addItemToCartModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [addItemToCartModel!.msg!]);
        }
      } else {
        if (addItemToCartModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [addItemToCartModel!.msg!]);
        }
      }
    } catch (e) {
      print("addItemToCartApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  // Function to refresh data
  Future<void> refreshItem() async {
    currentPageNumber = 1;
    isLastPage = false;
    productModelList.clear();
    await Future.delayed(const Duration(seconds: 1));
    refreshItemAndCartCount();
  }

  applyFilters() {
    //call get item api to show filtered results
    currentPageNumber = 0;
    productModelList = [];
    refreshItem();
  }

  resetFilters() {
    MyConstants.filtersApplied = false;
    MyConstants.filtersCategories = "";
    MyConstants.filtersCurrency = "";
    MyConstants.filtersRangeStartValue = 0;
    MyConstants.filtersRangeEndValue = 0;
    productModelList = [];
    currentPageNumber = 0;
    filtersCount = 0;
    itemCategories = "";
    itemName = "";
    currency = "";
    minimumPrice = 0;
    maximumPrice = 0;
    searchController.text = "";
    //Get.toNamed(RouteHelper.filterScreen);
    update();
    refreshItem();
  }

  initPreference() async {
    await MyPrefrences.init();
  }

  setCurrentIndex(int index) {
    carouselCurrentIndex = index;
    update();
  }

  toggleVisibility(int visibleIndex) {
    if (visibleIndex == this.visibleIndex) {
      this.visibleIndex = -1;
      update();
      return;
    }
    this.visibleIndex = visibleIndex;
    update();
  }

  int cartCount = 0;
  void manageCartCount() {
    cartCount++;
  }
}