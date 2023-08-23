import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDB() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT, image TEXT, lat REAL, lng REAL, formattedAddress TEXT)');
    },
    version: 1,
  );
  return db;
}

final placesProvider = StateNotifierProvider<PlacesState, List<Place>>((ref) {
  return PlacesState();
});

class PlacesState extends StateNotifier<List<Place>> {
  PlacesState() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDB();
    final data = await db.query('user_places');
    List<Place> fetchedPlaces = data.map((row){
      return Place.fromMap(row);
    }).toList().reversed.toList();

    state = fetchedPlaces;
  }

  void addPlace({
    required String title,
    required File imageFile,
    required PlaceLocation location,
  }) async {
    final appDirectory = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final copiedImage = await imageFile.copy('${appDirectory.path}/$fileName');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await _getDB();
    db.insert('user_places', newPlace.asMap);

    state = [newPlace, ...state];
  }
}
