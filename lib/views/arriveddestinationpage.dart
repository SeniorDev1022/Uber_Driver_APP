import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:kenorider_driver/common/Global_variable.dart';
import 'package:kenorider_driver/common/colormanager.dart';
import 'package:kenorider_driver/common/textcontent.dart';
import 'package:kenorider_driver/view_models/request_view_model.dart';
import 'package:kenorider_driver/views/ratepage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
class ArriveDestinationPage extends StatefulWidget {
  @override
  _ArriveDestinationPageState createState() => _ArriveDestinationPageState();
}

class _ArriveDestinationPageState extends State<ArriveDestinationPage> {
  late GoogleMapController mapController;
  LatLng _currentPosition = LatLng(0, 0);
  late Marker _currentLocationMarker;
  late Marker _destinationLocationMarker;
  LatLng _destinationPosition = const LatLng(0, 0);
  bool _locationInitialized = false;
  Timer? _timer;
  bool hasNavigated = false;
  google_maps.Polyline? _routePolyline;
  String driverDistance = "";
  String driverTime = "";
  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
    // _determinePosition().then((position) {
    //   setState(() {
    //     _currentPosition = LatLng(position.latitude, position.longitude);
    //     _currentLocationMarker = Marker(
    //       markerId: const MarkerId("current_location"),
    //       position: _currentPosition,
    //       icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(google_maps.BitmapDescriptor.hueBlue),
    //     );
    //     _locationInitialized = true;
    //   });
    // }).catchError((e) {
    //   print("Error getting location: $e");
    // });
  }
  @override
  void dispose() {
    _timer?.cancel();
    mapController.dispose();
    super.dispose();
  }
  void _startLocationUpdates() {
    _determinePosition().then((position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _currentLocationMarker = Marker(
          markerId: const MarkerId("current_location"),
          position: _currentPosition,
          icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
              google_maps.BitmapDescriptor.hueBlue),
        );
        _destinationLocationMarker = Marker(
          markerId: const MarkerId("destination_location"),
          position: LatLng(GlobalVariables.desLat, GlobalVariables.desLng),
          icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
              google_maps.BitmapDescriptor.hueRed),
        );
        _locationInitialized = true;
        _updateRoutePolyline();
      });
      _destinationPosition =
          LatLng(GlobalVariables.desLat, GlobalVariables.desLng);
      double distance =
          _calculateDistance(_currentPosition, _destinationPosition);
      driverTime = _calculateEstimatedTime(distance);
      driverDistance = distance.toStringAsFixed(2);
      print('Distance: $driverDistance km');
      print('Estimated Time: $driverTime');
    }).catchError((e) {
      // ignore: avoid_print
      print("Error getting location: $e");
    });
    _timer = Timer.periodic(
        const Duration(seconds: 15), (Timer t) => _updateLocation());
  }
  Future<void> _updateLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _currentLocationMarker = Marker(
          markerId: const MarkerId("current_location"),
          position: _currentPosition,
          icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
              google_maps.BitmapDescriptor.hueBlue),
        );
        if (_locationInitialized) {
          mapController.animateCamera(
              CameraUpdate.newLatLngZoom(_currentPosition, 18.0));
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error updating location: $e");
    }
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
    mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 18.0));
  }
  double _calculateDistance(google_maps.LatLng start, google_maps.LatLng end) {
    const earthRadiusKm = 6371;

    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLon = _degreesToRadians(end.longitude - start.longitude);

    double lat1 = _degreesToRadians(start.latitude);
    double lat2 = _degreesToRadians(end.latitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  String _calculateEstimatedTime(double distance) {
    const speedKmPerHour = 40;
    double timeInHours = distance / speedKmPerHour;
    int hours = timeInHours.floor();
    int minutes = ((timeInHours - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }

  Future<void> _updateRoutePolyline() async {
    final route = await _getRouteCoordinates(
      _currentLocationMarker.position,
      _destinationLocationMarker.position,
    );
    if (route != null) {
      setState(() {
        _routePolyline = google_maps.Polyline(
          polylineId: const google_maps.PolylineId('route'),
          points: route,
          color: Colors.blue,
          width: 5,
        );
      });
    }
  }

  Future<List<google_maps.LatLng>?> _getRouteCoordinates(
      google_maps.LatLng start, google_maps.LatLng end) async {
    const String apiKey = 'AIzaSyDSrCWuiGHc7LOyI5ZDLTDmanGNPmVDvk4';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<google_maps.LatLng> route = [];
      if (data['routes'].isNotEmpty) {
        final steps = data['routes'][0]['legs'][0]['steps'];
        for (var step in steps) {
          route.add(google_maps.LatLng(
            step['start_location']['lat'],
            step['start_location']['lng'],
          ));
          route.add(google_maps.LatLng(
            step['end_location']['lat'],
            step['end_location']['lng'],
          ));
        }
      }
      return route;
    } else {
      print('Failed to load directions');
      return null;
    }
  }

  void _onPressedArrivedButton() async{
    final response = await context.read<RequestViewModel>().finishRequest();
    if(response == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => RatePage()));
    } else if (response == 404) {
      print("This is not found request");
    } else {
      print('Internal server error');
    }


  }

  @override
  Widget build(BuildContext context) {
    final requestmodel = Provider.of<RequestViewModel>(context);
    String? riderName = requestmodel.request.riderName;
    String? cost = requestmodel.request.cost;
    String? startLocation = requestmodel.request.startLocation;
    String? endLocation = requestmodel.request.endLocation;
    return Scaffold(
      body: Stack(
        children: [
          if (_locationInitialized)
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 12.0,
              ),
              markers: {_currentLocationMarker, _destinationLocationMarker},
              polylines: _routePolyline != null ? {_routePolyline!} : {},
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: ColorManager.primary_white_color,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child : Column(
                  children: [
                    const SizedBox(height: 40,),
                     Row(
                      children: [
                        Image.asset(Apptext.fromLocationIconImage),
                        const SizedBox(width: 10),
                        Expanded(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const Text(
                          'From',
                          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '$startLocation',
                              style: const TextStyle(
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(Apptext.fromLocationIconImage),
                        const SizedBox(width: 10),
                      Expanded(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const Text(
                          'To',
                          style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                            ),                            
                            Text(
                              '$endLocation',
                              style: const TextStyle(
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
                
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              color: ColorManager.primary_white_color,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: AssetImage(Apptext.riderAvatarImage),
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$riderName',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(driverTime, style: const TextStyle(fontSize: 15, color: Colors.black54),),
                                Text(" ($driverDistance)", style: TextStyle(fontSize: 15, color: ColorManager.primary_color, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Add padding for spacing
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Wrap content
                              children: [
                                const Text(
                                  'Text your passenger',
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                                const SizedBox(width: 8), // Space between text and icon
                                Image.asset(Apptext.messageIconImage),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary_color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Add padding for spacing
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min, // Wrap content
                                children: [
                                  Text(
                                    'Call',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8), // Space between text and icon
                                  Icon(Icons.call, color: Colors.white,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.grey, width: 1),
                          color: Colors.white
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Payment Type',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              const Spacer(),
                              Image.asset(Apptext.creditCardIconImage),
                              const SizedBox(width: 5,),
                              const Text(
                                'CREDIT',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              const Text(
                                'Fare Total',
                                style: TextStyle(fontSize: 16, color: Colors.black54),
                              ),
                              const Spacer(),
                              Text(
                                '\$$cost',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:_onPressedArrivedButton,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
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
                                ColorManager.primary_color,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                              maxHeight: 50,
                              minHeight: 50,
                              maxWidth: double.infinity,
                            ),
                            child: const Text(
                              'Arrived at Destination',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
