import 'dart:io';

import 'package:favorite_places/data/riverpod/places_provider.dart';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/image_input.dart';

class AddPlacePage extends ConsumerStatefulWidget {
  const AddPlacePage({super.key});

  @override
  ConsumerState<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends ConsumerState<AddPlacePage> {
  late TextEditingController _titleController;
  File? _imageFile;
  PlaceLocation? _location;

  @override
  void initState() {
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void setImage(File image) {
    _imageFile = image;
  }

  void setLocation(PlaceLocation location) {
    _location = location;
  }

  void _savePlace() {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              'Error',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            content: Text(
              'Please enter some text.',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_imageFile == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: Text(
              'Error',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            content: Text(
              'Please take a picture.',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    ref.read(placesProvider.notifier).addPlace(
          title: enteredText,
          imageFile: _imageFile!,
          location: _location!,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place'),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                  autofocus: true,
                  controller: _titleController,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ImageInput(
                  onImageSelect: setImage,
                ),
                const SizedBox(
                  height: 15,
                ),
                LocationInput(
                  onSelectLocation: setLocation,
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton.icon(
                  onPressed: _savePlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
