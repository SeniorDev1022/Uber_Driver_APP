import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:kenorider_driver/common/colormanager.dart';
import 'dart:ui';

import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/views/auth/loginpage.dart';
import 'package:kenorider_driver/views/auth/registerpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController? mapController;
  late LatLng _currentPosition;
  late Marker _currentLocationMarker;
  bool _locationInitialized = false;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _currentLocationMarker = Marker(
          markerId: MarkerId("current_location"),
          position: _currentPosition,
          icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(google_maps.BitmapDescriptor.hueBlue),
        );
        _locationInitialized = true;// Set _isLoading to false when the position is determined
      });
    }).catchError((e) {
      print("Error getting location: $e");
    });
  }

  Future<Position> _determinePosition() async {
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

    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController!.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14.0));
  }

  void _onPressedCreateAccountButton () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
  void _onPressedLoginButton () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Loginpage()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if(_locationInitialized)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition, // Sample coordinates
                zoom: 14,
              ),
              markers: {_currentLocationMarker},
            ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.transparent,
                    Colors.white.withOpacity(0.8),
                    Colors.white,
                  ],
                  stops: [0.0, 0.4, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    Apptext.logoImage,
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    "Drive smart,",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      height: 0.9,
                    ),
                  ),
                  Text(
                    "earn more",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45,
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "with",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                          height: 1,
                        ),
                      ),
                      Text(
                        " KenoRide",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                          color: ColorManager.primary_color,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, // Make the button fill the width of the screen
                    height: 50, // Set the fixed height of the button
                    child: ElevatedButton(
                      onPressed: _onPressedCreateAccountButton,
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              ColorManager.dark_primary_color,
                              ColorManager.primary_color
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(maxWidth: double.infinity, minHeight: 50),
                          child: Text(
                            Apptext.signUpButtonText,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _onPressedLoginButton,
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: ColorManager.primary_50_color,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(maxWidth: double.infinity, minHeight: 50),
                          child: Text(
                            Apptext.loginButtonText,
                            style: TextStyle(
                              color: ColorManager.primary_color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
          if (!_locationInitialized)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Fetching current location...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
