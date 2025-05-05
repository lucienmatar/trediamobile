

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../config/utils/my_images.dart';

class CouponCodeController extends GetxController{


  List<CouponCodeModel> couponCodeList = [
    CouponCodeModel(codeType: "Flat",discountPercent: "20", couponCode: "SAVE20NOW",validDate: "Nov, 2024"),
    CouponCodeModel(codeType: "Percentage", discountPercent: "15", couponCode: "DISCOUNT15", validDate: "Dec, 2024"),
    CouponCodeModel(codeType: "Fixed Amount", discountPercent: "10", couponCode: "OFF10USD", validDate: "Jan, 2025"),
    CouponCodeModel(codeType: "Buy One Get One", discountPercent: "BOGO", couponCode: "BOGO50", validDate: "Feb, 2025"),
    CouponCodeModel(codeType: "Free Shipping", discountPercent: "0", couponCode: "FREESHIP", validDate: "Mar, 2025"),
    CouponCodeModel(codeType: "Seasonal Sale", discountPercent: "25", couponCode: "WINTER25", validDate: "Apr, 2025"),
    CouponCodeModel(codeType: "Bundle Discount", discountPercent: "20", couponCode: "BUNDLE20", validDate: "May, 2025"),
    CouponCodeModel(codeType: "Limited Time", discountPercent: "30", couponCode: "FLASH30", validDate: "Jun, 2025"),
    CouponCodeModel(codeType: "Referral Bonus", discountPercent: "15", couponCode: "REFER15", validDate: "Jul, 2025"),
    CouponCodeModel(codeType: "Minimum Purchase", discountPercent: "10", couponCode: "SPEND50SAVE10", validDate: "Aug, 2025"),
    CouponCodeModel(codeType: "New Customer", discountPercent: "5", couponCode: "WELCOME5", validDate: "Sep, 2025"),
  ];

}

class CouponCodeModel{

  String codeType;
  String discountPercent;
  String validDate;
  String couponCode;

  CouponCodeModel({
    this.codeType = "",
    this.discountPercent = "",
    this.validDate = "",
    this.couponCode = "",
  });

}