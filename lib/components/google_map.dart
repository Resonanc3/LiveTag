import 'dart:async';
import 'dart:io';

import 'package:capstone/components/tag_marker.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGoogleMap extends StatefulWidget {
  final CameraPosition initialPosition;
  final Set<Marker> markers;
  final Completer<GoogleMapController> controller;
  const MyGoogleMap(
      {Key? key,
      required this.initialPosition,
      required this.markers,
      required this.controller})
      : super(key: key);

  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.satellite,
        zoomControlsEnabled: false,
        initialCameraPosition: widget.initialPosition,
        onMapCreated: (GoogleMapController controller) {
          widget.controller.complete(controller);
        },
        markers: widget.markers);
  }
}
