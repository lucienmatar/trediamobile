import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/domain/controller/home/home_controller.dart';

import '../../../../../config/utils/my_color.dart';
import '../../../../../config/utils/my_images.dart';
import '../../../../../config/utils/my_strings.dart';
import '../../../../../config/utils/style.dart';
import '../../../../components/text-form-field/custom_text_field.dart';

class HomeScreenTopSection extends StatelessWidget {
  const HomeScreenTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) => Container(
        decoration: const BoxDecoration(color: MyColor.colorWhite, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      MyImages.dashboardLogo,
                      height: 50,
                      width: 150,
                    ),
                  ),
                  /*GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.couponCodeScreen);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColor.primaryColor.withOpacity(.8),
                      ),
                      child: Image.asset(MyImages.coupon),
                    ),
                  ),*/
                  /*Expanded(
                    child: Column(
                      children: [
                        Text("Delivery Address",style: boldLarge.copyWith(color: MyColor.bodyTextColor),),
                        Text("92 High Street, London",style: boldLarge.copyWith(fontSize: 15),)
                      ],
                    ),
                  ),*/
                  GestureDetector(
                    onTap: () {
                      //Get.toNamed(RouteHelper.notificationScreen);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColor.primaryColor.withOpacity(.2),
                      ),
                      child: SvgPicture.asset(MyImages.notification),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: "${MyStrings.searchIn} ${MyStrings.appName}",
                controller: controller.searchController,
                textInputType: TextInputType.text,
                fillColor: MyColor.textFieldColor.withOpacity(.7),
                prefixIcon: MyImages.search,
                validator: (value) {
                  if (value!.isEmpty) {
                    return MyStrings.enterYourUsername.tr;
                  } else if(value.length<6){
                    return MyStrings.kShortUserNameError.tr;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
            ),
            const SizedBox(height: 15),*/
          ],
        ),
      ),
    );
  }
}
