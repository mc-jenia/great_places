import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places_provider.dart';
import 'package:great_places/screens/place_detail_screen.dart';
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
      body: FutureBuilder(
        future: Provider.of<GreatPlacesProvider>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Consumer<GreatPlacesProvider>(
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
                      subtitle: Text(value.items[index].location!.address!),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          PlaceDetailScreen.routeName,
                          arguments: value.items[index].id,
                        );
                      },
                    ),
                  ),
            child: const Center(
                child: Text('Got no Places yet, start adding some!')),
          );
        },
      ),
    );
  }
}
