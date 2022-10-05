import 'package:flutter/material.dart';
import 'package:aula10_locais/components/place_list.dart';

class ManageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Places'),
      ),
      body: PlaceList(),
    );
  }
}
