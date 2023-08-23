import 'dart:io';

import 'package:uuid/uuid.dart';

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLocation location;

  Place({
    required this.image,
    required this.title,
    required this.location,
    String? id
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> get asMap {
    return {
      'id': id,
      'title': title,
      'image': image.path,
      'lat': location.latitude,
      'lng': location.longitude,
      'formattedAddress': location.formattedAddress,
    };
  }

  Place.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String,
        title = map['title'] as String,
        image = File(
            map['image'] as String),
        location = PlaceLocation(
          longitude: map['lng'] as double,
          latitude: map['lat'] as double,
          formattedAddress: map['formattedAddress'] as String,
        );
}

class PlaceLocation {
  final double longitude;
  final double latitude;
  final String formattedAddress;

  const PlaceLocation({
    required this.longitude,
    required this.latitude,
    required this.formattedAddress,
  });
}
