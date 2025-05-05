import 'package:ShapeCom/presentation/screens/auth/registration/model/country_code_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/config/utils/dimensions.dart';
import 'package:ShapeCom/config/utils/my_color.dart';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:ShapeCom/config/utils/style.dart';
import 'package:ShapeCom/domain/controller/auth/auth/registration_controller.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_button.dart';
import 'package:ShapeCom/presentation/components/buttons/rounded_loading_button.dart';
import 'package:ShapeCom/presentation/components/text-form-field/custom_text_field.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../config/utils/my_images.dart';
import '../../../../../config/utils/util.dart';
import '../../../../../domain/controller/auth/auth/controller_map.dart';
import '../../../../components/image/custom_svg_picture.dart';
import 'package:ShapeCom/presentation/screens/auth/registration/model/town_model.dart' as townData;

import '../../../../components/snack_bar/show_custom_snackbar.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final formKey = GlobalKey<FormState>();
  final ControllerMap controllerMap = Get.put(ControllerMap());
  var registrationController = Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      builder: (controller1) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      animatedLabel: true,
                      needOutlineBorder: true,
                      prefixIcon: MyImages.user,
                      labelText: MyStrings.firstname,
                      controller: registrationController.firstNameController,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return MyStrings.enterYourUsername;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        return;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      animatedLabel: true,
                      needOutlineBorder: true,
                      labelText: MyStrings.middleName,
                      controller: registrationController.middleNameController,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return MyStrings.enterYourUsername;
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        return;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.space16),
              CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: MyStrings.lastName,
                controller: registrationController.lastNameController,
                inputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourUsername;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              const SizedBox(height: Dimensions.space16),
              Text(MyStrings.selectGender, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
              const SizedBox(height: Dimensions.space16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Equal spacing
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        registrationController.selectedGender = "M";
                        registrationController.update();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: (registrationController.selectedGender == "M") ? MyColor.primaryColor : MyColor.colorBlack.withOpacity(0.3), width: 1), // Border
                          borderRadius: BorderRadius.circular(10), // Rounded border
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(Icons.male, color: MyColor.colorBlack.withOpacity(0.5), size: 30),
                            const SizedBox(width: 15),
                            Text(MyStrings.male, style: regularLarge.copyWith(color: MyColor.colorBlack.withOpacity(0.8))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 50), // Space between containers
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        registrationController.selectedGender = "F";
                        registrationController.update();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: (registrationController.selectedGender == "F") ? MyColor.primaryColor : MyColor.colorBlack.withOpacity(0.3), width: 1), // Border
                          borderRadius: BorderRadius.circular(10), // Rounded border
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(Icons.female, color: MyColor.colorBlack.withOpacity(0.5), size: 30),
                            const SizedBox(width: 15),
                            Text(MyStrings.female, style: regularLarge.copyWith(color: MyColor.colorBlack.withOpacity(0.8))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.space16),
              CustomTextField(
                prefixIcon: MyImages.textFieldEmail,
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: MyStrings.email,
                controller: registrationController.emailController,
                textInputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return MyStrings.enterYourEmail;
                  } else if (!MyStrings.emailValidatorRegExp.hasMatch(value ?? '')) {
                    return MyStrings.invalidEmailMsg;
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  return;
                },
              ),
              const SizedBox(height: Dimensions.space16),
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
                              registrationController.selectedCountryCode = await showCountryCodeBottomSheet(context);
                              if (registrationController.selectedCountryCode != null) {
                                print('Selected country code: ${registrationController.selectedCountryCode}');
                                registrationController.update();
                              }
                            },
                            child: Icon(Icons.phone, color: MyColor.colorBlack.withOpacity(0.5), size: 25)),
                        //Image.asset(MyImages.phone, height: 20, width: 20),
                        const SizedBox(width: 10),
                        InkWell(
                            onTap: () async {
                              registrationController.selectedCountryCode = await showCountryCodeBottomSheet(context);
                              if (registrationController.selectedCountryCode != null) {
                                print('Selected country code: ${registrationController.selectedCountryCode}');
                                registrationController.update();
                              }
                            },
                            child: Text(registrationController.selectedCountryCode!, style: regularLarge.copyWith(color: MyColor.colorBlack.withOpacity(0.8)))),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: registrationController.mobileController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: MyStrings.phoneNumber, border: InputBorder.none), // Removes the bottom line)
                            validator: (value) {
                              if (value!.isEmpty) {
                                registrationController.mobileErrorMessage = MyStrings.fieldErrorMsg;
                              } else if (value.toString().length != 10) {
                                registrationController.mobileErrorMessage = MyStrings.mobileErrorMsg;
                              } else {
                                registrationController.mobileErrorMessage = null;
                              }
                              registrationController.update();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Error message below
                  if (registrationController.mobileErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        registrationController.mobileErrorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Dimensions.space16),
              Text(MyStrings.selectTown, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
              const SizedBox(height: Dimensions.space16),
              InkWell(
                onTap: () async {
                  registrationController.selectedTown = await showTownBottomSheet(context);
                  if (registrationController.selectedTown != null) {
                    print('Selected town: ${registrationController.selectedTown}');
                    registrationController.update();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColor.colorBlack.withOpacity(0.3), width: 1), // Border
                    borderRadius: BorderRadius.circular(20), // Rounded border
                  ),
                  child: Row(
                    children: [
                      CustomSvgPicture(
                        image: MyImages.town,
                        color: MyColor.iconColor.withOpacity(0.8),
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(registrationController.selectedTownName!, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                    ],
                  ),
                ),
              ),
              /*Container(
                      height: 62,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: MyColor.colorLightGrey,
                        borderRadius: BorderRadiusDirectional.circular(20),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: controller.selectedTown!.isEmpty ? null : controller.selectedTown, // Ensure null for hint to show
                          hint: Row(
                            children: [
                              SvgPicture.asset(
                                MyImages.town,
                                fit: BoxFit.none,
                              ),
                              const SizedBox(width: 10),
                              Text(MyStrings.selectTown, style: regularLarge.copyWith(color: MyColor.colorBlack.withOpacity(0.8))),
                            ],
                          ),
                          icon: const Icon(Icons.arrow_drop_down, color: MyColor.colorGrey),
                          items: controller.townList!.map((Map<String, String> item) {
                            return DropdownMenuItem<String>(
                              value: item['value'] ?? '', // Ensure it's a String
                              child: Text(item['display'] ?? ''), // Displaying city name
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedTown = value;
                              print("Selected town Code: $value");
                              controller.update();
                            }
                          },
                        ),
                      ),
                    )*/
              const SizedBox(height: Dimensions.space16),
              CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                isShowSuffixIcon: true,
                maxLines: 3,
                labelText: MyStrings.address,
                controller: registrationController.addressController,
                textInputType: TextInputType.multiline,
                inputAction: TextInputAction.next,
                onChanged: (value) {},
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return MyStrings.enterYourAddress;
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: Dimensions.space16),
              // CustomTextField(
              //   animatedLabel: true,
              //   needOutlineBorder: true,
              //   labelText: MyStrings.searchLocation,
              //   controller: registrationController.searchLocationController,
              //   inputAction: TextInputAction.next,
              //   validator: (value) {
              //     /* if (value != null && value.isEmpty) {
              //       return MyStrings.enterYourEmail;
              //     } else if (!MyStrings.emailValidatorRegExp.hasMatch(value ?? '')) {
              //       return MyStrings.invalidEmailMsg;
              //     } else {
              //       return null;
              //     }*/
              //     return null;
              //   },
              //   onChanged: (value) {
              //     return;
              //   },
              // ),
              TypeAheadField(
                builder: (context, TextEditingController controller, FocusNode focusNode) {
                  registrationController.searchLocationController = controller;
                  return CustomTextField(
                    focusNode: focusNode,
                    animatedLabel: true,
                    needOutlineBorder: true,
                    labelText: MyStrings.searchLocation,
                    controller: controller,
                    onChanged: null,
                  );
                },
                decorationBuilder: (BuildContext context, Widget child) {
                  return Material(
                    color: Colors.white, // Background color for suggestion box
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    elevation: 4.0, // Shadow
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300), // Border
                      ),
                      child: child, // The suggestion list
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  if (pattern.isNotEmpty) {
                    return await registrationController.fetchPlaceSuggestions(pattern);
                  }
                  return [];
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['description']),
                  );
                },
                onSelected: (suggestion) async {
                  // Handle selected place (e.g., get place details)
                  CustomSnackBar.success(successList: [MyStrings.pleaseWaitWhileGettingLocation]);
                  print('Selected: ${suggestion['description']}');
                  final placeId = suggestion['place_id'];
                  final placeDetails = await registrationController.fetchPlaceDetails(placeId);
                  final latitude = placeDetails['geometry']['location']['lat'];
                  final longitude = placeDetails['geometry']['location']['lng'];
                  print('Place: ${suggestion['description']}, Lat: $latitude, Lng: $longitude');
                  registrationController.searchLocationController.text = MyStrings.searching;
                  LatLng position = LatLng(latitude, longitude);
                  controllerMap.markers.clear();
                  controllerMap.addMarker(position: position, id: 'new_marker');
                  registrationController.searchLocationController.text = suggestion['description'];
                  // Animate the camera to the new marker
                  controllerMap.moveCamera(position);
                  controllerMap.update();
                  registrationController.update();
                  try {
                    // Close the keyboard
                    FocusScope.of(context).unfocus();
                  } catch (e) {}
                },
              ),
              const SizedBox(height: Dimensions.space16),
              SizedBox(
                height: 300,
                child: GoogleMap(
                  myLocationEnabled: true, // Show blue dot
                  myLocationButtonEnabled: true, // Show GPS button
                  zoomGesturesEnabled: true,
                  onTap: (LatLng position) async {
                    try {
                      print("GoogleMap onTap ${position.latitude} ${position.longitude}");
                      controllerMap.markers.clear();
                      controllerMap.addMarker(position: position, id: 'new_marker');
                      registrationController.searchLocationController.text = MyStrings.searching;
                      controllerMap.update();
                      registrationController.update();
                      registrationController.searchLocationController.text = await MyUtils.getAddressFromLatLong(position.latitude, position.longitude);
                    } catch (e) {
                      print("GoogleMap onTap error ${e.toString()}");
                    }
                  },
                  initialCameraPosition: controllerMap.initialPosition,
                  onMapCreated: controllerMap.onMapCreated,
                  markers: controllerMap.markers,
                  polylines: controllerMap.polylines,
                  mapType: controllerMap.mapType,
                  zoomControlsEnabled: true,
                  compassEnabled: true,
                ),
              ),
              /*const SizedBox(height: Dimensions.space16),
              CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                isShowSuffixIcon: true,
                isPassword: true,
                labelText: MyStrings.password,
                controller: controller.passwordController,
                textInputType: TextInputType.text,
                inputAction: TextInputAction.next,
                onChanged: (value) {
                  if (controller.checkPasswordStrength) {}
                },
                validator: (value) {
                  return controller.validatePassword(value ?? '');
                },
              ),
              const SizedBox(height: Dimensions.space16),
              CustomTextField(
                animatedLabel: true,
                needOutlineBorder: true,
                labelText: MyStrings.confirmPassword,
                controller: controller.cPasswordController,
                inputAction: TextInputAction.done,
                isShowSuffixIcon: true,
                isPassword: true,
                onChanged: (value) {},
                validator: (value) {
                  if (controller.passwordController.text.toLowerCase() != controller.cPasswordController.text.toLowerCase()) {
                    return MyStrings.kMatchPassError;
                  } else {
                    return null;
                  }
                },
              ),*/
              const SizedBox(height: Dimensions.space25),
              registrationController.submitLoading
                  ? const RoundedLoadingBtn()
                  : RoundedButton(
                      text: MyStrings.signUp,
                      press: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        registrationController.update();
                        if (formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          if (registrationController.selectedGender == null || registrationController.selectedGender!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(MyStrings.selectGender)),
                            );
                          } else {
                            registrationController.registerApi(controllerMap.currentPosition.value!.latitude, controllerMap.currentPosition.value!.longitude);
                          }
                        }
                      }),
            ],
          ),
        );
      },
    );
  }

  Future<String?> showCountryCodeBottomSheet(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    RxList<Data> filteredList = registrationController.countryCodeModel!.data!.obs;

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
                  filteredList.value = registrationController.countryCodeModel!.data!.where((country) => country.display!.toLowerCase().contains(value.toLowerCase())).toList();
                } else {
                  filteredList.value = registrationController.countryCodeModel!.data!.obs;
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
                    onTap: () => Get.back(result: filteredList[index].value),
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

  Future<String?> showTownBottomSheet(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    RxList<townData.Data> filteredList = registrationController.townModel!.data!.obs;

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
                hintText: MyStrings.selectTown,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: MyColor.primaryColor),
                ),
              ),
              onChanged: (value) {
                print("onChanged value $value");
                if (value.isNotEmpty) {
                  filteredList.value = registrationController.townModel!.data!.where((country) => country.display!.toLowerCase().contains(value.toLowerCase())).toList();
                } else {
                  filteredList.value = registrationController.townModel!.data!.obs;
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
                      registrationController.selectedTownName = filteredList[index].display!;
                      print("selectedTownName ${registrationController.selectedTownName}");
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
