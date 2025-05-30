import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_images.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/config/utils/util.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/will_pop_widget.dart';

import '../../../../domain/controller/auth/login_controller.dart';
import '../../../components/buttons/rounded_loading_button.dart';
import '../../../components/text-form-field/custom_text_field.dart';
import '../../../components/text/default_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _fieldKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  //final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  var loginController = Get.put(LoginController());
  String userType = "default";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    MyUtils.allScreen();
    loginController.emailController.addListener(() {
      if (_focusNode.hasFocus && loginController.emailController.text.isNotEmpty) {
        if (_fieldKey.currentState!.validate()) {}
      }
    });
    loginController.passwordController.addListener(() {
      if (passwordFocusNode.hasFocus && loginController.passwordController.text.isNotEmpty) {
        if (formKey.currentState!.validate()) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      userType = Get.arguments ?? 'default';
      print("userType $userType");
    } catch (e) {}
    return WillPopScope(
      onWillPop: () async {
        if (userType == "guest") {
          Get.back();
        }
        return false;
      },
      child: GetBuilder<LoginController>(
        builder: (controller) => Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: userType == "guest",
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Get.back(); // or Navigator.pop(context);
                            },
                          ),
                        ),
                        DropdownButton<String>(
                          value: controller.selectedLanguage, // Ensure this is a String
                          items: controller.languageMap.keys.map((String key) {
                            // Keys are Strings
                            return DropdownMenuItem<String>(
                              value: key, // Ensure this is a String
                              child: Text(key),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            print("newValue $newValue");
                            controller.selectedLanguage = newValue!;
                            controller.setLocale(controller.languageMap[newValue]!, newValue); // Get Locale from Map
                          },
                        ),
                      ],
                    ),
                    Text(MyStrings.welcome, style: semiBoldLargeInter.copyWith(fontSize: 40, color: MyColor.primaryColor)),
                    Text(MyStrings.back, style: semiBoldLargeInter.copyWith(fontSize: 40)),
                    const SizedBox(height: Dimensions.space10),
                    Text(MyStrings.loginWelcomeMessage, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
                    const SizedBox(height: Dimensions.space20),
                    CustomTextField(
                      key: _fieldKey,
                      animatedLabel: true,
                      needOutlineBorder: true,
                      prefixIcon: MyImages.person,
                      labelText: MyStrings.emailOrUserName,
                      focusNode: _focusNode,
                      controller: loginController.emailController,
                      textInputType: TextInputType.text,
                      nextFocus: passwordFocusNode,
                      validator: (value) {
                        if (loginController.emailController.text.toString().isEmpty) {
                          return MyStrings.enterYourUsername;
                        }
                        /*else if (loginController.emailController.text.toString().length < 6) {
                          print("len ${value.length}");
                          return MyStrings.kShortUserNameError;
                        }*/
                        else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        if (_focusNode.hasFocus && loginController.emailController.text.isNotEmpty) {
                          if (formKey.currentState!.validate()) {}
                        }
                        return;
                      },
                    ),
                    const SizedBox(height: Dimensions.space16),
                    CustomTextField(
                        animatedLabel: true,
                        needOutlineBorder: true,
                        isShowSuffixIcon: true,
                        isPassword: true,
                        prefixIcon: MyImages.password,
                        labelText: MyStrings.password,
                        controller: controller.passwordController,
                        focusNode: passwordFocusNode,
                        textInputType: TextInputType.text,
                        onChanged: (value) {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return MyStrings.fieldErrorMsg;
                          } else {
                            return null;
                          }
                        }),
                    const SizedBox(height: Dimensions.space18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: Offstage(),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            controller.clearTextField();
                            Get.toNamed(RouteHelper.forgotPasswordScreen);
                          },
                          child: DefaultText(text: MyStrings.forgotPassword, textColor: MyColor.primaryColor),
                        )
                      ],
                    ),
                    const SizedBox(height: Dimensions.space18),
                    controller.isSubmitLoading
                        ? const RoundedLoadingBtn()
                        : RoundedButton(
                            text: MyStrings.signIn,
                            press: () {
                              if (formKey.currentState!.validate()) {
                                controller.validateAndLogin();
                              }
                            }),
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
                          MyStrings.or,
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
                    controller.isSubmitLoading
                        ? const RoundedLoadingBtn()
                        : RoundedButton(
                            isOutlined: true,
                            outlineColor: MyColor.textFieldColor,
                            text: "",
                            press: () {
                              controller.guestLoginApi();
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
                        Text(MyStrings.doNotHaveAccount, overflow: TextOverflow.ellipsis, style: regularLarge.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500)),
                        const SizedBox(width: Dimensions.space5),
                        TextButton(
                          onPressed: () {
                            Get.offAndToNamed(RouteHelper.registrationScreen);
                          },
                          child: Text(MyStrings.signUp, maxLines: 2, overflow: TextOverflow.ellipsis, style: regularLarge.copyWith(color: MyColor.getPrimaryColor())),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
