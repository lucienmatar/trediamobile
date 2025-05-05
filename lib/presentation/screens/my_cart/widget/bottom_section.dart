import 'package:flutter/material.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/presentation/screens/my_cart/widget/coupon_code_bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/my_cart/my_cart_controller.dart';
import '../../../components/bottom-sheet/custom_bottom_sheet.dart';
import '../../../components/buttons/rounded_border_container.dart';

class BottomSection extends StatelessWidget {
  final MyCartController controller;

  const BottomSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: Dimensions.myCartBottomPadding,
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                CustomBottomSheet(child: GetBuilder<MyCartController>(builder: (controller) => CouponCodeBottomSheet(controller: controller))).customBottomSheet(context);
              },
              child: Text(MyStrings.applyCopun, style: boldDefault.copyWith(color: MyColor.primaryColor)),
            ),
            const Spacer(),
            Text("${MyStrings.subTotal} : \$${controller.subTotal}", style: semiBoldLargeInter.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(width: Dimensions.space12),
            InkWell(
              onTap: () => Get.toNamed(RouteHelper.checkOutScreen),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: MyColor.primaryColor, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  MyStrings.checkOut.tr,
                  style: regularDefault.copyWith(color: MyColor.colorWhite),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
