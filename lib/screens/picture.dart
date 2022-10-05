import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aula10_locais/helpers/db.dart';
import 'package:aula10_locais/main.dart';
import 'package:aula10_locais/models/place.dart';

class PictureScreen extends StatelessWidget {
  final String imagePath;
  final Place place;
  PictureScreen(this.imagePath, this.place);

  final DB db = DB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salvar imagem'),
        
      ),
      body: Container(
        child: Image.file(File(imagePath)),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: FloatingActionButton(
          onPressed: () async {
            place.image = imagePath;
              db.insertPlace(place);
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (context) => MapApp());
              Navigator.push(context, route);
          },
          child: Icon(Icons.save),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
