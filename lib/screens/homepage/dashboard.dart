import 'dart:async';

import 'package:capstone/api/services.dart';
import 'package:capstone/components/constants.dart';
import 'package:capstone/components/google_map.dart';
import 'package:capstone/components/show_info.dart';
import 'package:capstone/models/user_data.dart';
import 'package:capstone/provider/email_password.dart';
import 'package:capstone/screens/homepage/user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../components/tag_marker.dart';
import '../../models/tags.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final searchInput = TextEditingController();
  late StreamSubscription<Position> positionStream;
  late StreamSubscription tagListener;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  UserData? user;

  int fetchState = 0;

  LatLng? myLoc = const LatLng(8.535899, 124.801738);
  Set<Marker> markers = Set();
  List<Tags> tags = [];

  CameraPosition initialLoc = const CameraPosition(
    target: LatLng(8.535899, 124.801738),
    zoom: 18,
  );

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  @override
  void initState() {
    super.initState();

    getUserData();
    getTags();
    getYourLocation();
  }

  @override
  void dispose() {
    super.dispose();
    tagListener.cancel();
  }

  void getYourLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      myLoc = LatLng(position!.latitude, position.longitude);
      await TagMarker.getMarkerIcon(
              "assets/icons/farmer.png", const Size(100, 100), Colors.blue)
          .then((value) {
        if (mounted) {
          setState(() {
            markers.add(Marker(
                markerId: MarkerId(user!.id!),
                position: myLoc!, //position of marker
                infoWindow: InfoWindow(
                  title: 'My Location',
                  snippet: user!.name,
                ),
                icon: value));
          });
        }
      });
    });

    final newPos = CameraPosition(
        bearing: 192.8334901395799,
        target: myLoc!,
        tilt: 0,
        zoom: 19.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPos));

    await TagMarker.getMarkerIcon(
            "assets/icons/farmer.png", const Size(100, 100), Colors.blue)
        .then((value) {
      if (mounted) {
        setState(() {
          markers.add(Marker(
              markerId: MarkerId(user!.id!),
              position: myLoc!, //position of marker
              infoWindow: InfoWindow(
                title: 'My Location',
                snippet: user!.name,
              ),
              icon: value));
        });
      }
    });
  }

  void goToMe() async {}

  void getTags() {
    tagListener = Services.getTags().onValue.listen((DatabaseEvent event) {
      tags.clear();

      for (var element in event.snapshot.children) {
        Map<dynamic, dynamic> data = element.value as Map<dynamic, dynamic>;

        setState(() {
          tags.add(Tags.fromJson(data['data'], element.key!));
        });
      }
    });
  }

  void getUserData() {
    final id = FirebaseAuth.instance.currentUser!.uid;

    Services.getUser(id: id).then((value) {
      user = value;

      if (mounted) {
        setState(() {
          fetchState = 1;
        });
      }
    }).onError((error, stackTrace) {
      fetchState = -1;
    });
  }

  Future onTagClick(Tags tag) async {
    await TagMarker.getMarkerIcon(
            "assets/icons/cow.png", const Size(100, 100), Colors.orange)
        .then((value) {
      setState(() {
        markers.add(Marker(
            markerId: MarkerId(tag.tagId),
            position: LatLng(tag.lat, tag.long), //position of marker
            infoWindow: InfoWindow(
              title: 'Tag Point',
              snippet: tag.tagName,
            ),
            icon: value));
      });
    });

    final newPos = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(tag.lat, tag.long),
        tilt: 0,
        zoom: 19.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      body: fetchState != 1
          ? buildStatus()
          : SafeArea(
              child: Stack(
              children: [
                MyGoogleMap(
                  initialPosition: initialLoc,
                  markers: markers,
                  controller: _controller,
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: backgroundColor),
                                  child: TextField(
                                    controller: searchInput,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon:
                                          const Icon(Icons.radar_rounded),
                                      hintText: 'Search livestocks',
                                      hintStyle: TextStyle(
                                          color: textColor.withOpacity(0.8)),
                                      isCollapsed: true,
                                      contentPadding: const EdgeInsets.fromLTRB(
                                          15, 10, 10, 10),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    ShowInfo.showUpDialog(context,
                                        title: 'Logout Account',
                                        message:
                                            'Are you sure you want to logout?',
                                        action1: 'Yes',
                                        btn1: () {
                                          EmailPassword.logoutAccount(context);
                                        },
                                        action2: 'Cancel',
                                        btn2: () {
                                          Navigator.of(context).pop();
                                        });
                                  },
                                  child: const Icon(
                                    Icons.logout_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      child: UserCard(
                        user: user!,
                        tags: tags,
                        onTagClick: (tag) {
                          onTagClick(tag);
                        },
                        togleUser: () {
                          getYourLocation();
                        },
                      )),
                ),
              ],
            )),
    );
  }

  Widget buildStatus() {
    if (fetchState == -1) {
      return const Center(
        child: Text('An error occurred.'),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
