import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:teq_mavens/mapHome/controller/mapController.dart';
import 'package:teq_mavens/utils/uiUtils.dart';

// ignore: must_be_immutable
class MapHome extends StatelessWidget {
  final _ctrl = Get.put(MapController());
  MapHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _ctrl.kGooglePlex,
                polygons: _ctrl.polygons.value,
                markers: _ctrl.markers.value.toSet(),
                onTap: (location) {
                  print("Loc: ${location.latitude}, ${location.longitude}");
                  _ctrl.drawMarkers(location);
                },
                onMapCreated: (GoogleMapController controller) {
                  _ctrl.mapController.complete(controller);
                },
              ),
            ),
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: darwAndReset(),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: searchWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Row darwAndReset() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _ctrl.drawPoligon();
            },
            child: const Text("Draw Polygon"),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _ctrl.resetMap();
            },
            child: const Text("Reset Map"),
          ),
        )
      ],
    );
  }

  /// UI for search widget
  var searchController = TextEditingController();
  Widget searchWidget() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: searchController,

      googleAPIKey: "AIzaSyCX0ykiIdK66MbLdqkRPeZhGGB2m2r8bPQ",
      boxDecoration: Uiutils.searchDecoration,
      inputDecoration: Uiutils.searchInputDecoration,
      debounceTime: 800, // default 600 ms,
      countries: const ["in", "fr"], // optional by default null is set
      isLatLngRequired: true, // if you required coordinates from place detail
      getPlaceDetailWithLatLng: (Prediction prediction) {
        // this method will return latlng with place detail
        //print("placeDetails" + prediction.lng.toString());
        _ctrl.updateLocation(prediction);
      }, // this callback is called when isLatLngRequired is true
      itemClick: (Prediction prediction) {
        searchController.text = prediction.description!;
        searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: prediction.description!.length),
        );
      },
      // if we want to make custom list item builder
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(
                width: 7,
              ),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },
      // if you want to add seperator between list items
      seperatedBuilder: const Divider(),
      // want to show close icon
      isCrossBtnShown: true,
      // optional container padding
      containerHorizontalPadding: 8,
      // place type
      placeType: PlaceType.geocode,
    );
  }
}
