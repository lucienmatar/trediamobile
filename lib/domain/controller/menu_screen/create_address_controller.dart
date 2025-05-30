import 'dart:convert';

import 'package:ShapeCom/presentation/screens/menu/my_addresses_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../config/network/api_service.dart';
import '../../../config/utils/my_constants.dart';
import '../../../config/utils/my_preferences.dart';
import '../../../config/utils/my_strings.dart';
import '../../../presentation/components/snack_bar/show_custom_snackbar.dart';
import '../../../presentation/screens/auth/registration/model/town_model.dart';
import '../../../presentation/screens/my_addresses/model/add_address_model.dart';

class CreateAddressController extends GetxController {
  TextEditingController searchLocationController = TextEditingController();
  bool isSubmitDisable = true;
  bool fromEdit = false;
  var addressController = TextEditingController();
  var TownID;
  var AddressID;
  var QazaTown;
  TownModel? townModel;
  var Longitude;
  var Latitude;
//List<Map<String, String>>? townList;
  List<String>? townList;
  String? selectedTownName = MyStrings.selectTown;
  String? selectedTown = MyStrings.selectTown;
  ApiService apiService = ApiService(context: Get.context!);

  addAddressApi() async {
    try {
      print("addAddressApi selectedTownName $selectedTownName");
      for (int i = 0; i < townModel!.data!.length; i++) {
        if (townModel!.data![i].display == selectedTownName) {
          TownID = townModel!.data![i].value!;
          break;
        }
      }
      print("addAddressApi townID $TownID");
      bool isGuestLogin = false;
      isGuestLogin = MyPrefrences.getBool(MyPrefrences.guestLogin) ?? false;
      String? token;
      if (isGuestLogin) {
        token = null;
      } else {
        token = MyPrefrences.getString(MyPrefrences.token) ?? "";
      }
      var requestBody;
      dynamic responseBody;
      if (fromEdit) {
        requestBody = {
          "token": token,
          "lang": MyConstants.currentLanguage,
          "AddressID": AddressID,
          "TownID": TownID,
          "AddressDetails": addressController.text.toString().trim(),
          "Longitude": MyConstants.mapLong,
          "Latitude": MyConstants.mapLat,
        };
        responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointEditAddress, method: MyConstants.POST, body: requestBody);
      } else {
        requestBody = {
          "token": token,
          "lang": MyConstants.currentLanguage,
          "TownID": TownID,
          "AddressDetails": addressController.text.toString().trim(),
          "Longitude": MyConstants.mapLong,
          "Latitude": MyConstants.mapLat,
        };
        responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointAddAddress, method: MyConstants.POST, body: requestBody);
      }
      AddAddressModel addAddressModel = AddAddressModel.fromJson(responseBody);
      if (addAddressModel!.status! == 1) {
        if (addAddressModel!.msg!.isNotEmpty) {
          CustomSnackBar.success(successList: [addAddressModel!.msg!]);
        }
        Get.off(MyAddressesScreen());
      } else {
        if (addAddressModel!.msg!.isNotEmpty) {
          CustomSnackBar.error(errorList: [addAddressModel!.msg!]);
        }
      }
    } catch (e) {
      print("addAddressApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  getAllTownApi({required Null Function() callback}) async {
    try {
      var requestBody = {"Id_College": MyConstants.Id_College, "lang": MyConstants.currentLanguage};
      dynamic responseBody = await apiService.makeRequest(endPoint: MyConstants.endpointGetTowns, method: MyConstants.POST, body: requestBody);
      townModel = TownModel.fromJson(responseBody);
      if (townModel!.status == 1) {
        if (townModel!.msg!.isNotEmpty) {
          print("town len ${townModel!.data!.length}");
          townList = townModel?.data?.map((data) => data.display ?? '').toList() ?? [];
          /*townList = townModel!.data?.map((data) {
              return {
                'display': data.display ?? '',
                'value': data.value ?? '',
              };
            }).toList() ??
            [];*/
          selectedTown = townModel!.data![0].display!;
          callback();
        }
      } else {
        CustomSnackBar.error(errorList: [townModel!.msg!]);
      }
    } catch (e) {
      print("getAllTownApi Error ${e.toString()}");
      CustomSnackBar.error(errorList: [MyStrings.networkError]);
    }
  }

  Future<List<dynamic>> fetchPlaceSuggestions(String query) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${MyConstants.GOOGLE_PLACE_API_KEY}';
    final response = await http.get(Uri.parse(url));
    print("fetchPlaceSuggestions statusCode ${response.statusCode}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print("fetchPlaceSuggestions statusCode ${jsonResponse.toString()}");
      return jsonResponse['predictions'];
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

// Fetch place details using Place Details API
  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${MyConstants.GOOGLE_PLACE_API_KEY}';
    final response = await http.get(Uri.parse(url));
    print("fetchPlaceDetails statusCode ${response.statusCode}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print("fetchPlaceDetails response ${jsonResponse.toString()}");
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
