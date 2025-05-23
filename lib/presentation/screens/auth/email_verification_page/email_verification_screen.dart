import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/auth/email_verification_controler.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/text/small_text.dart';
import 'package:ShapeCom/presentation/components/will_pop_widget.dart';

import '../../../../domain/controller/cart_controller/cartController.dart';
import '../../../components/image/custom_svg_picture.dart';
import '../../../components/otp_field_widget/otp_field_widget.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    Key? key,
  }) : super(key: key);


  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  void initState() {

    Get.put(CartCountController());
    Get.put(EmailVerificationController());

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
        appBar: CustomAppBar(
          fromAuth: true,
          title: MyStrings.emailVerification.tr,
          isShowBackBtn: true,
          isShowSingleActionBtn: false,
          bgColor: MyColor.getAppBarColor()
        ),
        body: GetBuilder<EmailVerificationController>(
          builder: (controller) => SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: Dimensions.space10),
                    Text(MyStrings.emailVerification.tr,style: mediumLarge.copyWith(fontSize: 20),),
                    const SizedBox(height: Dimensions.space20),

                    Container(
                      height: 100, width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: MyColor.primaryColor.withOpacity(.075),
                          shape: BoxShape.circle
                      ),
                      child: CustomSvgPicture(image:MyImages.textFieldEmail, height: 50, width: 50, color: MyColor.getPrimaryColor()),
                    ),
                    const SizedBox(height: Dimensions.space50),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.07 ),
                      child: SmallText(text: MyStrings.viaEmailVerify.tr, maxLine:3,textAlign: TextAlign.center, textStyle: regularDefault.copyWith(color: MyColor.getLabelTextColor())),
                    ),
                    const SizedBox(height: 30),
                    OTPFieldWidget(
                      onChanged: (value) {
                        controller.currentText = value;
                      },
                    ),
                    const SizedBox(height: Dimensions.space30),
                    controller.submitLoading ? const RoundedLoadingBtn() : RoundedButton(
                      text: MyStrings.verify.tr,
                      press: (){
                        Get.toNamed(RouteHelper.smsVerificationScreen);
                      },
                    ),
                    const SizedBox(height: Dimensions.space30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(MyStrings.didNotReceiveCode.tr, style: regularDefault.copyWith(color: MyColor.getLabelTextColor())),
                        const SizedBox(width: Dimensions.space10),
                        controller.resendLoading?
                        Container(margin:const EdgeInsets.only(left: 5,top: 5),height:20,width:20,child: CircularProgressIndicator(color: MyColor.getPrimaryColor())):
                        GestureDetector(
                          
                          onTap: (){

                          },
                          child: Text(MyStrings.resendCode.tr, style: regularDefault.copyWith(color: MyColor.getPrimaryColor())),
                        )
                      ],
                    )
                  ],
                ),
              )
          ),
        )
      ),
    );
  }
}




