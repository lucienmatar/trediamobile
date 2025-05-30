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
import '../../../domain/controller/menu_screen/menu_screen_controller.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/snack_bar/show_custom_snackbar.dart';
import '../../components/warning_aleart_dialog.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var menuScreenController = Get.put(MenuScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.colorLightGrey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          MyStrings.myMenu,
          style: titleText,
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: Dimensions.screenPaddingHV,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: menuScreenController.isGuestLogin == false,
              child: MenuCard(
                  child: Column(
                children: [
                  MenuRowWidget(
                    image: MyImages.person,
                    label: MyStrings.profile,
                    onPressed: () => Get.toNamed(RouteHelper.profileCompleteScreen),
                  ),
                  /* MenuRowWidget(
                    image: MyImages.lock,
                    label: MyStrings.changePassword.tr,
                    onPressed: () => Get.toNamed(RouteHelper.changePasswordScreen),
                  ),*/
                ],
              )),
            ),
            const SizedBox(height: Dimensions.space15),
            MenuCard(
              child: Column(
                children: [
                  Visibility(
                    visible: menuScreenController.isGuestLogin == false,
                    child: MenuRowWidget(
                      image: MyImages.address,
                      label: MyStrings.myAddresses,
                      onPressed: () => Get.toNamed(RouteHelper.myAddressesScreen),
                    ),
                  ),
                  MenuRowWidget(
                    image: MyImages.wishListOutline,
                    label: MyStrings.wishList,
                    onPressed: () => Get.toNamed(RouteHelper.wishListScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.language,
                    label: MyStrings.language.tr,
                    onPressed: () => Get.toNamed(RouteHelper.languageScreen),
                  ),
                  MenuRowWidget(
                    image: MyImages.dollar,
                    label: MyStrings.currency,
                    onPressed: () {
                      menuScreenController.getCurrenciesApi(callback: () {
                        showGenderBottomSheet();
                      });
                    },
                  ),
                  Visibility(
                    visible: menuScreenController.isGuestLogin == true,
                    child: MenuRowWidget(
                      image: MyImages.person,
                      label: MyStrings.signInSignup,
                      onPressed: () => Get.toNamed(RouteHelper.loginScreen, arguments: "guest"),
                    ),
                  ),
                  /*MenuRowWidget(
                    image: MyImages.ticket,
                    label: MyStrings.couponCode,
                    onPressed: () => Get.toNamed(RouteHelper.couponCodeScreen),
                  ),*/
                  /*MenuRowWidget(
                    image: MyImages.paymentLog,
                    label: MyStrings.paymentHistory,
                    onPressed: () => Get.toNamed(RouteHelper.paymentLogScreen),
                  ),*/
                  Visibility(
                    visible: menuScreenController.isGuestLogin == false,
                    child: MenuRowWidget(
                      image: MyImages.orderLog,
                      label: MyStrings.orderHistory,
                      onPressed: () => Get.toNamed(RouteHelper.myOrderScreen),
                    ),
                  ),
                  /*MenuRowWidget(
                    image: MyImages.notification,
                    label: MyStrings.myNotification,
                    onPressed: () => Get.toNamed(RouteHelper.notificationScreen),
                  ),*/
                  /*MenuRowWidget(
                    image: MyImages.myReview,
                    label: MyStrings.myReview,
                    onPressed: () => Get.toNamed(RouteHelper.myReviewScreen),
                  ),*/
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space15),
            Visibility(
              visible: menuScreenController.isGuestLogin == false,
              child: MenuCard(
                child: Column(
                  children: [
                    /* MenuRowWidget(
                      image: MyImages.faq,
                      label: MyStrings.faq,
                      onPressed: () => Get.toNamed(RouteHelper.faqScreen),
                    ),*/
                    MenuRowWidget(
                      image: MyImages.signOut,
                      label: MyStrings.signOut,
                      onPressed: () async {
                        await menuScreenController.logoutApi(callback: () {
                          if (menuScreenController.logoutModel!.status == 1) {
                            if (menuScreenController.logoutModel!.msg!.isNotEmpty) {
                              CustomSnackBar.success(successList: [menuScreenController.logoutModel!.msg!]);
                            }
                            MyPrefrences.clear();
                            Get.offAllNamed(RouteHelper.loginScreen);
                          } else {
                            if (menuScreenController.logoutModel!.msg!.isNotEmpty) {
                              CustomSnackBar.error(errorList: [menuScreenController.logoutModel!.msg!]);
                            }
                          }
                        });
                      },
                    ),
                    /*MenuRowWidget(
                      image: MyImages.trash,
                      label: MyStrings.deleteAccount,
                      onPressed: () {
                        const WarningAlertDialog().warningAlertDialog(isDelete: true, context, () {
                          Get.offAllNamed(RouteHelper.loginScreen);
                        });
                      },
                    ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showGenderBottomSheet() {
    Get.bottomSheet(
      Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${MyStrings.select} ${MyStrings.currency}", style: boldLarge.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: Dimensions.space20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: menuScreenController.currencyCount,
              itemBuilder: (context, index) {
                return Obx(() {
                  return ListTile(
                    dense: true, // Reduces internal padding
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(
                        menuScreenController.currencyModel!.data![index].display!,
                        style: regularLarge,
                        maxLines: 1,
                      ),
                    ),
                    trailing: Radio<int>(
                      value: index,
                      groupValue: menuScreenController.selectedCurrencyValue.value,
                      onChanged: (int? value) {
                        menuScreenController.selectedCurrencyValue.value = value!;
                        MyPrefrences.saveString(MyPrefrences.currency, menuScreenController.currencyModel!.data![index].display!);
                        CustomSnackBar.success(successList: [MyStrings.currencyUpdated]);
                        Get.back();
                      },
                    ),
                    visualDensity: const VisualDensity(vertical: -4), // Adjust density to make it compact
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
