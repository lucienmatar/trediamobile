import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/forget_password/reset_password_controller.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ShapeCom/presentation/components/text/default_text.dart';
import 'package:ShapeCom/presentation/components/text/header_text.dart';
import 'package:ShapeCom/presentation/components/will_pop_widget.dart';
import '../../../../../domain/controller/cart_controller/cartController.dart';
import '../../../../components/app-bar/custom_appbar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.put(ResetPasswordController());
    Get.put(CartCountController());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(title: MyStrings.resetPassword, fromAuth: true, bgColor: MyColor.getAppBarColor()),
        body: GetBuilder<ResetPasswordController>(
          builder: (controller) => SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.space30),
                  HeaderText(text: MyStrings.resetPassword),
                  const SizedBox(height: Dimensions.space15),
                  DefaultText(text: MyStrings.resetPassContent, textStyle: regularDefault.copyWith(color: MyColor.getTextColor().withOpacity(0.8))),
                  const SizedBox(height: Dimensions.space15),
                  Focus(
                    onFocusChange: (hasFocus) {
                      controller.changePasswordFocus(hasFocus);
                    },
                    child: CustomTextField(
                        animatedLabel: true,
                        needOutlineBorder: true,
                        prefixIcon: MyImages.password,
                        labelText: MyStrings.password,
                        isShowSuffixIcon: true,
                        isPassword: true,
                        textInputType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        controller: controller.passController,
                        validator: (value) {
                          return controller.validatePassword(value);
                        },
                        onChanged: (value) {
                          if (controller.checkPasswordStrength) {}
                          return;
                        }),
                  ),
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                    animatedLabel: true,
                    needOutlineBorder: true,
                    inputAction: TextInputAction.done,
                    isPassword: true,
                    prefixIcon: MyImages.password,
                    labelText: MyStrings.confirmPassword,
                    hintText: MyStrings.confirmYourPassword,
                    isShowSuffixIcon: true,
                    controller: controller.confirmPassController,
                    onChanged: (value) {
                      return;
                    },
                    validator: (value) {
                      return controller.validatePassword(value);
                    },
                    /*validator: (value) {
                      if (controller.passController.text.toLowerCase() != controller.confirmPassController.text.toLowerCase()) {
                        return MyStrings.kMatchPassError;
                      } else {
                        return null;
                      }
                    },*/
                  ),
                  const SizedBox(height: Dimensions.space35),
                  controller.submitLoading
                      ? const RoundedLoadingBtn()
                      : RoundedButton(
                          text: MyStrings.resetPassword,
                          press: () {
                            if (formKey.currentState!.validate()) {
                              controller.resetPasswordApi();
                              //Get.offAllNamed(RouteHelper.loginScreen);
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
