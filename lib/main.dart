// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:aula10_locais/screens/map.dart';

void main() {
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(      
      home: MapScreen(),
    );
  }
}
