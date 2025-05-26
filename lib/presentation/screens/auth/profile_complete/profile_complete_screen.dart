import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/domain/controller/account/profile_complete_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/text-form-field/custom_text_field.dart';
import 'package:intl/intl.dart';
import '../../../../config/utils/my_images.dart';
import '../../../../config/utils/style.dart';
import '../../../../domain/controller/cart_controller/cartController.dart';
import '../../../components/text-form-field/custom_text_field_square.dart';
import '../../menu/change_phone_number.dart';
import '../deactive_account/deactive_account_screen.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen> {
  DateTime? selectedDate;
  final formKey = GlobalKey<FormState>();
  var profileCompleteController = Get.put(ProfileCompleteController());
  @override
  void initState() {
    super.initState();
    Get.put(CartCountController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: CustomAppBar(
        title: MyStrings.accountSetting.tr,
        isShowBackBtn: true,
        fromAuth: false,
        isProfileCompleted: false,
        bgColor: MyColor.getAppBarColor(),
      ),
      body: GetBuilder<ProfileCompleteController>(
        builder: (controller) => SingleChildScrollView(
          padding: Dimensions.screenPaddingHV,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: MyColor.iconsBackground,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: Dimensions.space15),
                        CustomTextFieldSquare(
                          borderRadius: 5,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: MyStrings.firstname,
                          hintText: "${MyStrings.enterYour.tr} ${MyStrings.firstname.toLowerCase()}",
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          focusNode: controller.firstNameFocusNode,
                          controller: controller.firstNameController,
                          nextFocus: controller.lastNameFocusNode,
                          onChanged: (value) {
                            if (controller.firstNameController.text.isNotEmpty) {
                              profileCompleteController.isSubmitDisable = false;
                            } else {
                              profileCompleteController.isSubmitDisable = true;
                            }
                            profileCompleteController.update();
                            return;
                          },
                        ),
                        const SizedBox(height: Dimensions.space16),
                        CustomTextFieldSquare(
                          borderRadius: 5,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: MyStrings.middleName,
                          hintText: "${MyStrings.enterYour.tr} ${MyStrings.middleName.toLowerCase()}",
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          controller: controller.middleNameController,
                          onChanged: (value) {
                            if (controller.middleNameController.text.isNotEmpty) {
                              profileCompleteController.isSubmitDisable = false;
                            } else {
                              profileCompleteController.isSubmitDisable = true;
                            }
                            profileCompleteController.update();
                            return;
                          },
                        ),
                        const SizedBox(height: Dimensions.space16),
                        CustomTextFieldSquare(
                          borderRadius: 5,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: MyStrings.lastName,
                          hintText: "${MyStrings.enterYour.tr} ${MyStrings.lastName.toLowerCase()}",
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          focusNode: controller.lastNameFocusNode,
                          controller: controller.lastNameController,
                          nextFocus: controller.addressFocusNode,
                          onChanged: (value) {
                            if (controller.lastNameController.text.isNotEmpty) {
                              profileCompleteController.isSubmitDisable = false;
                            } else {
                              profileCompleteController.isSubmitDisable = true;
                            }
                            profileCompleteController.update();
                            return;
                          },
                        ),
                        const SizedBox(height: Dimensions.space16),
                        CustomTextFieldSquare(
                          borderRadius: 5,
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: MyStrings.email,
                          hintText: "${MyStrings.enterYour.tr} ${MyStrings.email.toLowerCase()}",
                          textInputType: TextInputType.emailAddress,
                          inputAction: TextInputAction.next,
                          controller: controller.emailController,
                          onChanged: (value) {
                            if (controller.emailController.text.isNotEmpty) {
                              profileCompleteController.isSubmitDisable = false;
                            } else {
                              profileCompleteController.isSubmitDisable = true;
                            }
                            profileCompleteController.update();
                            return;
                          },
                        ),
                        const SizedBox(height: Dimensions.space16),
                        InkWell(
                          onTap: () {
                            openDatePicker();
                          },
                          child: CustomTextFieldSquare(
                            borderRadius: 5,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: MyStrings.dob,
                            hintText: "${MyStrings.enterYour.tr} ${MyStrings.dob.toLowerCase()}",
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            controller: controller.dobController,
                            isEnable: false,
                            onChanged: (value) {
                              return;
                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.space16),
                        InkWell(
                          onTap: () {
                            showGenderBottomSheet(context);
                          },
                          child: CustomTextFieldSquare(
                            borderRadius: 5,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: MyStrings.gender,
                            hintText: "${MyStrings.enterYour.tr} ${MyStrings.gender.toLowerCase()}",
                            textInputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            controller: controller.genderController,
                            isEnable: false,
                            onChanged: (value) {
                              return;
                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.space15),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.space20),
                controller.submitLoading
                    ? const RoundedLoadingBtn()
                    : RoundedButton(
                        color: profileCompleteController.isSubmitDisable ? MyColor.colorLightGrey : MyColor.primaryColor,
                        text: MyStrings.save.tr,
                        press: () {
                          if (profileCompleteController.isSubmitDisable == false) {
                            if (formKey.currentState!.validate()) {
                              profileCompleteController.editProfileDetails();
                            }
                          }
                        },
                      ),
                const SizedBox(height: Dimensions.space20),
                Card(
                  color: MyColor.iconsBackground,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.space15),
                        Text(
                          MyStrings.username,
                          style: regularLarge.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                        const SizedBox(height: Dimensions.space15),
                        Text(
                          profileCompleteController.username!,
                          style: regularLarge.copyWith(fontWeight: FontWeight.w400),
                          maxLines: 1,
                        ),
                        const SizedBox(height: Dimensions.space10),
                        Divider(),
                        const SizedBox(height: Dimensions.space15),
                        Text(
                          MyStrings.phoneNumber,
                          style: regularLarge.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                        const SizedBox(height: Dimensions.space15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              profileCompleteController.phonenumber!,
                              style: regularLarge.copyWith(fontWeight: FontWeight.w400),
                              maxLines: 1,
                            ),
                            Visibility(
                              visible: profileCompleteController.phonenumber != null && profileCompleteController.phonenumber!.isNotEmpty,
                              child: InkWell(
                                onTap: () {
                                  Get.off(ChangePhoneNumberScreen());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: MyColor.primaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(5), // Radius border
                                  ),
                                  child: Text(
                                    MyStrings.edit,
                                    style: regularSmall.copyWith(color: MyColor.primaryColor),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.space15),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.space16),
                Card(
                  color: MyColor.iconsBackground,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.space15),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RouteHelper.changePasswordScreen);
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: Dimensions.space5),
                              SvgPicture.asset(MyImages.password, height: 20, width: 20),
                              const SizedBox(width: Dimensions.space15),
                              Text(
                                MyStrings.changePassword.tr,
                                style: regularLarge,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.space15),
                        Divider(),
                        const SizedBox(height: Dimensions.space15),
                        InkWell(
                          onTap: () {
                            Get.to(DeactiveAccountScreen());
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: Dimensions.space5),
                              SvgPicture.asset(MyImages.delete, height: 20, width: 20),
                              const SizedBox(width: Dimensions.space15),
                              Text(
                                MyStrings.deactivateAccount.tr,
                                style: regularLarge,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimensions.space15),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: Dimensions.space35),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      profileCompleteController.isSubmitDisable = false;
      profileCompleteController.dob = picked;
      selectedDate = picked;
      String formattedDate = DateFormat('dd-MM-yyyy').format(picked);
      profileCompleteController.serverDate = DateFormat('yyyy-MM-dd').format(picked);
      profileCompleteController.dobController.text = formattedDate;
      profileCompleteController.update();
    }
  }

  Future<String?> showGenderBottomSheet(BuildContext context) async {
    RxList<String> filteredList = profileCompleteController.genders.obs;

    return await Get.bottomSheet<String>(
      Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
                child: Obx(
              () => ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredList[index]),
                    onTap: () {
                      profileCompleteController.selectedGender.value = filteredList[index];
                      profileCompleteController.genderController.text = profileCompleteController.selectedGender.value;
                      profileCompleteController.isSubmitDisable = false;
                      profileCompleteController.update();
                      Get.back();
                    },
                  );
                },
              ),
            )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
