import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
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
import 'package:get/get.dart';

import '../../../config/utils/dimensions.dart';
import '../../components/bottom-sheet/custom_bottom_sheet.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  void initState() {
    final controller = Get.put(CheckOutController());
    super.initState();
  }

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
              CheckOutCustomCart(title: MyStrings.shippingAddress, subTitle: MyStrings.addShippingAddress, press: () => Get.toNamed(RouteHelper.shippingAddressScreen)),
              CheckOutCustomCart(
                  title: MyStrings.paymentMethod,
                  subTitle: MyStrings.choosePaymentMethod,
                  press: () {
                    CustomBottomSheet(
                        child: GetBuilder<CheckOutController>(
                            builder: (controller) => OnlinePaymentBottomSheet(
                                  controller: controller,
                                ))).customBottomSheet(context);
                  }),
              CheckOutCustomCart(
                  title: MyStrings.shippingMethod,
                  subTitle: MyStrings.chooseShippingMethod,
                  press: () {
                    CustomBottomSheet(child: GetBuilder<CheckOutController>(builder: (controller) => ShippingBottomSheet(controller: controller))).customBottomSheet(context);
                  }),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CartSubText(text: MyStrings.cartSubtext.tr),
                          CartSubText(text: "\$${controller.subTotal}"),
                        ],
                      ),
                      const CustomDivider(dividerHeight: 1.5),
                      OrderSummaryFeeWidget(title: MyStrings.subTotal.tr, amount: controller.subTotal),
                      OrderSummaryFeeWidget(title: MyStrings.discount, amount: controller.discount),
                      OrderSummaryFeeWidget(title: MyStrings.deliveryFee, amount: controller.deliveryFee),
                      OrderSummaryFeeWidget(title: MyStrings.vat.tr, amount: controller.vat),
                      OrderSummaryFeeWidget(title: MyStrings.total, amount: controller.total),
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
                  text: MyStrings.placeOrder,
                  press: () {
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
                              Get.offAll(const MyOrderScreen(customRoute: RouteHelper.bottomNavBar));
                            },
                          ),
                        )
                      ],
                    )).customAlertDialog(context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
