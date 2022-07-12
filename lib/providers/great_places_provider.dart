import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
      String title, File image, PlaceLocation placeLocation) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final address = await LocationHelper.getPlaceAddress(
        placeLocation.latitude!, placeLocation.longitude!);
    final updateLocation = PlaceLocation(
        latitude: placeLocation.latitude,
        longitude: placeLocation.longitude,
        address: address);
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: updateLocation,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(
      'great_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path
            .substring(appDir.path.length, newPlace.image.path.length),
        'loc_lat': newPlace.location!.latitude!,
        'loc_lng': newPlace.location!.longitude!,
        'address': newPlace.location!.address!,
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('great_places');
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    _items = dataList
        .map(
          (data) => Place(
            id: data['id'],
            title: data['title'],
            image: File('${appDir.path}/${data['image']}'),
            location: PlaceLocation(
              latitude: data['loc_lat'],
              longitude: data['loc_lng'],
              address: data['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
