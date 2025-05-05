import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/domain/controller/add_shipping_address/add_shipping_address_controller.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';

import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/text-form-field/custom_text_field.dart';

class AddShippingAddressScreen extends StatefulWidget {
  const AddShippingAddressScreen({super.key});

  @override
  State<AddShippingAddressScreen> createState() => _AddShippingAddressScreenState();
}

class _AddShippingAddressScreenState extends State<AddShippingAddressScreen> {
  @override
  void initState() {
    final controller = Get.put(AddShippingAddressController());
    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddShippingAddressController>(
      builder: (controller) => Scaffold(
        backgroundColor: MyColor.colorWhite,
        appBar: CustomAppBar(
          title: MyStrings.addShippingAddress,
          leadingImage: MyImages.backButton,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: controller.firstNameController,
                  textInputType: TextInputType.name,
                  focusNode: controller.firstNameFocusNode,
                  nextFocus: controller.lastNameFocusNode,
                  labelText: MyStrings.firstname,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return MyStrings.fieldErrorMsg.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: Dimensions.space12),
                CustomTextField(
                  controller: controller.lastNameController,
                  textInputType: TextInputType.name,
                  focusNode: controller.lastNameFocusNode,
                  nextFocus: controller.mobileFocusNode,
                  labelText: MyStrings.lastName.tr,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: Dimensions.space12,
                ),
                CustomTextField(
                  controller: controller.mobileController,
                  textInputType: TextInputType.number,
                  focusNode: controller.mobileFocusNode,
                  nextFocus: controller.emailFocusNode,
                  labelText: MyStrings.mobile.tr,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                  onSuffixTap: () {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return MyStrings.fieldErrorMsg.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: Dimensions.space12),
                CustomTextField(
                  controller: controller.emailController,
                  textInputType: TextInputType.emailAddress,
                  focusNode: controller.emailFocusNode,
                  nextFocus: controller.cityFocusNode,
                  labelText: MyStrings.email.tr,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                  onSuffixTap: () {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return MyStrings.fieldErrorMsg.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: Dimensions.space12),
                CustomTextField(
                  controller: controller.cityController,
                  textInputType: TextInputType.name,
                  focusNode: controller.cityFocusNode,
                  nextFocus: controller.stateFocusNode,
                  labelText: MyStrings.city.tr,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                  onSuffixTap: () {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return MyStrings.fieldErrorMsg.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: Dimensions.space12),
                CustomTextField(
                  controller: controller.stateController,
                  textInputType: TextInputType.name,
                  focusNode: controller.stateFocusNode,
                  nextFocus: controller.zipFocusNode,
                  labelText: MyStrings.state.tr,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                  onSuffixTap: () {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return MyStrings.fieldErrorMsg.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: Dimensions.space12),
                CustomTextField(
                  controller: controller.countryController,
                  textInputType: TextInputType.name,
                  focusNode: controller.countryFocusNode,
                  nextFocus: controller.cityFocusNode,
                  labelText: MyStrings.country.tr,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                  onSuffixTap: () {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return MyStrings.fieldErrorMsg.tr;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: Dimensions.space12),
                CustomTextField(
                  controller: controller.addressController,
                  textInputType: TextInputType.name,
                  focusNode: controller.addressFocusNode,
                  maxLines: 6,
                  labelText: MyStrings.address.tr,
                  animatedLabel: true,
                  needOutlineBorder: true,
                  onChanged: (value) {},
                  onSuffixTap: () {},
                ),
                const SizedBox(height: Dimensions.space25),
                RoundedButton(
                  text: MyStrings.save,
                  press: () {
                    if (formKey.currentState!.validate()) {
                      Get.back();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
