import 'package:flutter/material.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/presentation/components/snack_bar/show_custom_snackbar.dart';
import 'package:get/get.dart';

import '../../../../../config/utils/my_strings.dart';
import '../../../../../domain/controller/account/change_password_controller.dart';
import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/account/deactive_account_controller.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/buttons/rounded_loading_button.dart';
import '../../../components/text/header_text.dart';

class DeactiveAccountScreen extends StatefulWidget {
  const DeactiveAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeactiveAccountScreen> createState() => _DeactiveAccountScreen();
}

class _DeactiveAccountScreen extends State<DeactiveAccountScreen> {
  var deactiveAccountController = Get.put(DeactiveAccountController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          fromAuth: false,
          isShowBackBtn: true,
          title: MyStrings.deactivateAccount.tr,
          bgColor: MyColor.getAppBarColor(),
        ),
        body: GetBuilder<DeactiveAccountController>(
          builder: (controller) => SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.space30),
                HeaderText(text: MyStrings.deactivateAccount),
                const SizedBox(height: Dimensions.space25),
                Text(
                  MyStrings.deactivateAccount2.tr,
                  style: regularLarge,
                ),
                const SizedBox(height: Dimensions.space25),
                RoundedButton(
                    cornerRadius: 10,
                    text: MyStrings.deactivateAccount.tr,
                    color: MyColor.colorRed,
                    textColor: MyColor.colorWhite,
                    press: () {
                      deactiveAccountController.deactiveAccountApi();
                    }),
                const SizedBox(height: Dimensions.space40)
              ],
            ),
          ),
        ));
  }
}
