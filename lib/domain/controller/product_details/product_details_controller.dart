import 'dart:ui';

import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/domain/controller/home/home_controller.dart';
import 'package:ShapeCom/domain/product/my_product.dart';
import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/my_cart/model/add_item_to_cart_model.dart';
import '../../../presentation/screens/my_cart/model/cart_count_model.dart';
import '../../../presentation/screens/product_details/model/favorite_model.dart';
import '../../../presentation/screens/product_details/model/get_item_details_model.dart';
import '../../../presentation/screens/product_details/model/get_related_items_model.dart';
import '../cart_controller/cartController.dart';

class ProductDetailsController extends GetxController {
  final HomeController homeController = Get.find();
  int currentIndex = 0;
  int totalRating = 214;
  int totalStock = 1454;
  String overViewText = "Running sneakers These are designed for high-impact activities such as running and jogging. They typically feature a cushioned midsole for comfort and support, as well as a durable outsole for traction.";
  String userComments = "Good shoe easy comfortable, good quality and light weighted for a good price tag as well. was delivered within two days";
  List<String> productColorName = ["Red", "Yellow", "Black", "Green"];
  ApiService apiService = ApiService(context: Get.context!);
  GetItemDetailsModel? getItemDetailsModel;
  GetRelatedItemsModel? getRelatedItemsModel;
  FavoriteModel? favoriteModel;
  int productID = 0;
  int relatedItemsCount = 0;
  bool? isLoading = true;
  int quantity = 1;
  CartCountController cartCountController = Get.put(CartCountController());

  ProductDetailsController(this.productID) {
    getItemDetailsApi(productID);
  }

  @override
  void onInit() {
    super.onInit();
    initPreference();
    getItemsInCartCountApi();
  }

  getItemDetailsApi(int id_Item) async {
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
      var requestBody = {"token": token, "lang": MyConstants.currentLanguage, "GuidUser": guidData, "Id_College": MyConstants.Id_College, "Id_Item": id_Item, "ccy": currency};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItemDetails, method: MyConstants.POST, body: requestBody);
      getItemDetailsModel = GetItemDetailsModel.fromJson(responseBody);
      if (getItemDetailsModel!.status == 1) {
        //On Success: Call GetRelatedItems API
        getRelatedItemsApi();
        /*if (getItemDetailsModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [getItemDetailsModel!.msg!]);
        }*/
      } else {
        if (getItemDetailsModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [getItemDetailsModel!.msg!]);
        }
      }
    } catch (e) {
      print("getItemDetailsApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isLoading = false;
      update();
    }
  }

  getRelatedItemsApi() async {
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
      var requestBody = {"token": token, "lang": MyConstants.currentLanguage, "GuidUser": guidData, "Id_College": MyConstants.Id_College, "Id_Item": productID, "ccy": currency};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetRelatedItems, method: MyConstants.POST, body: requestBody);
      String res=responseBody.toString();
      print("relatedItemsresponseBody ${responseBody.toString()}");
      getRelatedItemsModel = GetRelatedItemsModel.fromJson(responseBody);
      if (getRelatedItemsModel!.status == 1) {
        relatedItemsCount = getRelatedItemsModel!.data!.items!.length;
        print("relatedItemsCount $relatedItemsCount");
        /*if (getItemDetailsModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [getItemDetailsModel!.msg!]);
        }*/
      } else {
        if (getRelatedItemsModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [getRelatedItemsModel!.msg!]);
        }
      }
    } catch (e) {
      print("getRelatedItemsApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  initPreference() async {
    await MyPrefrences.init();
  }

  List<Color> productColor = [
    MyColor.colorRed,
    MyColor.colorOrange,
    MyColor.colorBlack,
    MyColor.colorGreen,
  ];

  List<String> productDesign = [
    MyImages.snickers,
    MyImages.snickers,
    MyImages.snickers,
    MyImages.snickers,
  ];

  int selectColorIndex = 0;

  List<int> reviewPercentage = [56, 85, 40, 70, 10];
  List<double> numberOfStar = [5, 4, 3, 2, 1];

  void setSelectedColor(int index) {
    selectColorIndex = index;
    update();
  }

  double productPrice() {
    return homeController.productPrice;
  }

  setCurrentIndex(int index) {
    currentIndex = index;
    update();
  }

  final List<String> imageList = [
    MyImages.productDetails,
    MyImages.headphoneBanner,
    MyImages.productDetails,
  ];

  Future<void> toggleFavorite(int id_Item) async {
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
      var requestBody = {"token": token, "lang": MyConstants.currentLanguage, "GuidUser": guidData, "Id_College": MyConstants.Id_College, "Id_Item": id_Item, "ccy": currency};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointUpdateItemFavorite, method: MyConstants.POST, body: requestBody, showProgress: false);
      favoriteModel = FavoriteModel.fromJson(responseBody);
      if (favoriteModel!.status == 1) {
        getItemDetailsModel!.data!.item!.isFavorite = favoriteModel!.data!.item!.isFavorite!;
        if (favoriteModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [favoriteModel!.msg!]);
        }
      } else {
        getItemDetailsModel!.data!.item!.isFavorite = favoriteModel!.data!.item!.isFavorite!;
        if (favoriteModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [favoriteModel!.msg!]);
        }
      }
    } catch (e) {
      print("toggleFavorite Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  void increaseQuantity() {
    quantity = quantity + 1;
    update();
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
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItemsInCartCount, method: MyConstants.POST, body: requestBody, showProgress: false);
      CartCountModel? cartCountModel = CartCountModel.fromJson(responseBody);
      if (cartCountModel.status == 1) {
        cartCountController.cartCount = cartCountModel.data!.count!.toInt();
        update();
        if (cartCountModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [cartCountModel.msg!]);
        }
      } else {
        if (cartCountModel.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [cartCountModel.msg!]);
        }
      }
    } catch (e) {
      print("ProductDetailsController getItemsInCartCountApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  addItemToCartApi() async {
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
        "Id_Item": productID,
        "GuidUser": guidData,
        "Id_College": MyConstants.Id_College,
        "qty": quantity,
        "ccy": currency,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointAddItemToCart, method: MyConstants.POST, body: requestBody, showProgress: false);
      AddItemToCartModel? addItemToCartModel = AddItemToCartModel.fromJson(responseBody);
      if (addItemToCartModel.status == 1) {
        getItemsInCartCountApi();
        if (addItemToCartModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [addItemToCartModel.msg!]);
        }
      } else {
        if (addItemToCartModel.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [addItemToCartModel.msg!]);
        }
      }
    } catch (e) {
      print("ProductDetailsController addItemToCartApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      update();
    }
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      quantity = quantity - 1;
      update();
    }
  }

  List<ProductModel> modelImageList = [];

  void loadImage(ProductModel productModel) {
    if (productModel.image.toString().contains("bag")) {
      modelImageList.addAll(MyProduct.bagList);
    } else if (productModel.image.toString().contains("watch")) {
      modelImageList.addAll(MyProduct.watchList);
    } else if (productModel.image.toString().contains("shoes")) {
      modelImageList.addAll(MyProduct.shoeList);
    } else if (productModel.image.toString().contains("mens_fashion")) {
      modelImageList.addAll(MyProduct.mensFashionList);
    } else if (productModel.image.toString().contains("head_phone")) {
      modelImageList.addAll(MyProduct.headPhoneList);
    } else if (productModel.image.toString().contains("electronics")) {
      modelImageList.addAll(MyProduct.electronicsList);
    }
  }
}
