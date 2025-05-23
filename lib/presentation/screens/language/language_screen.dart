import 'package:ShapeCom/config/utils/my_preferences.dart';
import 'package:ShapeCom/domain/controller/language/language_controller.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_strings.dart';
import '../../../domain/controller/language/widget/language_card.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/snack_bar/show_custom_snackbar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    Get.put(LanguageController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguageController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          isShowBackBtn: true,
          title: MyStrings.language.tr,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: GridView.builder(
            shrinkWrap: true,
            addAutomaticKeepAlives: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: controller.languageList.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: MediaQuery.of(context).size.width > 200 ? 2 : 1, crossAxisSpacing: 12, mainAxisSpacing: 12, mainAxisExtent: 150),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                controller.changeSelectedIndex(index);
              },
              child: LanguageCard(
                index: index,
                selectedIndex: controller.selectedIndex,
                langeName: controller.languageList[index],
                isShowTopRight: true,
                imagePath: controller.languageImage[index],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: Dimensions.space15, horizontal: Dimensions.space15),
            child: RoundedButton(
              text: MyStrings.confirm,
              press: () {
                MyPrefrences.saveString(MyPrefrences.language, controller.languageList[controller.selectedIndex]);
                if (controller.selectedIndex == 0) {
                  MyConstants.currentLanguage = "en";
                } else if (controller.selectedIndex == 2) {
                  MyConstants.currentLanguage = "fr";
                } else if (controller.selectedIndex == 1) {
                  MyConstants.currentLanguage = "ar";
                }
                Get.back();
                CustomSnackBar.success(successList: [MyStrings.languageUpdated]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
