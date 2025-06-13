import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../config/utils/my_constants.dart';
import '../../../../presentation/screens/auth/registration/model/country_code_model.dart';

class ControllerMap extends GetxController {
  late GoogleMapController mapController;
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;
  var isLoading = false.obs;
  var currentPosition = Rxn<LatLng>(); // Reactive current position

  // Configurable properties
  late CameraPosition initialPosition;
  final bool showMyLocation;
  final MapType mapType;
  final Set<Marker>? initialMarkers;

  ControllerMap({
    LatLng? initialLatLng, // Optional static initial position
    double initialZoom = 15, // Higher zoom for live location
    this.showMyLocation = true,
    this.mapType = MapType.normal,
    this.initialMarkers,
  }) {
    // Set a temporary initial position; will be updated with live location
    initialPosition = CameraPosition(
      target: initialLatLng ?? LatLng(0, 0), // Fallback
      zoom: initialZoom,
    );
  }

  @override
  void onInit() async {
    super.onInit();
    /*if (initialMarkers != null) {
      markers.addAll(initialMarkers!);
    }*/
    if (!MyConstants.isMapinEditMode) {
      await getCurrentLocation(); // Fetch live location on init
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition.value != null) {
      moveCamera(currentPosition.value!); // Move to live location when map is ready
    }
    update();
  }

  // Fetch current location
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = LatLng(position.latitude, position.longitude);
      //MyConstants.mapLat=position.latitude;
      //MyConstants.mapLong=position.longitude;
      // Add a marker for current location
     /* addMarker(
        position: currentPosition.value!,
        id: 'current_location',
        title: 'My Location',
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );*/

      // Move camera to current location if map is already created
      if (mapController != null) {
        await moveCamera(currentPosition.value!);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void addMarker({
    required LatLng position,
    required String id,
    String? title,
    String? snippet,
    BitmapDescriptor? icon,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(
          title: title,
          snippet: snippet,
        ),
        icon: icon ?? BitmapDescriptor.defaultMarker,
      ),
    );
  }

  /*void addMarkers(Set<Marker> newMarkers) {
    markers.addAll(newMarkers);
  }*/

  void addPolyline({
    required String id,
    required List<LatLng> points,
    int width = 5,
  }) {
    polylines.add(
      Polyline(
        polylineId: PolylineId(id),
        points: points,
        width: width,
      ),
    );
  }

  Future<void> moveCamera(LatLng target, {double zoom = 15}) async {
    try {
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: zoom),
        ),
      );
    } catch (e) {}
  }

  Future<void> updateZoom(double zoom) async {
    try {
      await mapController.animateCamera(CameraUpdate.zoomTo(zoom));
    } catch (e) {}
  }

  @override
  void onClose() {
    try {
      mapController.dispose();
    } catch (e) {}
    super.onClose();
  }
}
