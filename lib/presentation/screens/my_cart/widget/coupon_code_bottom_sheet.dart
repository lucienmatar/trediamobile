import 'package:flutter/material.dart';
import 'package:ShapeCom/domain/controller/my_cart/my_cart_controller.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ShapeCom/presentation/screens/my_cart/my_cart_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/product_details/product_details_controller.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/buttons/rounded_border_container.dart';
import '../../../components/buttons/custom_rounded_button.dart';

class CouponCodeBottomSheet extends StatelessWidget {
  final MyCartController controller;

  const CouponCodeBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BottomSheetHeaderRow(
          header: MyStrings.applyCopun,
          bottomSpace: Dimensions.space22,
          isTopIndicator: false,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: controller.couponCodeController,
                textInputType: TextInputType.name,
                focusNode: controller.couponCodeFocusNode,
                labelText: MyStrings.couponCode,
                animatedLabel: true,
                needOutlineBorder: true,
                onChanged: (value) {},
                onSuffixTap: () {},
                validator: (value) {
                  if (value.isEmpty) {
                    return MyStrings.fieldErrorMsg.tr;
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              width: Dimensions.space8,
            ),
            RoundedButton(
              press: () {
                Get.back();
              },
              text: MyStrings.apply,
              customSize: 100,
              textColor: MyColor.colorWhite,
              horizontalPadding: Dimensions.space24,
              verticalPadding: Dimensions.space15,
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .2,
        )
      ],
    );
  }
}
