import 'package:ShapeCom/config/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/my_color.dart';

import 'my_strings.dart';

class MyUtils {
  /// **Get Address From Lat - Long
  static Future<String> getAddressFromLatLong(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0]; // Take the first result

      // Construct the address from available fields
      String address = "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      return address;
    } catch (e) {
      print("Error occurred: $e");
      return "Unable to get address";
    }
  }

  static Widget noRecordsFoundWidget() {
    return Card(
      color: MyColor.colorWhite,
      surfaceTintColor: MyColor.colorWhite,
      shadowColor: MyColor.naturalLight,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          MyStrings.noRecordsFound,
          style: mediumLarge.copyWith(color: MyColor.primaryTextColor),
        ),
      ),
    );
  }

  static splashScreen() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: MyColor.colorWhite, statusBarIconBrightness: Brightness.dark, systemNavigationBarColor: MyColor.colorWhite, systemNavigationBarIconBrightness: Brightness.dark));
  }

  static allScreen() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: MyColor.getPrimaryColor(), statusBarIconBrightness: Brightness.light, systemNavigationBarColor: MyColor.colorWhite, systemNavigationBarIconBrightness: Brightness.dark));
  }

  static dynamic getShadow() {
    return [
      BoxShadow(blurRadius: 15.0, offset: const Offset(0, 25), color: Colors.grey.shade500.withOpacity(0.6), spreadRadius: -35.0),
    ];
  }

  static dynamic getBottomSheetShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.08),
        spreadRadius: 3,
        blurRadius: 4,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static dynamic getCardShadow() {
    return [
      BoxShadow(
        color: Colors.grey.shade400.withOpacity(0.05),
        spreadRadius: 2,
        blurRadius: 2,
        offset: const Offset(0, 3),
      ),
    ];
  }

  static getOperationTitle(String value) {
    String number = value;
    RegExp regExp = RegExp(r'^(\d+)(\w+)$');
    Match? match = regExp.firstMatch(number);
    if (match != null) {
      String? num = match.group(1) ?? '';
      String? unit = match.group(2) ?? '';
      String title = '${MyStrings.last.tr} $num ${unit.capitalizeFirst}';
      return title.tr;
    } else {
      return value.tr;
    }
  }
}
