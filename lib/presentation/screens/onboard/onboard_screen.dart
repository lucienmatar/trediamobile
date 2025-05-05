import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/screens/onboard/widget/top_shape.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/style.dart';
import '../../../domain/controller/onboarding/onboard_controller.dart';
import '../../components/stataus_bar_color_widget.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  void initState() {
    Get.put(OnboardController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardController>(
      builder: (controller) => StatusBarColorWidget(
        color: MyColor.primaryColor,
        child: PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: MyColor.colorWhite,
            body: SafeArea(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.onboardImageList.length,
                onPageChanged: (value) {
                  controller.changeCurrentIndex(value);
                },
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      const TopShape(
                        top: -20,
                      ),
                      Positioned(
                        top: 40,
                        child: Container(
                          width: context.width,
                          alignment: Alignment.center,
                          child: Image.asset(
                            width: 100,
                            height: 50,
                            MyImages.appLogo,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            controller.onboardImageList[index],
                            height: context.height * .4,
                            width: context.height * .3,
                          )),
                      Positioned(
                        bottom: 60,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.space16),
                              width: context.width,
                              child: Column(
                                children: [
                                  Text(controller.onboardTitleList[index], style: boldLarge.copyWith(fontSize: 22, color: MyColor.primaryColor)),
                                  const SizedBox(
                                    height: Dimensions.space16,
                                  ),
                                  Text(
                                    controller.onboardSubTitleList[index],
                                    style: regularLarge.copyWith(fontSize: double.parse("16"), color: MyColor.primaryColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.height * .03),
                            controller.onboardImageList.length - 1 == index
                                ? SizedBox(
                                    width: context.width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: controller.isLoading == false
                                          ? RoundedButton(
                                              text: MyStrings.getStarted,
                                              press: () {
                                                controller.isLoading = true;
                                                controller.update();
                                                Get.toNamed(RouteHelper.loginScreen);
                                              },
                                              verticalPadding: 18,
                                              color: MyColor.primaryColor,
                                            )
                                          : const CircularProgressIndicator(),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              controller.pageController.jumpToPage(controller.onboardImageList.length);
                                            },
                                            child: Text(MyStrings.skip, style: mediumLarge.copyWith(fontSize: 16))),
                                        Row(
                                            children: List.generate(
                                                controller.onboardImageList.length,
                                                (index) => Container(
                                                      margin: const EdgeInsetsDirectional.only(end: 8),
                                                      width: 24,
                                                      height: 7,
                                                      decoration: BoxDecoration(color: controller.currentIndex == index ? MyColor.primaryColor : Colors.black, borderRadius: BorderRadius.circular(4)),
                                                    ))),
                                        TextButton(
                                            onPressed: () {
                                              controller.pageController.nextPage(duration: const Duration(milliseconds: 1), curve: Curves.ease);
                                            },
                                            child: Text(MyStrings.next, style: mediumLarge.copyWith(fontSize: 16))),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
