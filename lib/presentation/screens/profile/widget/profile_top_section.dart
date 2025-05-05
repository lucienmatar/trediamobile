import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/account/profile_controller.dart';
import 'package:ShapeCom/presentation/components/circle_button_with_icon.dart';
import 'package:ShapeCom/presentation/components/column_widget/card_column.dart';
import 'package:ShapeCom/presentation/components/divider/custom_divider.dart';
import 'package:ShapeCom/presentation/components/image/circle_shape_image.dart';

class ProfileTopSection extends StatefulWidget {
  const ProfileTopSection({Key? key}) : super(key: key);

  @override
  State<ProfileTopSection> createState() => _ProfileTopSectionState();
}

class _ProfileTopSectionState extends State<ProfileTopSection> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
        decoration: BoxDecoration(
            color: MyColor.getCardBgColor(),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.space25),
            CardColumn(
              header: MyStrings.name.tr,
              body: "User name"
            ),
            const SizedBox(height: Dimensions.space25),
            CardColumn(
              header: MyStrings.email.tr,
              body:"user@gmail.com"
            ),
            const SizedBox(height: Dimensions.space25),

            CardColumn(
              header: MyStrings.phone.tr,
              body:"0134568871"
            ),
            const SizedBox(height: Dimensions.space25),

            CardColumn(
              header: MyStrings.address.tr,
              body: "New york, USA"
            ),
            const SizedBox(height: Dimensions.space25),
            CardColumn(
              header: MyStrings.state.tr,
              body: "New York"
            ),
            const SizedBox(height: Dimensions.space25),
            CardColumn(
              header: MyStrings.zipCode.tr,
              body: "4121"
            ),
            const SizedBox(height: Dimensions.space25),
            CardColumn(
              header: MyStrings.city.tr,
              body: "New York"
            ),
            const SizedBox(height: Dimensions.space25),
            CardColumn(
              header: MyStrings.country.tr,
              body: "USA"
            ),
          ],
        ),
      ),
    );
  }
}
