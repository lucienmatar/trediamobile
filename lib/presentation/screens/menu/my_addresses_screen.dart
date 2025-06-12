import 'package:ShapeCom/config/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/route/route.dart';
import '../../../config/utils/dimensions.dart';
import '../../../config/utils/my_color.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_strings.dart';
import '../../../config/utils/style.dart';
import '../../../domain/controller/menu_screen/my_address_controller.dart';
import '../../components/app-bar/custom_appbar.dart';
import '../../components/buttons/rounded_button.dart';
import '../../components/snack_bar/show_custom_snackbar.dart';
import '../my_addresses/add_new_address_screen.dart';
import '../my_addresses/create_address_screen.dart';

class MyAddressesScreen extends StatefulWidget {
  const MyAddressesScreen({super.key});

  @override
  State<MyAddressesScreen> createState() => _MyAddressesScreenState();
}

class _MyAddressesScreenState extends State<MyAddressesScreen> {
  var myAddressController = Get.put(MyAddressController());
  Future<void> _requestLocationPermission() async {
    // Request location permission
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Permission granted, proceed with location access
      _checkGps();
    } else if (status.isDenied) {
      // Permission denied
      print("Location permission denied");
      CustomSnackBar.error(errorList: [MyStrings.locationPermission]);
      /* ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Location permission is required to use this feature.")),
      );*/
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      print("Location permission permanently denied");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(MyStrings.locationPermission),
          action: SnackBarAction(
            label: MyStrings.settings,
            onPressed: () {
              openAppSettings(); // Opens app settings
            },
          ),
        ),
      );
    }
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
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.getScreenBgColor(),
      appBar: CustomAppBar(
        title: MyStrings.myAddress.tr,
        isShowBackBtn: true,
        fromAuth: false,
        isProfileCompleted: false,
        bgColor: MyColor.getAppBarColor(),
      ),
      body: GetBuilder<MyAddressController>(
        builder: (controller) => SingleChildScrollView(
          padding: Dimensions.screenPaddingHV,
          child: myAddressController.isLoading
              ? buildShimmerEffect()
              : myAddressController.myAddressesCount > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myAddressController.myAddressesCount,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_pin, color: Colors.red, size: 30),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myAddressController.myAddressesModel?.data?.addresses?[index].qazaTown ?? "",
                                      style: semiBoldExtraLarge,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      myAddressController.myAddressesModel?.data?.addresses?[index].addressDetails ?? "",
                                      style: regularSmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      // Handle edit
                                      //print("pass.mapLat ${myAddressController.myAddressesModel!.data!.addresses![index].latitude}");
                                      //print("pass.mapLong ${myAddressController.myAddressesModel!.data!.addresses![index].longitude}");
                                      Get.off(CreateAddressScreen(), arguments: {'fromedit': true, "AddressID": myAddressController.myAddressesModel?.data?.addresses?[index].addressID ?? "0", "TownID": myAddressController.myAddressesModel?.data?.addresses?[index].townID ?? "0", "QazaTown": myAddressController.myAddressesModel?.data?.addresses?[index].qazaTown ?? "", "AddressDetails": myAddressController.myAddressesModel?.data?.addresses?[index].addressDetails ?? "", "Longitude": myAddressController.myAddressesModel!.data!.addresses![index].longitude, "Latitude": myAddressController.myAddressesModel!.data!.addresses![index].latitude});
                                    },
                                    child: Text(
                                      MyStrings.edit,
                                      style: regularSmall.copyWith(color: MyColor.paidContentColor),
                                      maxLines: 1,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle delete
                                      showDeleteAddressDialog(onConfirm: () {
                                        myAddressController.deleteMyAddresses(myAddressController.myAddressesModel?.data?.addresses?[index].addressID ?? "0");
                                      });
                                    },
                                    child: Text(
                                      MyStrings.delete,
                                      style: regularSmall.copyWith(color: MyColor.colorRed),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(child: MyUtils.noRecordsFoundWidget()),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: RoundedButton(
          cornerRadius: 10,
          color: MyColor.primaryColor,
          text: MyStrings.addNewAddress.tr,
          press: () {
            MyConstants.isMapinEditMode = false;
            Get.off(AddNewAddressScreen());
          },
        ),
      ),
    );
  }

  void showDeleteAddressDialog({
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      AlertDialog(
        title: const Text(MyStrings.deleteAddress),
        content: const Text(MyStrings.deleteAddress2),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Dismiss dialog
            child: const Text(
              MyStrings.cancel,
              style: TextStyle(
                color: MyColor.primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss dialog
              onConfirm(); // Perform delete action
            },
            child: const Text(
              MyStrings.delete,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_pin, color: Colors.red, size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Handle edit
                      },
                      child: Text(""),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle delete
                      },
                      child: Text(
                        "",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
