import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_places_flutter/model/prediction.dart';

class MapController extends GetxController {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  //final googlePlace = GooglePlace("AIzaSyCX0ykiIdK66MbLdqkRPeZhGGB2m2r8bPQ");

  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  CameraPosition kLake = const CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  final polygons = HashSet<Polygon>().obs;
  final markers = <Marker>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMapRenderer();
  }

  /// Google framework settings for android
  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  /// drop marker on map click
  var id = 0;
  void drawMarkers(LatLng location) {
    id += 1;
    markers.value.add(
      Marker(
        markerId: MarkerId("$id"),
        position: location,
      ),
    );
    markers.refresh();
  }

  /// click handler for draw a polygon
  void drawPoligon() {
    var list = <LatLng>[];
    for (var marker in markers.value) {
      print(
          "Loc pol: ${marker.position.latitude}, ${marker.position.longitude}");
      list.add(marker.position);
    }

    var polygon = Polygon(
      polygonId: const PolygonId('user_polygon'),
      points: list,
      strokeWidth: 2,
      strokeColor: Colors.red,
      fillColor: Colors.red.withOpacity(0.4),
    );

    polygons.value.add(polygon);
    polygons.refresh();
    markers.value.clear();
    markers.refresh();
  }

  // reset mapview by erasing the polygons
  void resetMap() {
    polygons.value.clear();
    polygons.refresh();
  }

  /// Update the location and
  /// relocate map to new location
  void updateLocation(Prediction prediction) {
    mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              double.parse(prediction.lat!),
              double.parse(prediction.lng!),
            ),
            zoom: 14,
          ),
        ),
      );
    });
  }
}
