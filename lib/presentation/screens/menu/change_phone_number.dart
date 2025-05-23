import 'package:ShapeCom/config/route/route.dart';
import 'package:ShapeCom/domain/controller/cart_controller/cartController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/forget_password/forget_password_controller.dart';
import 'package:ShapeCom/presentation/components/app-bar/custom_appbar.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/text-form-field/custom_text_field.dart';
import 'package:ShapeCom/presentation/components/text/default_text.dart';
import 'package:ShapeCom/presentation/components/text/header_text.dart';
import '../../../presentation/screens/auth/registration/model/country_code_model.dart' as data;
import '../../../../../config/utils/my_images.dart';
import '../../../domain/controller/menu_screen/change_phone_number_controller.dart';
import '../auth/profile_complete/profile_complete_screen.dart';

class ChangePhoneNumberScreen extends StatefulWidget {
  const ChangePhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<ChangePhoneNumberScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ChangePhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final ChangePhoneNumberController changePhoneNumberController = Get.put(ChangePhoneNumberController());
  final _fieldKey5 = GlobalKey<FormFieldState>();

  @override
  void initState() {
    Get.put(CartCountController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(ProfileCompleteScreen());
        return false;
      },
      child: Scaffold(
          backgroundColor: MyColor.getScreenBgColor(),
          appBar: CustomAppBar(
            fromAuth: false,
            isShowBackBtn: true,
            title: MyStrings.changePhoneNumber,
            bgColor: MyColor.getAppBarColor(),
            actionPress: (){
              Get.off(ProfileCompleteScreen());
            },
          ),
          body: GetBuilder<ChangePhoneNumberController>(
            builder: (controller) => SingleChildScrollView(
              padding: Dimensions.screenPaddingHV,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Dimensions.space30),
                    HeaderText(text: MyStrings.changePhoneNumber),
                    const SizedBox(height: Dimensions.space40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: MyColor.colorBlack.withOpacity(0.3), width: 1), // Border
                            borderRadius: BorderRadius.circular(20), // Rounded border
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              InkWell(
                                  onTap: () async {
                                    changePhoneNumberController.selectedCountryCode = await showCountryCodeBottomSheet(context);
                                    if (changePhoneNumberController.selectedCountryCode != null) {
                                      print('Selected country code: ${changePhoneNumberController.selectedCountryCode}');
                                      changePhoneNumberController.update();
                                    }
                                  },
                                  child: Icon(Icons.phone, color: MyColor.colorBlack.withOpacity(0.5), size: 25)),
                              //Image.asset(MyImages.phone, height: 20, width: 20),
                              const SizedBox(width: 10),
                              InkWell(
                                  onTap: () async {
                                    changePhoneNumberController.selectedCountryCode = await showCountryCodeBottomSheet(context);
                                    if (changePhoneNumberController.selectedCountryCode != null) {
                                      print('Selected country code: ${changePhoneNumberController.selectedCountryCode}');
                                      changePhoneNumberController.update();
                                    }
                                  },
                                  child: Text(changePhoneNumberController.selectedCountryCode!, style: regularLarge.copyWith(color: MyColor.colorBlack.withOpacity(0.8)))),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  key: _fieldKey5,
                                  onChanged: (val) {
                                    if (changePhoneNumberController.mobileController.text.isNotEmpty) {
                                      if (_fieldKey5.currentState!.validate()) {
                                        changePhoneNumberController.isSubmit = false;
                                        changePhoneNumberController.update();
                                      }
                                    } else {
                                      changePhoneNumberController.isSubmit = true;
                                      changePhoneNumberController.update();
                                    }
                                  },
                                  controller: changePhoneNumberController.mobileController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(hintText: MyStrings.phoneNumber, border: InputBorder.none), // Removes the bottom line)
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      changePhoneNumberController.mobileErrorMessage = MyStrings.fieldErrorMsg;
                                    }
                                    // else if (value.toString().length != 10) {
                                    //   registrationController.mobileErrorMessage = MyStrings.mobileErrorMsg;
                                    // }
                                    else {
                                      changePhoneNumberController.mobileErrorMessage = null;
                                    }
                                    changePhoneNumberController.update();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Error message below
                        if (changePhoneNumberController.mobileErrorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 10),
                            child: Text(
                              changePhoneNumberController.mobileErrorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.space25),
                    controller.submitLoading
                        ? const RoundedLoadingBtn()
                        : RoundedButton(
                            color: changePhoneNumberController.isSubmit ? MyColor.colorLightGrey : MyColor.primaryColor,
                            press: () {
                              if (changePhoneNumberController.isSubmit == false) {
                                if (_formKey.currentState!.validate()) {
                                  changePhoneNumberController.changePhoneNumberApi();
                                }
                              }
                            },
                            text: MyStrings.continueButton,
                          ),
                    const SizedBox(height: Dimensions.space40)
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<String?> showCountryCodeBottomSheet(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    RxList<data.Data> filteredList = changePhoneNumberController.countryCodeModel!.data!.obs;

    return await Get.bottomSheet<String>(
      Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: MyStrings.searchCountry,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: MyColor.primaryColor),
                ),
              ),
              onChanged: (value) {
                print("onChanged value $value");
                if (value.isNotEmpty) {
                  filteredList.value = changePhoneNumberController.countryCodeModel!.data!.where((country) => country.display!.toLowerCase().contains(value.toLowerCase())).toList();
                } else {
                  filteredList.value = changePhoneNumberController.countryCodeModel!.data!.obs;
                }
              },
            ),
            const SizedBox(height: 10),
            Expanded(
                child: Obx(
              () => ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredList[index].display!),
                    onTap: () {
                      changePhoneNumberController.isSubmit = false;
                      changePhoneNumberController.update();
                      Get.back(result: filteredList[index].value);
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
