import 'package:favorite_places/data/riverpod/places_provider.dart';
import 'package:favorite_places/pages/place_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);

    if (places.isNotEmpty) {
      return ListView.builder(
          itemCount: places.length,
          itemBuilder: (ctx, index) {
            final place = places[index];

            return ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundImage: FileImage(place.image),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return PlaceDetailsPage(place: place);
                    },
                  ),
                );
              },
              title: Text(
                place.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text(
                place.location.formattedAddress,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            );
          });
    }
    return Center(
      child: Text(
        'No places here',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    );
  }
}
