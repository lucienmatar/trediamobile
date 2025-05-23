import 'package:flutter/material.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:get/get.dart';
import '../../../../config/utils/my_color.dart';
import '../../../../config/utils/my_strings.dart';
import '../../../../domain/controller/account/change_password_controller.dart';
import 'widget/change_password_form.dart';

class ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  @override
  void initState() {
    super.initState();
    Get.put(ChangePasswordController());
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  @override
  void dispose() {
    Get.find<ChangePasswordController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: MyColor.screenBgColor,
      appBar: CustomAppBar(isShowBackBtn: true, title: MyStrings.changePassword.tr, bgColor: MyColor.primaryColor),
      body: GetBuilder<ChangePasswordController>(
        builder: (controller) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MyStrings.createNewPassword.tr,
                  style: regularExtraLarge.copyWith(color: MyColor.getTextColor(), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsetsDirectional.only(end: MediaQuery.of(context).size.width*0.3),
                  child: Text(
                    MyStrings.createPasswordSubText.tr,
                    style: regularDefault.copyWith(color: MyColor.getTextColor().withOpacity(0.8)),
                  ),
                ),
                const SizedBox(height: 50),

                const ChangePasswordForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
