import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_yt/consts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  TextEditingController controller = TextEditingController();
  final Completer<GoogleMapController> _mapCompleter =
      Completer<GoogleMapController>();
  LatLng _pGooglePlex = LatLng(15.5367, 121.0021);
  LatLng? destination = null;
  LatLng? origin = null;
  bool isMapShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Get Location Using Search'),
        ),
        body:
        isMapShown ? showDestinationMap():
        Container(
          height: 1000,
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Search Location and map will show'),
              placesAutoCompleteTextField(),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ));
  }


  showDestinationMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _pGooglePlex,
        zoom: 13,
      ),
      onMapCreated: ((GoogleMapController controller) =>
          _mapCompleter.complete(controller)),
      markers: {
        Marker(
            markerId: MarkerId("_destinatioin"),
            icon: BitmapDescriptor.defaultMarker,
            position: destination!),
      },
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: GOOGLE_MAPS_API_KEY,
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["ph"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          setState(() {
            destination = LatLng(double.parse(prediction.lat.toString()),
                double.parse(prediction.lng.toString()));
            _pGooglePlex = LatLng(double.parse(prediction.lat.toString()),
                double.parse(prediction.lng.toString()));
            isMapShown = true;
          });
          // print("placeDetails" +
          //     prediction.lat.toString() +
          //     ' lang ' +
          //     prediction.lng.toString());
        },

        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,

        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }
}
