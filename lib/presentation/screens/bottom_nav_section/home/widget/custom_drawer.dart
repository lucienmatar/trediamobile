import 'package:flutter/material.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../config/utils/dimensions.dart';
import '../../../../../config/utils/my_color.dart';
import '../../../../../config/utils/my_images.dart';
import '../../../../../config/utils/my_preferences.dart';
import '../../../../../config/utils/my_strings.dart';
import '../../../../../config/utils/style.dart';
import '../../../../components/image/circle_shape_image.dart';
import 'dreawer_item_widget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        width: Dimensions.drawerWidth,
        height: double.maxFinite,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: Dimensions.drawerPaddingHV,
              decoration: const BoxDecoration(
                color: MyColor.primaryColor,
              ),
              child: Row(
                children: [
                  const CircleShapeImage(
                    image: MyImages.profile,
                  ),
                  const SizedBox(
                    width: Dimensions.space13,
                  ),
                  Text(
                    "User name",
                    style: semiBoldLargeInter.copyWith(color: MyColor.colorWhite),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * .03,
            ),
            DrawerItem(
              title: MyStrings.myProfile,
              svgIcon: MyImages.person,
              press: () {
                Get.toNamed(RouteHelper.profileScreen);
              },
            ),
            DrawerItem(
              title: MyStrings.paymentHistory,
              svgIcon: MyImages.paymentLog,
              press: () {
                Get.toNamed(RouteHelper.paymentLogScreen);
              },
            ),
            DrawerItem(
              title: MyStrings.orderHistory,
              svgIcon: MyImages.orderLog,
              press: () {
                checkLogin();
              },
            ),
            DrawerItem(
              title: MyStrings.myReview,
              svgIcon: MyImages.myReview,
              press: () {
                Get.toNamed(RouteHelper.myReviewScreen);
              },
            ),
            DrawerItem(
              title: MyStrings.myNotification,
              svgIcon: MyImages.notification,
              press: () {
                Get.toNamed(RouteHelper.notificationScreen);
              },
            ),
            DrawerItem(
              title: MyStrings.faq,
              svgIcon: MyImages.faq,
              press: () {
                Get.toNamed(RouteHelper.faqScreen);
              },
            ),
            DrawerItem(
              title: MyStrings.signOut,
              svgIcon: MyImages.signOut,
              press: () {
                Get.offAllNamed(RouteHelper.loginScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  checkLogin() async {
    bool isGuestLogin = true;
    isGuestLogin = await MyPrefrences.getBool(MyPrefrences.guestLogin) ?? true;
    if (isGuestLogin) {
      showGuestLoginDialog();
    } else {
      Get.toNamed(RouteHelper.myOrderScreen);
    }
  }

  showGuestLoginDialog() {
    Get.defaultDialog(
      title: MyStrings.guestLogin,
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      middleText: MyStrings.guestLogin2,
      middleTextStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
      radius: 10, // Rounded corners
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            // Allow continuing as guest (optional)
          },
          child: Text(
            MyStrings.continueWithGoogle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
            Get.toNamed(RouteHelper.loginScreen, arguments: "guest");
          },
          child: Text(
            MyStrings.signInSignup,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
