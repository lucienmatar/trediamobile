import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:ShapeCom/presentation/screens/auth/registration/model/town_model.dart' as townData;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_images.dart';
import '../../../config/utils/my_strings.dart';
import '../../../config/utils/style.dart';
import '../../../config/utils/util.dart';
import '../../../domain/controller/account/profile_complete_controller.dart';
import '../../../domain/controller/auth/auth/controller_map.dart';
import '../../../domain/controller/menu_screen/add_new_address_controller.dart';
import '../../../domain/controller/menu_screen/create_address_controller.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/buttons/rounded_button.dart';
import '../../components/buttons/rounded_loading_button.dart';
import '../../components/image/custom_svg_picture.dart';
import '../../components/snack_bar/show_custom_snackbar.dart';
import '../../components/text-form-field/custom_text_field.dart';
import '../../components/text-form-field/custom_text_field_square.dart';
import '../menu/my_addresses_screen.dart';

class CreateAddressScreen extends StatefulWidget {
  const CreateAddressScreen({super.key});

  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  var createAddressController = Get.put(CreateAddressController());
  final formKey = GlobalKey<FormState>();
  ControllerMap controllerMap = Get.put(ControllerMap());
  CameraPosition? cameraPosition;
  @override
  Widget build(BuildContext context) {
    try {
      var data = Get.arguments;
      if (data != null) {
        createAddressController.fromEdit = data['fromedit'];
      }
      createAddressController.getAllTownApi(callback: () {
        if (createAddressController.fromEdit) {
          createAddressController.AddressID = data['AddressID'];
          createAddressController.TownID = data['TownID'];
          createAddressController.QazaTown = data['QazaTown'];
          createAddressController.selectedTownName = createAddressController.QazaTown;
          print("createAddressController.selectedTownName ${createAddressController.selectedTownName}");
          createAddressController.addressController.text = data['AddressDetails'];
          createAddressController.isSubmitDisable = false;
          createAddressController.update();
        }
      });
      if (createAddressController.fromEdit) {
        var Longitude = data['Longitude'];
        var Latitude = data['Latitude'];
        MyConstants.mapLat = Latitude;
        MyConstants.mapLong = Longitude;
      }
      LatLng mapPosition;
      mapPosition = LatLng(MyConstants.mapLat, MyConstants.mapLong);
      cameraPosition = CameraPosition(
        target: mapPosition ?? LatLng(0, 0), // Fallback
        zoom: 10,
      );
      print("_CreateAddressScreenState mapPosition ${mapPosition.toString()}");
      controllerMap.currentPosition.value = mapPosition;
      controllerMap.markers.clear();
      controllerMap.addMarker(position: mapPosition!, id: 'new_marker');
      controllerMap.moveCamera(mapPosition!);
      controllerMap.update();
    } catch (e) {
      print("_CreateAddressScreenState err ${e.toString()}");
    }
    return WillPopScope(
      onWillPop: () async {
        Get.off(MyAddressesScreen());
        return false;
      },
      child: Scaffold(
        backgroundColor: MyColor.getScreenBgColor(),
        appBar: CustomAppBar(
          title: MyStrings.addresses.tr,
          isShowBackBtn: true,
          fromAuth: false,
          isProfileCompleted: false,
          bgColor: MyColor.getAppBarColor(),
          actionPress: () {
            Get.off(MyAddressesScreen());
          },
        ),
        body: GetBuilder<CreateAddressController>(
          builder: (controller) => SingleChildScrollView(
            padding: Dimensions.screenPaddingHV,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              MyStrings.locationPin,
                              style: boldLarge,
                              maxLines: 1,
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(RouteHelper.addNewAddressScreen, arguments: {'fromedit': true})!.then((result) {
                                  controllerMap = Get.put(ControllerMap());
                                  print("refresh location");
                                  print("MyConstants.mapLat${MyConstants.mapLat}");
                                  print("MyConstants.mapLong${MyConstants.mapLong}");
                                  LatLng mapPosition = LatLng(MyConstants.mapLat, MyConstants.mapLong);
                                  controllerMap.markers.clear();
                                  controllerMap.addMarker(position: mapPosition, id: 'new_marker');
                                  Future.delayed(Duration(seconds: 2), () {
                                    //controllerMap.moveCamera(mapPosition);
                                    print("refresh location moveCamera");
                                    controllerMap.update();
                                    print("refresh location update");
                                  });
                                  Future.delayed(Duration(seconds: 2), () {
                                    createAddressController.update();
                                  });
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: MyColor.paidContentColor, width: 1), // Border
                                  borderRadius: BorderRadius.circular(10), // Rounded border
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // Fit content
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: MyColor.paidContentColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8), // Space between icon and text
                                    Text(
                                      MyStrings.refineMap,
                                      style: mediumDefault.copyWith(color: MyColor.paidContentColor),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: Dimensions.space20),
                        SizedBox(
                          height: 200,
                          child: GoogleMap(
                            myLocationEnabled: true, // Show blue dot
                            myLocationButtonEnabled: true, // Show GPS button
                            zoomGesturesEnabled: true,
                            onTap: (LatLng position) async {
                              try {
                                print("GoogleMap onTap ${position.latitude} ${position.longitude}");
                                controllerMap.markers.clear();
                                controllerMap.addMarker(position: position, id: 'new_marker');
                                controllerMap.moveCamera(position);
                                createAddressController.searchLocationController.text = MyStrings.searching;
                                controllerMap.update();
                                createAddressController.update();
                                createAddressController.searchLocationController.text = await MyUtils.getAddressFromLatLong(position.latitude, position.longitude);
                              } catch (e) {
                                print("GoogleMap onTap error ${e.toString()}");
                              }
                            },
                            initialCameraPosition: createAddressController.fromEdit ? cameraPosition! : controllerMap.initialPosition,
                            onMapCreated: controllerMap.onMapCreated,
                            markers: controllerMap.markers,
                            polylines: controllerMap.polylines,
                            mapType: controllerMap.mapType,
                            zoomControlsEnabled: true,
                            compassEnabled: true,
                          ),
                        ),
                        const SizedBox(height: Dimensions.space25),
                        InkWell(
                          onTap: () async {
                            createAddressController.selectedTown = await showTownBottomSheet(context);
                            if (createAddressController.selectedTown != null) {
                              print('Selected town: ${createAddressController.selectedTown}');
                              createAddressController.update();
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
                                  child: Text(createAddressController.selectedTownName!, style: regularLarge.copyWith(color: MyColor.secondaryTextColor)),
                                ),
                                Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.space20),
                        CustomTextFieldSquare(
                          animatedLabel: true,
                          needOutlineBorder: true,
                          labelText: MyStrings.address,
                          maxLines: 3,
                          hintText: "${MyStrings.enterYour.tr} ${MyStrings.address.toLowerCase()}",
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          controller: controller.addressController,
                          onChanged: (value) {
                            if (MyConstants.mapLat > 0 && MyConstants.mapLong > 0 && createAddressController.selectedTownName != null && createAddressController.selectedTownName!.isNotEmpty && createAddressController.selectedTownName != MyStrings.selectTown && createAddressController.addressController.text.isNotEmpty) {
                              createAddressController.isSubmitDisable = false;
                            } else {
                              createAddressController.isSubmitDisable = true;
                            }
                            createAddressController.update();
                            return;
                          },
                        ),
                        const SizedBox(height: Dimensions.space16),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.space16),
                  RoundedButton(
                    cornerRadius: 10,
                    color: createAddressController.isSubmitDisable ? MyColor.colorLightGrey : MyColor.primaryColor,
                    text: MyStrings.confirm,
                    press: () {
                      if (createAddressController.isSubmitDisable == false) {
                        if (formKey.currentState!.validate()) {
                          createAddressController.addAddressApi();
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> showTownBottomSheet(BuildContext context) async {
    TextEditingController searchController = TextEditingController();
    RxList<townData.Data> filteredList = createAddressController.townModel!.data!.obs;

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
                  filteredList.value = createAddressController.townModel!.data!.where((country) => country.display!.toLowerCase().contains(value.toLowerCase())).toList();
                } else {
                  filteredList.value = createAddressController.townModel!.data!.obs;
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
                      createAddressController.selectedTownName = filteredList[index].display!;
                      print("selectedTownName ${createAddressController.selectedTownName}");
                      if (MyConstants.mapLat > 0 && MyConstants.mapLong > 0 && createAddressController.selectedTownName != null && createAddressController.selectedTownName!.isNotEmpty && createAddressController.selectedTownName != MyStrings.selectTown && createAddressController.addressController.text.isNotEmpty) {
                        createAddressController.isSubmitDisable = false;
                        createAddressController.update();
                      }
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
