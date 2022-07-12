import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation? initialLocation;
  final bool isSelected;

  const MapScreen({
    Key? key,
    this.initialLocation = const PlaceLocation(
      latitude: 33.312805,
      longitude: 44.361488,
    ),
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  void _selectPlace(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: [
          if (widget.isSelected)
            IconButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
              icon: const Icon(Icons.check),
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation!.latitude!,
            widget.initialLocation!.longitude!,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelected ? _selectPlace : null,
        markers: (_pickedLocation == null && widget.isSelected)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('A1'),
                  position: _pickedLocation ??
                      LatLng(widget.initialLocation!.latitude!,
                          widget.initialLocation!.longitude!),
                )
              },
      ),
    );
  }
}
