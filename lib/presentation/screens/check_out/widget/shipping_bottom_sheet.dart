import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:ShapeCom/domain/controller/check_out/check_out_controller.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/checkbox/circular_check_box.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/product_details/product_details_controller.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/buttons/custom_rounded_button.dart';

class ShippingBottomSheet extends StatelessWidget {
  final CheckOutController controller;

  const ShippingBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeaderRow(
          header: MyStrings.shippingMethod,
          bottomSpace: Dimensions.space22,
        ),
        Column(
          children: List.generate(
              controller.shippingMethod.length,
              (index) => InkWell(
                    onTap: () {
                      controller.setCurrentShipping(index, controller.shippingMethod[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.space16),
                      child: Row(
                        children: [
                          Text(
                            controller.shippingMethod[index],
                            style: regularDefaultInter.copyWith(color: MyColor.labelTextColor),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            height: Dimensions.space18,
                            width: Dimensions.space18,
                            decoration: BoxDecoration(color: controller.currentShipping == index ? MyColor.primaryColor : null, border: controller.currentShipping != index ? Border.all(color: MyColor.colorGrey.withOpacity(.6), width: 1) : null, shape: BoxShape.circle),
                            child: controller.currentShipping == index ? SvgPicture.asset(MyImages.check) : const SizedBox.shrink(),
                          )
                        ],
                      ),
                    ),
                  )),
        ),
        RoundedButton(
          press: () {
            controller.changeShipping();
            Get.back();
          },
          verticalPadding: 15,
          text: MyStrings.apply.tr,
        )
      ],
    );
  }
}
