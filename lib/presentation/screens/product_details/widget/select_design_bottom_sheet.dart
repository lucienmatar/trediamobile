import 'package:flutter/material.dart';
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

class SelectDesignBottomSheet extends StatelessWidget {
  final ProductDetailsController controller;

  const SelectDesignBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeaderRow(
          header: MyStrings.selectColor,
          bottomSpace: Dimensions.space22,
        ),
        Column(
          children: List.generate(
              controller.productColorName.length,
              (index) => InkWell(
                    onTap: () {
                      controller.setSelectedColor(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.space16),
                      child: Row(
                        children: [
                          Text(
                            controller.productColorName[index].tr,
                            style: regularDefaultInter.copyWith(color: MyColor.labelTextColor),
                          ),
                          const Spacer(),
                          CircleAvatar(
                            radius: Dimensions.space10,
                            backgroundImage: AssetImage(controller.productDesign[index]),
                            child: controller.selectColorIndex == index ? SvgPicture.asset(MyImages.check, width: Dimensions.space8, height: Dimensions.space8) : null,
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
        CustomRoundedButton(
          press: () {
            Get.back();
          },
          verticalPadding: 12,
          labelName: MyStrings.apply.tr,
          isHorizontalPadding: false,
        )
      ],
    );
  }
}
