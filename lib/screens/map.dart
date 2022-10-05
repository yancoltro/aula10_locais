import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aula10_locais/components/place_actions.dart';
import 'package:aula10_locais/components/place_dialog.dart';
import 'package:aula10_locais/helpers/db.dart';
import 'package:aula10_locais/helpers/location.dart';
import 'package:aula10_locais/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> markers = [];
  DB db = new DB();

  @override
  void initState() {
    _getSavedPlaces();
    getCurrentPosition().then((Position pos) {
      addMarker(
          pos.latitude, pos.longitude, "currentPosition", "Eu estou aqui!");
    }).catchError((error) => print(error.toString()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // -24.7212103,-53.761694 Fag Toledo
    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            actions: placeActions(context),
            title: Text('The Treasure Mapp'),
          ),
          body: Container(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(-24.7212103, -53.761694), zoom: 18),
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(markers),
              onLongPress: (LatLng position) {
                Place place =
                    new Place(0, "", position.latitude, position.longitude, "");
                PlaceDialog dialog = PlaceDialog(place, true);
                showDialog(
                        context: context,
                        builder: (context) => dialog.buildAlert(context))
                    .then((_) => _getSavedPlaces());
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              int here = markers.indexWhere((position) =>
                  position.markerId == MarkerId('currentPosition'));
              Place place;
              if (here == -1) {
                place = new Place(0, "", 0, 0, "");
              } else {
                LatLng position = markers[here].position;
                place =
                    new Place(0, "", position.latitude, position.longitude, "");
              }
              PlaceDialog dialog = PlaceDialog(place, true);
              showDialog(
                      context: context,
                      builder: (context) => dialog.buildAlert(context))
                  .then((_) => _getSavedPlaces());
            },
            child: Icon(
              Icons.add_location,
            ),
          ),
        );
      },
    );
  }

  void addMarker(
      double latitude, double longitude, String markerId, String markerTitle) {
    print('adicionou ${markerId}');
    final marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: markerTitle),
        icon: (markerId == 'currentPosition')
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange));
    markers.add(marker);
    setState(() {
      markers = markers;
    });
  }

  void _getSavedPlaces() async {
    db.openDb().then(
          (dbInstance) => dbInstance!.getPlaces().then(
                (List<Place> savePlaces) => savePlaces.forEach(
                  (Place place) {
                    addMarker(
                        place.lat, place.lon, place.id.toString(), place.name);
                    setState(() {
                      markers = markers;
                    });
                  },
                ),
              ),
        );
  }

  // void _getSavedPlaces() async {
  //   await db.openDb();
  //   await db.insertMockData();

  //   /// verificar como fazer essa inserção na criacao do banco direto
  //   List<Place> savePlaces = await db.getPlaces();

  //   savePlaces.forEach((place) =>
  //       addMarker(place.lat, place.lon, place.id.toString(), place.name));
  //   setState(() {
  //     markers = markers;
  //   });
  // }
}
