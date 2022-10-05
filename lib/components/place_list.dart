import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:aula10_locais/components/place_dialog.dart';
import 'package:aula10_locais/helpers/db.dart';

import '../models/place.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({Key? key}) : super(key: key);

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  DB db = DB();
  List<Place> places = [];

  @override
  void initState() {
    _getSavedPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: places.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(places[index].id.toString()),
            child: ListTile(
              title: Text(places[index].name),
              subtitle: Text(
                  'Lat: ${places[index].lat.toString()} - Lon: ${places[index].lon.toString()}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  PlaceDialog dialog = PlaceDialog(places[index], false);
                  showDialog(
                      context: context,
                      builder: (context) => dialog.buildAlert(context)).then((_) => _getSavedPlaces());
                },
              ),
            ),
            onDismissed: (direction) {
              String strName = places[index].name;
              db.deletePlace(places[index]);
              setState(() {
                places.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$strName removido com sucesso")));
            },
          );
        });
  }

  void _getSavedPlaces() async {
    db.openDb().then(
          (dbInstance) => dbInstance!.getPlaces().then(
                (List<Place> savePlaces) => setState(
                  () {
                    places = savePlaces;
                  },
                ),
              ),
        );
  }
}
