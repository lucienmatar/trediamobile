import 'package:ShapeCom/config/utils/my_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/presentation/screens/menu/widget/menu_card.dart';
import 'package:ShapeCom/presentation/screens/menu/widget/menu_row_widget.dart';
import 'package:get/get.dart';

import '../../../config/route/route.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../../config/utils/style.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/warning_aleart_dialog.dart';
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorLightGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(MyStrings.myMenu,style: titleText,),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: Dimensions.screenPaddingHV,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MenuCard(
              child: Column(
                children: [
                  MenuRowWidget(
                    image: MyImages.person,
                    label: MyStrings.profile,
                    iconSize: 25,
                    onPressed: () => Get.toNamed(RouteHelper.profileScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.lock,
                    label: MyStrings.changePassword.tr,
                    onPressed: () => Get.toNamed(RouteHelper.changePasswordScreen),
                  ),
                ],
              )
            ),

            const SizedBox(height: Dimensions.space15),

            MenuCard(
              child: Column(
                children: [
                  MenuRowWidget(
                    image: MyImages.wishListOutline,
                    label: MyStrings.wishList,
                    onPressed: () => Get.toNamed(RouteHelper.wishListScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.ticket,
                    label: MyStrings.couponCode,
                    onPressed: () => Get.toNamed(RouteHelper.couponCodeScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.paymentLog,
                    label: MyStrings.paymentHistory,
                    onPressed: () => Get.toNamed(RouteHelper.paymentLogScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.orderLog,
                    label: MyStrings.orderHistory,
                    onPressed: () => Get.toNamed(RouteHelper.myOrderScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.language,
                    label: MyStrings.language.tr,
                    onPressed: () => Get.toNamed(RouteHelper.languageScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.notification,
                    label: MyStrings.myNotification,
                    onPressed: () => Get.toNamed(RouteHelper.notificationScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.myReview,
                    label: MyStrings.myReview,
                    onPressed: () => Get.toNamed(RouteHelper.myReviewScreen),
                  ),
                ],
              ),
            ),

            const SizedBox(height: Dimensions.space15),

            MenuCard(
              child: Column(
                children: [
                  MenuRowWidget(
                    image: MyImages.faq,
                    label: MyStrings.faq,
                    onPressed: () => Get.toNamed(RouteHelper.faqScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.signOut,
                    label: MyStrings.signOut,
                    onPressed: () async {
                      MyPrefrences.clear();
                      Get.offAllNamed(RouteHelper.loginScreen);
                    },
                  ),
                  MenuRowWidget(
                    image: MyImages.trash,
                    label: MyStrings.deleteAccount,
                    onPressed: () {
                      const WarningAlertDialog().warningAlertDialog(
                      isDelete: true,
                      context, () {Get.offAllNamed(RouteHelper.loginScreen);});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
