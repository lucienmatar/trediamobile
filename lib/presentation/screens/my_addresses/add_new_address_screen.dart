import 'package:ShapeCom/config/utils/my_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_strings.dart';
import '../../../config/utils/util.dart';
import '../../../domain/controller/auth/auth/controller_map.dart';
import '../../../domain/controller/menu_screen/add_new_address_controller.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/buttons/rounded_button.dart';
import '../../components/snack_bar/show_custom_snackbar.dart';
import '../../components/text-form-field/custom_text_field.dart';
import '../menu/my_addresses_screen.dart';
import 'create_address_screen.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  var addNewAddressController = Get.put(AddNewAddressController());
  final _fieldKey7 = GlobalKey<FormFieldState>();
  final ControllerMap controllerMap = Get.put(ControllerMap());
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Fallback: San Francisco
    zoom: 10,
  );

  void _onCameraMove(CameraPosition position) {
    addNewAddressController.currentPosition = position;
    //MyConstants.mapLat = position.target.latitude;
    //MyConstants.mapLong = position.target.longitude;
  }

  Future<void> _checkGps() async {
    // Check if location services (GPS) are enabled
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    /*setState(() {
      if (isLocationServiceEnabled) {
        _gpsStatus = "GPS is enabled";
      } else {
        _gpsStatus = "GPS is disabled";
      }
    });*/

    // If GPS is disabled, prompt the user to enable it
    if (!isLocationServiceEnabled) {
      showGPSDialog();
    }
  }

  showGPSDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(MyStrings.GPSIsDisabled),
          content: Text(MyStrings.locationPermission),
          actions: [
            TextButton(
              child: Text(MyStrings.cancel),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(MyStrings.settings),
              onPressed: () async {
                // Open location settings
                await Geolocator.openLocationSettings();
                Navigator.of(context).pop(); // Close the dialog
                // Recheck GPS status after returning from settings
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkGps();
  }

  @override
  Widget build(BuildContext context) {
    try {
      var data = Get.arguments;
      addNewAddressController.isFromEdit = data['fromedit'];
      print("*****");
      print("addNewAddressController isFromEdit ${addNewAddressController.isFromEdit}");
      if (data['fromedit']) {
        if (!addNewAddressController.isFromEditValueSet) {
          addNewAddressController.isFromEditValueSet = true;
          MyConstants.mapLat = data['Latitude'];
          MyConstants.mapLong = data['Longitude'];
          LatLng mapPosition;
          mapPosition = LatLng(MyConstants.mapLat, MyConstants.mapLong);
          _initialPosition = CameraPosition(
            target: LatLng(MyConstants.mapLat, MyConstants.mapLong),
            zoom: 10,
          );
          /*CameraPosition cameraPosition = CameraPosition(
          target: mapPosition ?? LatLng(0, 0), // Fallback
          zoom: 10,
        );*/
          print("_CreateAddressScreenState mapPosition ${mapPosition.toString()}");
          controllerMap.currentPosition.value = mapPosition;
          //controllerMap.markers.clear();
          //controllerMap.addMarker(position: mapPosition!, id: 'new_marker');
          controllerMap.moveCamera(mapPosition!);
          controllerMap.update();
          addNewAddressController.update();
        }
      }
    } catch (e) {
      print("addNewAddressController err ${e.toString()}");
    }
    final screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        MyConstants.isMapinEditMode = false;
        if (addNewAddressController.isFromEdit) {
          Get.back(result: 'success');
          return false;
        }
        Get.off(MyAddressesScreen());
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: MyColor.getScreenBgColor(),
          body: GetBuilder<AddNewAddressController>(
            builder: (controller) => Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        MyConstants.isMapinEditMode = false;
                        if (addNewAddressController.isFromEdit) {
                          Get.back(result: 'success');
                        } else {
                          Get.off(MyAddressesScreen());
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TypeAheadField(
                        builder: (context, TextEditingController controller, FocusNode focusNode) {
                          addNewAddressController.searchLocationController = controller;
                          return CustomTextField(
                            focusNode: focusNode,
                            animatedLabel: true,
                            needOutlineBorder: true,
                            labelText: MyStrings.enterLocation,
                            controller: controller,
                            onChanged: (val) {
                              if (addNewAddressController.searchLocationController.text.isNotEmpty) {
                                if (_fieldKey7.currentState!.validate()) {}
                              }
                            },
                            fieldKey: _fieldKey7,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return MyStrings.enterYourLocation;
                              } else {
                                return null;
                              }
                            },
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
                            return await addNewAddressController.fetchPlaceSuggestions(pattern);
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
                          final placeDetails = await addNewAddressController.fetchPlaceDetails(placeId);
                          final latitude = placeDetails['geometry']['location']['lat'];
                          final longitude = placeDetails['geometry']['location']['lng'];
                          print('Place: ${suggestion['description']}, Lat: $latitude, Lng: $longitude');
                          addNewAddressController.searchLocationController.text = MyStrings.searching;
                          //MyConstants.mapLat = latitude;
                          //MyConstants.mapLong = longitude;
                          LatLng position = LatLng(latitude, longitude);
                          //controllerMap.markers.clear();
                          //controllerMap.addMarker(position: position, id: 'new_marker');
                          addNewAddressController.searchLocationController.text = suggestion['description'];
                          // Animate the camera to the new marker
                          controllerMap.moveCamera(position);
                          controllerMap.update();
                          addNewAddressController.update();
                          try {
                            // Close the keyboard
                            FocusScope.of(context).unfocus();
                            _fieldKey7.currentState!.validate();
                          } catch (e) {
                            print("AddNewAddressScreen err 1 ${e.toString()}");
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: () {
                          if (addNewAddressController.searchLocationController.text.isNotEmpty) {
                            if (_fieldKey7.currentState!.validate()) {}
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenHeight - MediaQuery.of(context).padding.top - kToolbarHeight - 110,
                  child: Stack(
                    children: [
                      GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        mapToolbarEnabled: true,
                        onCameraMove: _onCameraMove,
                        tiltGesturesEnabled: true,
                        onTap: (LatLng position) async {
                          /* try {
                            MyConstants.mapLat = position.latitude;
                            MyConstants.mapLong = position.longitude;
                            print("GoogleMap onTap ${position.latitude} ${position.longitude}");
                            controllerMap.markers.clear();
                            controllerMap.addMarker(position: position, id: 'new_marker');
                            addNewAddressController.searchLocationController.text = MyStrings.searching;
                            controllerMap.update();
                            addNewAddressController.update();
                            addNewAddressController.searchLocationController.text = await MyUtils.getAddressFromLatLong(position.latitude, position.longitude);
                          } catch (e) {
                            print("GoogleMap onTap error ${e.toString()}");
                          }*/
                        },
                        initialCameraPosition: _initialPosition,
                        onMapCreated: controllerMap.onMapCreated,
                        markers: controllerMap.markers,
                        polylines: controllerMap.polylines,
                        mapType: controllerMap.mapType,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                      ),

                      // Center pin icon
                      Center(
                        child: IgnorePointer(
                          child: Image.asset(
                            'assets/images/pin.png',
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 50,
                        right: 20,
                        child: InkWell(
                          onTap: () async {
                            controllerMap.getCurrentLocation();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20), // Circular padding
                            decoration: const BoxDecoration(
                              color: MyColor.primaryColor,
                              shape: BoxShape.circle, // Makes the Container circular
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.my_location,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(15.0),
            child: RoundedButton(
              cornerRadius: 10,
              color: MyColor.primaryColor,
              text: MyStrings.confirm.tr,
              press: () {
                MyConstants.isMapinEditMode = false;
                print("addNewAddressController.isFromEdit=${addNewAddressController.isFromEdit}");
                if (addNewAddressController.isFromEdit) {
                  MyConstants.mapLat = addNewAddressController.currentPosition!.target.latitude;
                  MyConstants.mapLong = addNewAddressController.currentPosition!.target.longitude;
                  Get.back(result: 'success');
                } else {
                  print("from map screen lat=${MyConstants.mapLat}andlong=${MyConstants.mapLong}");
                  if (addNewAddressController.currentPosition!.target.latitude > 0 && addNewAddressController.currentPosition!.target.longitude > 0) {
                    MyConstants.mapLat = addNewAddressController.currentPosition!.target.latitude;
                    MyConstants.mapLong = addNewAddressController.currentPosition!.target.longitude;
                    Get.off(CreateAddressScreen());
                  } else {
                    CustomSnackBar.error(errorList: ["${MyStrings.please} ${MyStrings.enterLocation}"]);
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
