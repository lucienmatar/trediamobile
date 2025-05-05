import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/auth/sms_verification_controler.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/text/small_text.dart';
import 'package:ShapeCom/presentation/components/will_pop_widget.dart';

import '../../../../domain/controller/cart_controller/cartController.dart';
import '../../../components/image/custom_svg_picture.dart';

class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen({Key? key}) : super(key: key);

  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

class _SmsVerificationScreenState extends State<SmsVerificationScreen> {
  var args = Get.arguments;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Get.put(CartCountController());
    Get.put(SmsVerificationController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(args["phoneNumber"]);
    return WillPopWidget(
      nextRoute: RouteHelper.loginScreen,
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          fromAuth: true,
          title: MyStrings.smsVerification,
          isShowBackBtn: true,
          isShowSingleActionBtn: false,
          bgColor: MyColor.getAppBarColor(),
        ),
        body: GetBuilder<SmsVerificationController>(
          builder: (controller) => SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimensions.space10),
                    Text(
                      MyStrings.smsVerification,
                      style: mediumLarge.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: Dimensions.space20),
                    Container(
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: MyColor.primaryColor.withOpacity(.075), shape: BoxShape.circle),
                      child: CustomSvgPicture(image: MyImages.emailVerifyImage, height: 50, width: 50, color: MyColor.getPrimaryColor()),
                    ),
                    const SizedBox(height: Dimensions.space50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .07),
                      child: SmallText(text: MyStrings.smsVerificationMsg, maxLine: 3, textAlign: TextAlign.center, textStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor())),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      args["phoneNumber"],
                      style: mediumLarge.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                          length: 4,
                          controller: controller.otpController,
                          textStyle: regularDefault.copyWith(color: MyColor.getPrimaryColor()),
                          obscureText: false,
                          errorAnimationController: controller.errorController,
                          obscuringCharacter: '*',
                          blinkWhenObscuring: false,
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
                              return MyStrings.otpFieldEmptyMsg;
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
                    const SizedBox(height: Dimensions.space30),
                    controller.submitLoading
                        ? const RoundedLoadingBtn()
                        : RoundedButton(
                            text: MyStrings.verify,
                            press: () {
                              formKey.currentState!.validate();
                              if (controller.currentText.length != 4) {
                                controller.errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                                controller.hasError = true;
                                controller.update();
                              } else {
                                controller.validateRegistrationApi();
                              }
                              /*if (formKey.currentState!.validate()) {
                                print("OTP ${controller.currentText}");
                              }*/
                              //Get.toNamed(RouteHelper.twoFactorScreen, arguments: true);
                            },
                          ),
                    const SizedBox(height: Dimensions.space30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(MyStrings.didNotReceiveCode, style: regularDefault.copyWith(color: MyColor.getLabelTextColor())),
                        const SizedBox(width: Dimensions.space10),
                        controller.resendLoading
                            ? Container(
                                margin: const EdgeInsets.all(5),
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: MyColor.getPrimaryColor(),
                                ))
                            : GestureDetector(
                                onTap: () {
                                  controller.resendCodeApi();
                                },
                                child: Text(MyStrings.resendCode, style: regularDefault.copyWith(color: MyColor.getPrimaryColor()))),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
