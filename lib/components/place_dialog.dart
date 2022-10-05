import 'dart:io';

import 'package:flutter/material.dart';
import 'package:aula10_locais/helpers/db.dart';
import 'package:aula10_locais/screens/camera.dart';
import '../models/place.dart';

class PlaceDialog {
  PlaceDialog(this.place, this.isNew);
  final bool isNew;
  final Place place;

  DB db = DB();

  final txtName = TextEditingController();
  final txtLat = TextEditingController();
  final txtLon = TextEditingController();

  Widget buildAlert(BuildContext context) {
    txtName.text = place.name;
    txtLat.text = place.lat.toString();
    txtLon.text = place.lon.toString();

    return AlertDialog(
      title: Text("Lugar"),
      content: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            controller: txtName,
            decoration: InputDecoration(
              hintText: 'Nome',
            ),
          ),
          TextField(
            controller: txtLat,
            decoration: InputDecoration(
              hintText: 'Latitude',
            ),
          ),
          TextField(
            controller: txtLon,
            decoration: InputDecoration(
              hintText: 'Longitude',
            ),
          ),
          (place.image!= '')?Container(child:
          Image.file(File(place.image))):Container(),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (isNew) {
                          place.name = txtName.text;
                          place.lon = double.tryParse(txtLon.text)!;
                          place.lat = double.tryParse(txtLat.text)!;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Local adicionado com sucesso"),
                            ),
                          );
                          db.insertPlace(place).then((newPlace) {
                            place.id = newPlace;
                            MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => CameraScreen(place));
                            Navigator.of(context).push(route);
                          });
                        } else {
                          MaterialPageRoute route = MaterialPageRoute(
                              builder: (context) => CameraScreen(place));
                          Navigator.of(context).push(route);
                        }
                      },
                      child: Icon(Icons.camera_front)),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        place.name = txtName.text;
                        place.lon = double.tryParse(txtLon.text)!;
                        place.lat = double.tryParse(txtLat.text)!;
                        db.insertPlace(place);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: isNew
                                ? Text("Adicionado com sucesso")
                                : Text("Editado com sucesso")));
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.save)),
                ),
              )
            ],
          )
        ],
      )),
    );
  }
}
