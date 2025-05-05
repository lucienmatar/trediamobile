

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../config/utils/my_images.dart';

class LanguageController extends GetxController{

  int selectedIndex = 0;
  void changeSelectedIndex(int index) {
    selectedIndex = index;
    update();
  }

  List<String> languageList = ["English","Arabic", "Bangla", "Spanish"];

  List<String> languageImage = [
    "assets/images/flag/usa.jpg",
    "assets/images/flag/arabic.jpg",
    "assets/images/flag/bangla.png",
    "assets/images/flag/spanish.png",
  ];

}