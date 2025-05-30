import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../config/utils/my_constants.dart';

class AddNewAddressController extends GetxController {
  TextEditingController searchLocationController = TextEditingController();
  bool isFromEdit = false;
  CameraPosition? currentPosition;
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
