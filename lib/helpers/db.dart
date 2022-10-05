// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment

import 'package:path/path.dart';
import 'package:aula10_locais/models/place.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  final int version = 1;
  Database? db;
  List<Place> places = [];
  static final DB _db = DB._internal();
  DB._internal();

  factory DB() {
    return _db;
  }

  Future<DB?> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'mapp.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, lat DOUBLE, lon DOUBLE, image TEXT)');
      }, version: version);
    }
    return _db;
  }

  // Future insertMockData() async {
  //   db = await openDb();
  //   db!.insert(
  //       'places',
  //       {
  //         "id": 1,
  //         "name": "Tem cerveja!",
  //         "lat": -24.7174,
  //         "lon": -53.7357,
  //         "image": ""
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   db!.insert(
  //       'places',
  //       {
  //         "id": 2,
  //         "name": "Aqui também tem cerveja!",
  //         "lat": -24.7156,
  //         "lon": -53.7508,
  //         "image": ""
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   db!.insert(
  //       'places',
  //       {
  //         "id": 3,
  //         "name": "Aqui tem cerveja para um #%!@**",
  //         "lat": -24.7057,
  //         "lon": -53.7376,
  //         "image": ""
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  //   List places = await db!.rawQuery('select * from places');
  //   print(places[0].toString());
  // }

  Future<List<Place>> getPlaces() async {
    final List<Map<String, dynamic>> maps = await db!.query('places');
    this.places = List.generate(maps.length, (i) {
      return Place(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['lat'],
        maps[i]['lon'],
        maps[i]['image'],
      );
    });
    return places;
  }

  Future<int> insertPlace(Place place) async {
    int id = await this.db!.insert(
          'places',
          place.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<int> updatePlace(Place place) async {
    int id = await this.db!.update(
          'places',
          place.toMap(),
        );
    return id;
  }

  Future<int> deletePlace(Place place) async {
    int result =
        await db!.delete("places", where: "id = ?", whereArgs: [place.id]);
    return result;
  }
}
