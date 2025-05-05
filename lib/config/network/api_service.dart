import 'dart:convert';
import 'dart:io';
import 'package:ShapeCom/config/utils/my_strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../utils/my_color.dart';
import '../utils/my_images.dart';
import '../utils/my_constants.dart';

class ApiService {
  final BuildContext context;

  ApiService({required this.context});

  Future<dynamic> makeRequest({required String endPoint, required String method, Map<String, dynamic>? body, showProgress = true}) async {
    //ProgressDialog progressDialog = ProgressDialog(context);
    try {
      if (showProgress) {
        /*progressDialog.style(
          backgroundColor: Colors.transparent,
          message: '',
          progressWidget: Center(
            key: UniqueKey(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 2, // Thicker progress indicator
                      color: MyColor.primaryColor, // Change color as needed
                    ),
                  ),
                ), // Show loader while image loads
                SvgPicture.asset(MyImages.loadingLogo, width: 50, height: 50),
              ],
            ),
          ),
          elevation: 10.0,
        );*/
      }

      // Wait for internet check before proceeding
      bool isConnected = await _isInternetAvailable();
      if (!isConnected) {
        CustomSnackBar.error(errorList: [MyStrings.noInternet]);
        throw Exception(MyStrings.noInternet);
      } else {
        if (showProgress) {
          // Show progress dialog
          //await progressDialog.show();
          showLoadingDialog();
        }

        // Disable back press

        String finalUrl = "${MyConstants.baseURL}$endPoint";
        print("finalUrl=$finalUrl");
        print("requestBody ${body.toString()}");
        final uri = Uri.parse(finalUrl);
        http.Response response;

        if (method == 'GET') {
          response = await http.get(uri);
        } else if (method == 'POST') {
          response = await http.post(uri, body: jsonEncode(body), headers: {
            'Content-Type': 'application/json',
          });
        } else {
          throw Exception('Unsupported HTTP method');
        }
        // Hide the progress dialog after request is completed
        //print("Response body is ${response.body}");
        try {
          if (showProgress) {
            // Dismiss loading dialog
            if (Get.isDialogOpen ?? false) Get.back();
            //Get.back();
          }
        } catch (e) {}
        print("response.statusCode is ${response.statusCode}");
        if (response.statusCode == 200 || response.statusCode == 201) {
          final dynamic jsonData = jsonDecode(response.body);
          // Return JSON data as either List or Map
          return jsonData;
        } else {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      }
    } catch (e) {
      try {
        if (showProgress) {
          // Dismiss loading dialog
          if (Get.isDialogOpen ?? false) Get.back();
          //Get.back();
        }
      } catch (e) {}
      // Hide the progress dialog in case of an error
      throw Exception('Error: $e');
    } finally {
      //print("hide now");
      /*try {
        if (showProgress) {
          await progressDialog.hide();
        }
      } catch (e) {}*/
    }
  }

  // Reusable loading dialog
  static void showLoadingDialog() {
    Get.dialog(
      barrierDismissible: false, // Prevent tap outside to dismiss
      useSafeArea: true,
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, // Thicker progress indicator
                    color: MyColor.primaryColor, // Change color as needed
                  ),
                ),
              ), // Show loader while image loads
              SvgPicture.asset(MyImages.loadingLogo, width: 60, height: 60),
            ],
          ),
        ),
      ),
    );
  }

  /// **Check Internet Availability**
  Future<bool> _isInternetAvailable() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // Check if there is a network connection
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    // Try connecting to Google to confirm actual internet access
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false; // No internet access
    }
  }
}
