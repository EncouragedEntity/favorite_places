import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/pages/map_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  String get mapUrlImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final long = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=16&size=600x300&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyBK2hl09bIhVHdqbKd_iTcLRcajKEfEXAw';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final long = locationData.longitude;
    final lat = locationData.latitude;

    if (lat == null || long == null) {
      return;
    }
    _savePlace(lat, long);

    //* map api key  AIzaSyBK2hl09bIhVHdqbKd_iTcLRcajKEfEXAw
  }

  Future<void> _savePlace(double lat, double long) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyBK2hl09bIhVHdqbKd_iTcLRcajKEfEXAw');
    final response = await http.get(url);
    try {
      final responseData = jsonDecode(response.body);
      final address = responseData['results'][0]['formatted_address'];
      setState(() {
        _pickedLocation = PlaceLocation(
          longitude: long,
          latitude: lat,
          formattedAddress: address,
        );
        _isGettingLocation = false;
      });
      widget.onSelectLocation(_pickedLocation!);
    } catch (e) {
      _isGettingLocation = false;
      return;
    }
  }

  void _selectLocationOnMap() async {
    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) {
          if (_pickedLocation != null) {
            return MapPage(
              location: _pickedLocation!,
            );
          }
          return const MapPage();
        },
      ),
    );

    if (result == null) {
      return;
    }

    _savePlace(
      result.latitude,
      result.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      'No location selected',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_isGettingLocation) {
      content = const CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      content = Image.network(
        mapUrlImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          height: 170,
          width: double.infinity,
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
              onPressed: _selectLocationOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
            ),
          ],
        ),
      ],
    );
  }
}
