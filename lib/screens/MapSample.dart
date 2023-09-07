import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  bool isOpen = false;
  double height = 0;
  bool _showContainer = false;

  void _toggle() {
    setState(() {
      height = isOpen ? 0 : 200;
      isOpen = !isOpen;
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(8.745505, 124.779049),
      tilt: 0,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    //Prevents the user from going back to previous screen
    return WillPopScope(
      onWillPop: () {
        //SystemChannels.platform.invokeMethod('SystemNavigator.pop');

        showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return MyAlertDialog(
                title: 'Exit App',
                content: 'Are you sure you want to exit?',
                actions: [
                  TextButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                    },
                    child: Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('No'),
                  )
                ],
              );
            });
        return Future.value(false);
      },
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        floatingActionButton: Column(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                onPressed: _goToTheLake,
                label: Text('Re-center'),
                icon: Icon(Icons.directions_boat),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showContainer = !_showContainer;
                  });
                },
                child: Text('Toggle Container'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class MyAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget> actions;

  MyAlertDialog(
      {required this.title, required this.content, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      actions: actions,
      content: Text(
        content,
      ),
    );
  }
}
