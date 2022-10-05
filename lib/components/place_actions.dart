import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:aula10_locais/screens/manage.dart';

List<Widget> placeActions(BuildContext context) {
  return [
    IconButton(
      onPressed: () {
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => ManageScreen());
        Navigator.of(context).push(route);
      },
      icon: Icon(Icons.list),
    )
  ];
}
