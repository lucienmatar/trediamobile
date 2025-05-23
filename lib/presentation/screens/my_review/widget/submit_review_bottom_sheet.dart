import 'package:flutter/material.dart';
import 'package:ShapeCom/domain/controller/my_review/my_review_controller.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ShapeCom/presentation/screens/my_review/widget/rating_section.dart';
import 'package:ShapeCom/presentation/screens/my_review/widget/recommendedReviewSection.dart';
import 'package:get/get.dart';

import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../components/bottom-sheet/bottom_sheet_header_row.dart';
import '../../../components/buttons/custom_rounded_button.dart';
class SubmitReviewBottomSheet extends StatelessWidget {

  final MyReviewController  controller;

  const SubmitReviewBottomSheet({
    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    
    return Column(
      children: [
        const BottomSheetHeaderRow(
          header: MyStrings.submitReview,
          bottomSpace: Dimensions.space22,
          isTopIndicator: false,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        const RatingSection(),
        const SizedBox(height: Dimensions.space10),
        const SizedBox(height: Dimensions.space10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(MyStrings.howWasYourProduct.tr,style: regularDefaultInter.copyWith(color: MyColor.primaryTextColor,fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            CustomTextField(
              needOutlineBorder: true,
              animatedLabel: true,
              controller: controller.reviewController,
              focusNode: controller.reviewFocusNode,
              textInputType: TextInputType.multiline,
              onChanged: (value){},
              labelText: MyStrings.writeHereAboutProduct,
              maxLines: 5,
            ),
            const SizedBox(height: 12,)
          ],
        ),
        const SizedBox(height: Dimensions.space8),
        RoundedButton(
          press: () {Get.back();},
          text: MyStrings.submit,
        )
      ],
    );
  }
}





