import 'package:favorite_places/data/riverpod/places_provider.dart';
import 'package:favorite_places/pages/add_place_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/places_list.dart';

class PlacesListPage extends ConsumerStatefulWidget {
  const PlacesListPage({super.key});

  @override
  ConsumerState<PlacesListPage> createState() => _PlacesListPageState();
}

class _PlacesListPageState extends ConsumerState<PlacesListPage> {

  late Future<void> _placesFuture;

  @override
  void initState() {
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const AddPlacePage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const PlacesList();
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
