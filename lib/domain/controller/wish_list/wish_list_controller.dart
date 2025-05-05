import 'package:get/get.dart';

import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/product_details/model/favorite_model.dart';
import '../../../presentation/screens/wish_list/model/favorite_item_model.dart';

class WishListController extends GetxController {
  double productPrice = 220.00;
  int totalRating = 214;
  int currentPageNumber = 1;
  int favoriteItemCount = 0;
  int pageSize = 10;
  String? noDataFound = "";
  ApiService apiService = ApiService(context: Get.context!);
  FavoriteItemModel? favoriteItemModel;
  bool isShimmerShow = true;

  @override
  void onInit() {
    super.onInit();
    getItemsInFavoritesApi();
  }

  getItemsInFavoritesApi() async {
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
        "pageNumber": currentPageNumber,
        "pageSize": pageSize,
      };
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetItemsInFavorites, method: MyConstants.POST, body: requestBody, showProgress: false);
      favoriteItemModel = FavoriteItemModel.fromJson(responseBody);
      if (favoriteItemModel!.status == 1) {
        favoriteItemCount = favoriteItemModel!.data!.items!.length;
      } else {
        favoriteItemCount = 0;
        noDataFound = favoriteItemModel!.msg;
      }
    } catch (e) {
      print("getItemsInFavoritesApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isShimmerShow = false;
      update();
    }
  }

  Future<void> toggleFavorite(int id_Item) async {
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
      var requestBody = {"token": token, "lang": MyConstants.currentLanguage, "GuidUser": guidData, "Id_College": MyConstants.Id_College, "Id_Item": id_Item, "ccy": currency};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointUpdateItemFavorite, method: MyConstants.POST, body: requestBody);
      FavoriteModel favoriteModel = FavoriteModel.fromJson(responseBody);
      if (favoriteModel.status == 1) {
        if (favoriteModel.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [favoriteModel.msg!]);
        }
      } else {
        if (favoriteModel.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [favoriteModel.msg!]);
        }
      }
      getItemsInFavoritesApi();
    } catch (e) {
      print("WishListController toggleFavorite Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    } finally {
      isShimmerShow = false;
      update();
    }
  }

  // Function to refresh data
  Future<void> refreshItem() async {
    currentPageNumber = 1;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    getItemsInFavoritesApi();
  }

  // Function to refresh data
  Future<void> loadMoreItem() async {
    currentPageNumber = currentPageNumber + 1;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    getItemsInFavoritesApi();
  }
}
