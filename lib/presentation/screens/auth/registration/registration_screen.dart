import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/auth/registration_controller.dart';
import 'package:ShapeCom/presentation/components/will_pop_widget.dart';
import 'package:ShapeCom/presentation/screens/auth/registration/widget/registration_form.dart';
import '../../../../config/utils/my_images.dart';
import '../../../components/buttons/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var registrationController = Get.put(RegistrationController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<RegistrationController>(
      builder: (controller) => WillPopWidget(
        nextRoute: RouteHelper.loginScreen,
        child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.space40),
                  Text(MyStrings.createAccount, style: semiBoldLargeInter.copyWith(fontSize: 20, color: MyColor.primaryColor)),
                  const SizedBox(height: Dimensions.space14),
                  Text(MyStrings.regWelcomeMessage, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
                  const SizedBox(height: Dimensions.space20),
                  const RegistrationForm(),
                  const SizedBox(height: Dimensions.space20),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: .5,
                        color: MyColor.naturalLight,
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Or",
                        style: regularLarge.copyWith(color: MyColor.naturalDark),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Container(
                        height: .5,
                        color: MyColor.naturalLight,
                      )),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space20),
                  RoundedButton(
                      isOutlined: true,
                      outlineColor: MyColor.textFieldColor,
                      text: "",
                      press: () {
                        Get.offAllNamed(RouteHelper.bottomNavBar);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_outline, size: 30, color: MyColor.primaryTextColor),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            MyStrings.continueWithGoogle,
                            style: regularLarge,
                          )
                        ],
                      )),
                  const SizedBox(height: Dimensions.space20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(MyStrings.alreadyAccount, style: regularLarge.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500)),
                      const SizedBox(width: Dimensions.space5),
                      TextButton(
                        onPressed: () {
                          controller.clearAllData();
                          Get.offAndToNamed(RouteHelper.loginScreen);
                        },
                        child: Text(MyStrings.signIn, style: regularLarge.copyWith(color: MyColor.getPrimaryColor())),
                      )
                    ],
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
