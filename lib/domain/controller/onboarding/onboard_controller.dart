import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:get/get.dart';

class OnboardController extends GetxController {
  int currentIndex = 0;
  PageController pageController = PageController();
  void changeCurrentIndex(int index) {
    currentIndex = index;
    update();
  }

  List<String> onboardContentList = [];
  bool isLoading = false;
  List<String> onBoardImage = [];
  List<String> onboardImageList = [
    MyImages.onboardImage_1,
    MyImages.onboardImage_2,
    MyImages.onboardImage_3,
  ];
  List<String> onboardSubTitleList = [
    MyStrings.onboardSubTitleListItem1,
    MyStrings.onboardSubTitleListItem2,
    MyStrings.onboardSubTitleListItem3,
  ];
  List<String> onboardTitleList = ["${MyStrings.welcomeTo} ${MyStrings.appName}", MyStrings.discoverDeals, MyStrings.shopSmartShopEasy];
}
