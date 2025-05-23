import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';

class LanguageController extends GetxController {
  int selectedIndex = 0;
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    if (index == 1) {
      MyPrefrences.saveString(MyPrefrences.language, "Arabic");
    } else {
      MyPrefrences.saveString(MyPrefrences.language, languageList[index]);
    }
    CustomSnackBar.success(successList: [MyStrings.languageUpdated]);
    update();
  }

  List<String> languageList = ["English", "العربية", "French"];

  List<String> languageImage = [
    "assets/images/flag/usa.jpg",
    "assets/images/flag/arabic.jpg",
    MyImages.frenchFlag,
  ];
}
