import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    final locationData = await Location().getLocation();

    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: locationData.latitude, longitude: locationData.longitude);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final LatLng isSelectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const MapScreen(
          isSelected: true,
        ),
      ),
    );
    if (isSelectedLocation == null) {
      return;
    }
    print(isSelectedLocation.latitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 170,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? const Text(
                  'No location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('current location'),
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
