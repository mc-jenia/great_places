import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlacesProvider with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      location: null,
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
            location: null,
          ),
        )
        .toList();
    notifyListeners();
  }
}
