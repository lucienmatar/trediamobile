import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/two_factor_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/text/small_text.dart';
import 'package:ShapeCom/presentation/components/will_pop_widget.dart';

import '../../../../domain/controller/cart_controller/cartController.dart';
import '../../../components/image/custom_svg_picture.dart';


class TwoFactorVerificationScreen extends StatefulWidget {

  final bool isProfileCompleteEnable;
  const TwoFactorVerificationScreen({
    Key? key,
    required this.isProfileCompleteEnable
  }) : super(key: key);

  @override
  State<TwoFactorVerificationScreen> createState() => _TwoFactorVerificationScreenState();
}

class _TwoFactorVerificationScreenState extends State<TwoFactorVerificationScreen> {

  @override
  void initState() {

    Get.put(CartCountController());
    Get.put(TwoFactorController());

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
        appBar: CustomAppBar(title:MyStrings.twoFactorAuth.tr,fromAuth: true,),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space15, vertical: Dimensions.space20),
          child: GetBuilder<TwoFactorController>(
            builder: (controller) =>  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: Dimensions.space10,),
                  Text(MyStrings.twoFactorVerification.tr,style: mediumLarge.copyWith(fontSize: 20),),
                  const SizedBox(height: Dimensions.space20),

                  Container(
                    height: 100, width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MyColor.primaryColor.withOpacity(.075),
                      shape: BoxShape.circle
                    ),
                    child: CustomSvgPicture(image:MyImages.twoFa, height: 50, width: 50, color: MyColor.getPrimaryColor()),
                  ),
                  const SizedBox(height: Dimensions.space50),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.07 ),
                    child: SmallText(text: MyStrings.twoFactorMsg.tr, maxLine:3,textAlign: TextAlign.center, textStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor())),
                  ),
                  const SizedBox(height: Dimensions.space50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.space30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
                      length: 6,
                      textStyle: regularDefault.copyWith(color: MyColor.getTextColor()),
                      obscureText: false,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 40,
                        fieldWidth: 40,
                        inactiveColor:  MyColor.getTextFieldDisableBorder(),
                        inactiveFillColor: MyColor.getTransparentColor(),
                        activeFillColor: MyColor.getTransparentColor(),
                        activeColor: MyColor.primaryColor,
                        selectedFillColor: MyColor.getTransparentColor(),
                        selectedColor: MyColor.primaryColor
                      ),
                      cursorColor: MyColor.colorWhite,
                      animationDuration:
                      const Duration(milliseconds: 100),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      beforeTextPaste: (text) {
                        return true;
                      },
                      onChanged: (value) {
                        setState(() {
                          controller.currentText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: Dimensions.space30),
                  controller.submitLoading ? const RoundedLoadingBtn() : RoundedButton(
                    press: (){
                      Get.offAllNamed(RouteHelper.bottomNavBar);
                    },
                    text: MyStrings.verify.tr,
                  ),
                  const SizedBox(height: Dimensions.space30),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}
