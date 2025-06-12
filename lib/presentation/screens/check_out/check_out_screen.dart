import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/check_out/check_out_controller.dart';
import 'package:ShapeCom/presentation/components/alert-dialog/custom_alert_dialog.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/card/custom_card.dart';
import 'package:ShapeCom/presentation/components/divider/custom_divider.dart';
import 'package:ShapeCom/presentation/components/text/cart_sub_text.dart';
import 'package:ShapeCom/presentation/screens/check_out/widget/check_out_custom_cart.dart';
import 'package:ShapeCom/presentation/screens/check_out/widget/online_payment_bottom_sheet.dart';
import 'package:ShapeCom/presentation/screens/check_out/widget/order_summary_fee_widget.dart';
import 'package:ShapeCom/presentation/screens/check_out/widget/shipping_bottom_sheet.dart';
import 'package:ShapeCom/presentation/screens/my_order/my_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/utils/dimensions.dart';
import '../../components/bottom-sheet/custom_bottom_sheet.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  var checkOutController = Get.put(CheckOutController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckOutController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.backGroundScreenColor,
        appBar: CustomAppBar(
          title: MyStrings.checkOut,
          leadingImage: MyImages.backButton,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.space16),
          child: Column(
            children: [
              CheckOutCustomCart(
                  title: MyStrings.shippingMethod,
                  subTitle: checkOutController.currentShippingMethod,
                  press: () {
                    checkOutController.getShippingMethodsApi(callback: () {
                      CustomBottomSheet(child: GetBuilder<CheckOutController>(builder: (controller) => ShippingBottomSheet(controller: controller))).customBottomSheet(context);
                    });
                  }),
              Visibility(
                  visible: checkOutController.isShippingAddressShow,
                  child: CheckOutCustomCart(
                      title: MyStrings.shippingAddress,
                      subTitle: MyConstants.currentShippingAddress,
                      press: () {
                        //Get.toNamed(RouteHelper.shippingAddressScreen)
                        Get.toNamed(RouteHelper.shippingAddressScreen)!.then((result) {
                          checkOutController.getOrderSummaryBeforeCheckoutApi();
                        });
                      })),
              Visibility(
                visible: checkOutController.isPaymentMethodShow,
                child: CheckOutCustomCart(
                    title: MyStrings.paymentMethod,
                    subTitle: checkOutController.currentPaymentMethod,
                    press: () {
                      checkOutController.getPaymentMethodsApi(callback: () {
                        CustomBottomSheet(
                            child: GetBuilder<CheckOutController>(
                                builder: (controller) => OnlinePaymentBottomSheet(
                                      controller: controller,
                                    ))).customBottomSheet(context);
                      });
                    }),
              ),
              CustomCard(
                  isPress: true,
                  onPressed: () {},
                  paddingLeft: Dimensions.space15,
                  paddingRight: Dimensions.space11,
                  paddingTop: Dimensions.space15,
                  paddingBottom: Dimensions.space20,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyStrings.orderSummary, style: semiBoldLargeInter),
                      SizedBox(height: 5),
                      checkOutController.isShimmerShow == false
                          ? checkOutController.cartCount > 0
                              ? ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: checkOutController.cartCount,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: Dimensions.space5),
                                      color: MyColor.colorWhite,
                                      child: buildCartWidget(index),
                                    );
                                    /*return Container(
                                      color: MyColor.colorWhite,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: CartSubText(text: "${checkOutController.myCartItemModel!.data!.items![index].qty} X ${checkOutController.myCartItemModel!.data!.items![index].itemName}")),
                                            CartSubText(
                                                text: '${checkOutController.myCartItemModel!.data!.items![index].sellingCurrencyLogo}'
                                                    '${NumberFormat.currency(locale: 'en_GB', symbol: '', decimalDigits: checkOutController.myCartItemModel!.data!.items![index].sellingCurrencyLogo != '\$' && checkOutController.myCartItemModel!.data!.items![index].sellingCurrencyLogo != '€' ? 0 : 2).format(checkOutController.myCartItemModel!.data!.items![index].sumOnlinePrice)}'),
                                          ],
                                        ),
                                      ),
                                    );*/
                                  })
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Center(child: Text(checkOutController.noDataFound, style: semiBoldLarge.copyWith(fontSize: 14), maxLines: 1)),
                                    ],
                                  ),
                                )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Container(
                                  color: MyColor.colorWhite,
                                  margin: const EdgeInsets.only(bottom: Dimensions.space4),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                                    title: buildShimmerCartWidget(),
                                  ),
                                );
                              }),
                      /* abp
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CartSubText(text: MyStrings.cartSubtext.tr),
                          CartSubText(text: "\$${controller.subTotal}"),
                        ],
                      ),*/
                      const CustomDivider(dividerHeight: 1.5),
                      OrderSummaryFeeWidget(
                        title: MyStrings.subTotal.tr,
                        amount: controller.subTotal,
                        SellingCurrencyLogo: checkOutController.SellingCurrencyLogo,
                      ),
                      OrderSummaryFeeWidget(title: MyStrings.discount, amount: controller.discount, SellingCurrencyLogo: checkOutController.SellingCurrencyLogo),
                      Visibility(visible: checkOutController.isDeliveryFeeShow, child: OrderSummaryFeeWidget(title: MyStrings.deliveryFee, amount: controller.deliveryFee, SellingCurrencyLogo: checkOutController.SellingCurrencyLogo)),
                      OrderSummaryFeeWidget(title: MyStrings.vat.tr, amount: controller.vat, SellingCurrencyLogo: checkOutController.SellingCurrencyLogo),
                      OrderSummaryFeeWidget(title: MyStrings.total, amount: controller.total, SellingCurrencyLogo: checkOutController.SellingCurrencyLogo),
                    ],
                  ))
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: MyColor.colorWhite,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space10, vertical: Dimensions.space14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${MyStrings.total} : \$${controller.total}",
                style: semiBoldLargeInter,
              ),
              const SizedBox(
                height: 6,
              ),
              RoundedButton(
                  color: checkOutController.isPlaceOrderButtonShow ? MyColor.primaryColor : MyColor.colorLightGrey,
                  text: MyStrings.placeOrder,
                  press: () {
                    if (checkOutController.isPlaceOrderButtonShow) {
                      checkOutController.placeOrderApi(callback: () {
                        CustomAlertDialog(
                            child: Column(
                          children: [
                            Image.asset(
                              MyImages.checkOut,
                              width: 70,
                              height: 70,
                              color: MyColor.primaryColor,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              MyStrings.orderPlacedSuccessful,
                              style: mediumLarge.copyWith(color: MyColor.colorBlack),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: RoundedButton(
                                text: MyStrings.ok.tr,
                                verticalPadding: 15,
                                press: () {
                                  Get.offAllNamed(RouteHelper.trackOrderScreen, arguments: {"orderID": checkOutController.placeOrderModel?.data?.order?.orderID ?? 0, "orderNO": checkOutController.placeOrderModel?.data?.order?.orderNO ?? 0, "purchaseDate": checkOutController.placeOrderModel?.data?.order?.purchaseDate ?? ""});
                                  //Get.offAll(const MyOrderScreen(customRoute: RouteHelper.bottomNavBar));
                                },
                              ),
                            )
                          ],
                        )).customAlertDialog(context);
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCartWidget(int index) {
    return Row(
      children: [
        Container(
          width: 50,
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space2, vertical: Dimensions.space2),
          decoration: BoxDecoration(
            color: MyColor.colorLightGrey,
            borderRadius: BorderRadius.circular(Dimensions.space6),
          ),
          child: Image.network(width: 30, height: 50, "${MyConstants.imageBaseURL}${checkOutController.myCartItemModel?.data?.items?[index].imageURL ?? ""}"),
        ),
        const SizedBox(width: Dimensions.space16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(checkOutController.myCartItemModel?.data?.items?[index].itemName ?? "", style: semiBoldSmall, maxLines: 1),
                  Text(
                    '${checkOutController.myCartItemModel?.data?.items?[index].sellingCurrencyLogo ?? ""}'
                    '${NumberFormat.currency(locale: 'en_GB', symbol: '', decimalDigits: checkOutController.myCartItemModel?.data?.items?[index].sellingCurrencyLogo != '\$' && checkOutController.myCartItemModel?.data?.items?[index].sellingCurrencyLogo != '€' ? 0 : 2).format(checkOutController.myCartItemModel?.data?.items?[index].sumOnlinePrice ?? 0)}',
                    style: semiBoldSmall.copyWith(color: MyColor.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(checkOutController.myCartItemModel?.data?.items?[index].qty.toString() ?? "0", style: semiBoldSmall, maxLines: 1),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${checkOutController.myCartItemModel?.data?.items?[index].sellingCurrencyLogo ?? ""}'
                    '${NumberFormat.currency(locale: 'en_GB', symbol: '', decimalDigits: checkOutController.myCartItemModel?.data?.items?[index].sellingCurrencyLogo != '\$' && checkOutController.myCartItemModel?.data?.items?[index].sellingCurrencyLogo != '€' ? 0 : 2).format(checkOutController.myCartItemModel?.data?.items?[index].sumOnlinePriceBeforeDiscount ?? 0)}',
                    style: semiBoldSmall.copyWith(decoration: TextDecoration.lineThrough, color: MyColor.bodyTextColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildShimmerCartWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CartSubText(text: "     "),
          CartSubText(text: "     "),
        ],
      ),
    );
  }
}
