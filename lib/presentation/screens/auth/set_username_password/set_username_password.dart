import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/route/route.dart';
import '../../../../config/utils/dimensions.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/auth/auth/set_username_password_controller.dart';
import '../../../../domain/controller/auth/forget_password/reset_password_controller.dart';
import '../../../components/app-bar/custom_appbar.dart';
import '../../../components/buttons/rounded_button.dart';
import '../../../components/buttons/rounded_loading_button.dart';
import '../../../components/text-form-field/custom_text_field.dart';
import '../../../components/text/default_text.dart';
import '../../../components/text/header_text.dart';
import '../../../components/will_pop_widget.dart';

class SetUsernamePassword extends StatefulWidget {
  const SetUsernamePassword({super.key});

  @override
  State<SetUsernamePassword> createState() => _SetUsernamePasswordState();
}

class _SetUsernamePasswordState extends State<SetUsernamePassword> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Get.put(SetUsernamePasswordController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(title: MyStrings.createYourAccount, fromAuth: true, bgColor: MyColor.getAppBarColor()),
        body: GetBuilder<SetUsernamePasswordController>(
          builder: (controller) => SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                    animatedLabel: true,
                    needOutlineBorder: true,
                    prefixIcon: MyImages.user,
                    labelText: MyStrings.username,
                    controller: controller.usernameController,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return MyStrings.enterYourUsername;
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      return;
                    },
                  ),
                  const SizedBox(height: Dimensions.space15),
                  CustomTextField(
                      animatedLabel: true,
                      needOutlineBorder: true,
                      labelText: MyStrings.password,
                      prefixIcon: MyImages.password,
                      isShowSuffixIcon: true,
                      isPassword: true,
                      inputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                      controller: controller.passController,
                      validator: (value) {
                        return controller.validatePassword(value);
                      },
                      onChanged: (value) {
                        if (controller.checkPasswordStrength) {}
                        return;
                      }),
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
                      if (controller.passController.text.toLowerCase() != controller.confirmPassController.text.toLowerCase()) {
                        return MyStrings.kMatchPassError;
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: Dimensions.space35),
                  controller.submitLoading
                      ? const RoundedLoadingBtn()
                      : RoundedButton(
                          color: MyColor.colorGreen,
                          text: MyStrings.createAccount,
                          press: () async {
                            if (formKey.currentState!.validate()) {
                              int? createAccountStatus = 0;
                              createAccountStatus = await controller.createAccountApi();
                              print("createAccountStatus $createAccountStatus");
                              if (createAccountStatus == 1) {
                                controller.loginApi();
                              }
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
