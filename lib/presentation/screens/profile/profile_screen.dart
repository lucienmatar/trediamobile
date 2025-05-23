import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/domain/controller/account/profile_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/custom_loader/custom_loader.dart';
import 'package:ShapeCom/presentation/screens/Profile/widget/profile_top_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(ProfileController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.screenBgColor,
        appBar: CustomAppBar(
          title: MyStrings.profile,
          bgColor: MyColor.getAppBarColor(),
        ),
        body: controller.isLoading
            ? const CustomLoader()
            : Stack(
                children: [
                  Positioned(
                    top: -10,
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      color: MyColor.primaryColor,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(left: Dimensions.space15, right: Dimensions.space15, top: Dimensions.space20, bottom: Dimensions.space20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileTopSection(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
