import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places_provider.dart';
import 'package:provider/provider.dart';

import 'add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Places'),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Consumer<GreatPlacesProvider>(
          builder: (context, value, child) => value.items.isEmpty
              ? child!
              : ListView.builder(
                  itemCount: value.items.length,
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    leading: CircleAvatar(
                        backgroundImage: FileImage(value.items[index].image)),
                    title: Text(
                      value.items[index].title,
                    ),
                    onTap: () {},
                  ),
                ),
          child: const Center(
              child: Text('Got no Places yet, start adding some!')),
        ));
  }
}
