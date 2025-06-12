import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/domain/controller/cart_controller/cartController.dart';
import 'package:ShapeCom/domain/controller/track_order/track_order_controller.dart';
import 'package:ShapeCom/presentation/screens/track_order/widget/time_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/route/route.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../../config/utils/style.dart';
import '../../../config/utils/util.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/divider/custom_divider.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({
    super.key,
  });

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  var orderID;
  var orderNO;
  var purchaseDate;
  String formattedDate = "";
  final orderDetailsController = Get.put(TrackOrderController());

  @override
  Widget build(BuildContext context) {
    try {
      orderID = Get.arguments["orderID"];
      orderNO = Get.arguments["orderNO"];
      purchaseDate = Get.arguments["purchaseDate"];
      print("orderID $orderID");
      print("orderNO $orderNO");
      final purchaseDateString = purchaseDate;

      // Parse and format the date
      if (purchaseDateString.isNotEmpty) {
        try {
          final dateTime = DateTime.parse(purchaseDateString); // Parse the API date string
          formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime); // Format to date, hour, minute
        } catch (e) {
          formattedDate = purchaseDateString; // Fallback to raw string if parsing fails
        }
      }
      orderDetailsController.getOrderDetailsApi(orderID);
    } catch (e) {}
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(RouteHelper.myOrderScreen);
        return true;
      },
      child: GetBuilder<TrackOrderController>(
        builder: (controller) => Scaffold(
          backgroundColor: MyColor.backGroundScreenColor,
          appBar: CustomAppBar(
            isShowBackBtn: true,
            actionPress: () {},
            fromAuth: false,
            isShowSingleActionBtn: false,
            isProfileCompleted: false,
            bgColor: MyColor.getAppBarColor(),
            title: MyStrings.orderDetails,
            leadingImage: MyImages.backButton,
            isHandleBack: true,
            onBackPressed: () {
              Get.offNamed(RouteHelper.myOrderScreen);
            },
          ),
          body: SingleChildScrollView(
            padding: Dimensions.trackOrderPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space15, bottom: Dimensions.space10),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                    boxShadow: MyUtils.getCardShadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: MyImages.splashLogo,
                              image: 'https://example.com/image.jpg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) => Image.asset(MyImages.splashLogo, width: 40, height: 40, fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                orderNO.toString() ?? "",
                                style: semiBoldLargeInter,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                formattedDate,
                                style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor, height: 1.7, wordSpacing: 2, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: MyColor.cartSubtitleColor),
                          SizedBox(width: 8),
                          Text(
                            orderDetailsController.orderDetailsModel?.data?.orderSummary?.addressDetails ?? "In-Store Pickup",
                            style: regularDefault,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space15, bottom: Dimensions.space10),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                    boxShadow: MyUtils.getCardShadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MyStrings.yourOrder,
                        style: semiBoldLargeInter,
                      ),
                      SizedBox(height: 10),
                      (orderDetailsController.orderDetailsModel?.data?.orderSummary?.orderStatus?.toLowerCase() ?? "") == MyStrings.delivered.toLowerCase()
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: MyColor.deliveryTextColor.withOpacity(0.1), // Light green background with alpha
                                borderRadius: BorderRadius.circular(20), // Rounded pill shape
                              ),
                              child: Text(
                                MyStrings.delivered,
                                style: regularDefault.copyWith(color: MyColor.deliveryTextColor),
                              ),
                            )
                          : Offstage(),
                      (orderDetailsController.orderDetailsModel?.data?.orderSummary?.orderStatus?.toLowerCase() ?? "") == MyStrings.pending.toLowerCase()
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: MyColor.inProgressTextColor.withOpacity(0.1), // Light green background with alpha
                                borderRadius: BorderRadius.circular(20), // Rounded pill shape
                              ),
                              child: Text(
                                MyStrings.pending,
                                style: regularDefault.copyWith(color: MyColor.inProgressTextColor),
                              ),
                            )
                          : Offstage(),
                      SizedBox(height: 10),
                      (orderDetailsController.orderDetailsModel?.data?.orderItems?.isNotEmpty ?? false)
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: orderDetailsController.orderDetailsModel!.data!.orderItems!.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    ClipOval(
                                      child: FadeInImage.assetNetwork(
                                        placeholder: MyImages.splashLogo,
                                        image: "${MyConstants.imageBaseURL}${orderDetailsController.orderDetailsModel?.data?.orderItems?[index].imageURL ?? ""}",
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder: (context, error, stackTrace) => Image.asset(MyImages.splashLogo, width: 70, height: 70, fit: BoxFit.cover),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                orderDetailsController.orderDetailsModel?.data?.orderItems?[index].itemName ?? "",
                                                style: regularDefaultInter.copyWith(fontSize: 12, color: MyColor.primaryTextColor),
                                              ),
                                              Text(
                                                "${orderDetailsController.orderDetailsModel?.data?.orderItems?[index].sellingCurrencyLogo ?? ""} ${orderDetailsController.orderDetailsModel?.data?.orderItems?[index].totalPrice ?? ""}",
                                                style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                orderDetailsController.orderDetailsModel?.data?.orderItems?[index].qty?.toInt().toString() ?? "",
                                                style: regularDefaultInter.copyWith(color: MyColor.primaryColor, height: 1.7, wordSpacing: 2, fontSize: 12),
                                              ),
                                              Text(
                                                orderDetailsController.orderDetailsModel?.data?.orderItems?[index].totalPriceBeforeDiscount.toString() ?? "",
                                                style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Offstage(),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space15, bottom: Dimensions.space10),
                  decoration: BoxDecoration(
                    color: MyColor.colorWhite,
                    borderRadius: BorderRadius.circular(Dimensions.cardRadius),
                    boxShadow: MyUtils.getCardShadow(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            MyStrings.subTotal,
                            style: regularDefaultInter.copyWith(fontSize: 12, color: MyColor.primaryTextColor),
                          ),
                          Text(
                            "${orderDetailsController.orderDetailsModel?.data?.orderSummary?.sellingCurrencyLogo ?? ""} ${orderDetailsController.orderDetailsModel?.data?.orderSummary?.subtotal ?? ""}",
                            style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            MyStrings.deliveryCharge,
                            style: regularDefaultInter.copyWith(fontSize: 12, color: MyColor.primaryTextColor),
                          ),
                          Text(
                            "${orderDetailsController.orderDetailsModel?.data?.orderSummary?.sellingCurrencyLogo ?? ""} ${orderDetailsController.orderDetailsModel?.data?.orderSummary?.shippingFee ?? ""}",
                            style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            MyStrings.vat,
                            style: regularDefaultInter.copyWith(fontSize: 12, color: MyColor.primaryTextColor),
                          ),
                          Text(
                            "${orderDetailsController.orderDetailsModel?.data?.orderSummary?.sellingCurrencyLogo ?? ""} ${orderDetailsController.orderDetailsModel?.data?.orderSummary?.vat ?? ""}",
                            style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor),
                          ),
                        ],
                      ),
                      const CustomDivider(dividerHeight: 1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            MyStrings.total,
                            style: semiBoldLarge,
                          ),
                          Text(
                            "${orderDetailsController.orderDetailsModel?.data?.orderSummary?.sellingCurrencyLogo ?? ""} ${orderDetailsController.orderDetailsModel?.data?.orderSummary?.total ?? ""}",
                            style: semiBoldLarge,
                          ),
                        ],
                      ),
                      const CustomDivider(dividerHeight: 1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            MyStrings.paidWith,
                            style: regularDefaultInter.copyWith(fontSize: 12, color: MyColor.primaryTextColor),
                          ),
                          Text(
                            orderDetailsController.orderDetailsModel?.data?.orderSummary?.paymentMethod ?? "",
                            style: regularDefaultInter.copyWith(color: MyColor.cartSubtitleColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
