import 'package:ShapeCom/config/route/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/forget_password/verify_password_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/image/custom_svg_picture.dart';
import 'package:ShapeCom/presentation/components/text/default_text.dart';
import '../../../../../domain/controller/cart_controller/cartController.dart';
import '../../../../components/snack_bar/show_custom_snackbar.dart';

class VerifyForgetPassScreen extends StatefulWidget {
  const VerifyForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<VerifyForgetPassScreen> createState() => _VerifyForgetPassScreenState();
}

class _VerifyForgetPassScreenState extends State<VerifyForgetPassScreen> {
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Get.put(VerifyPasswordController());
    Get.put(CartCountController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber = Get.arguments['phoneNumber']; // Get the argument
    return Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          fromAuth: true,
          isShowBackBtn: true,
          bgColor: MyColor.getAppBarColor(),
          title: MyStrings.passVerification,
        ),
        body: GetBuilder<VerifyPasswordController>(
            builder: (controller) => controller.isLoading
                ? Center(child: CircularProgressIndicator(color: MyColor.getPrimaryColor()))
                : SingleChildScrollView(
                    padding: Dimensions.screenPaddingHV,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: Dimensions.space50),
                          Container(height: 100, width: 100, alignment: Alignment.center, decoration: BoxDecoration(color: MyColor.primaryColor.withOpacity(.07), shape: BoxShape.circle), child: CustomSvgPicture(image: MyImages.emailVerifyImage, height: 50, width: 50, color: MyColor.getPrimaryColor())),
                          const SizedBox(height: Dimensions.space25),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: DefaultText(text: '${MyStrings.verifyPasswordSubText} : $phoneNumber', textAlign: TextAlign.center, textColor: MyColor.getContentTextColor())),
                          const SizedBox(height: Dimensions.space40),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                                length: 4,
                                textStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
                                obscureText: false,
                                obscuringCharacter: '*',
                                blinkWhenObscuring: false,
                                controller: controller.otpController,
                                errorAnimationController: controller.errorController,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(shape: PinCodeFieldShape.box, borderWidth: 1, borderRadius: BorderRadius.circular(5), fieldHeight: 40, fieldWidth: 40, inactiveColor: MyColor.getTextFieldDisableBorder(), inactiveFillColor: MyColor.getScreenBgColor(), activeFillColor: MyColor.getScreenBgColor(), activeColor: MyColor.getPrimaryColor(), selectedFillColor: MyColor.getScreenBgColor(), selectedColor: MyColor.getPrimaryColor()),
                                cursorColor: MyColor.getTextColor(),
                                animationDuration: const Duration(milliseconds: 100),
                                enableActiveFill: true,
                                keyboardType: TextInputType.number,
                                beforeTextPaste: (text) {
                                  return true;
                                },
                                validator: (value) {
                                  if (value!.length < 4) {
                                    return CustomSnackBar.error(errorList: [MyStrings.otpFieldEmptyMsg]);
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  controller.currentText = value;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.space25),
                          controller.verifyLoading
                              ? const RoundedLoadingBtn()
                              : RoundedButton(
                                  text: MyStrings.verify,
                                  press: () {
                                    formKey.currentState!.validate();
                                    if (controller.currentText.toString().length != 4) {
                                      controller.hasError = true;
                                      controller.errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                                      controller.update();
                                    } else {
                                      controller.forgetPasswordValidationApi();
                                    }
                                  }),
                          const SizedBox(height: Dimensions.space25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DefaultText(text: MyStrings.didNotReceiveCode, textColor: MyColor.getTextColor()),
                              const SizedBox(width: Dimensions.space5),
                              controller.isResendLoading
                                  ? Obx(() {
                                      return DefaultText(text: controller.counter.value.toString(), textStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()));
                                    })
                                  : TextButton(
                                      onPressed: () {
                                        controller.reSendCodePasswordApi();
                                      },
                                      child: DefaultText(text: MyStrings.resendCode, textStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor())),
                                    )
                            ],
                          )
                        ],
                      ),
                    ))));
  }
}
