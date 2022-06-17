import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late LocationData _myLocationData;
  late List<double> _vehicleLocationData;
  final MapController _mapController = MapController();
  bool locationsHaveLoaded = false;
  final Location location = Location();
  late Timer _timer;
  late StreamSubscription locationSubscription;

  Future<void> getDeviceLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    print("ME");
    _myLocationData = await location.getLocation();

    locationSubscription = location.onLocationChanged.listen((event) {
      _myLocationData = event;
    });
  }

  Future<bool> loadLocations() async {
    try {
      // Get user's current location
      await getDeviceLocation();
      print("FIRST TIME !");
      // Update location from realtime database
      _vehicleLocationData = [
        (_myLocationData.latitude as double) - 0.001,
        (_myLocationData.longitude as double) - 0.001,
      ];
    } catch (e) {
      print(e);

      return false;
    }
    setState(() {
      locationsHaveLoaded = true;
    });
    return true;
  }

  Future<void> goToDeviceLocation() async {
    setState(() {
      _mapController.move(
          LatLng(_myLocationData.latitude as double,
              _myLocationData.longitude as double),
          18);
    });
  }

  Future<void> goToVehicleLocation() async {
    setState(() {
      _mapController.move(
          LatLng(_vehicleLocationData[0], _vehicleLocationData[1]), 18);
    });
  }

  @override
  void initState() {
    super.initState();
    loadLocations();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
        centerTitle: true,
      ),
      body: !locationsHaveLoaded
          ? const CircularProgressIndicator()
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                maxZoom: 18,
                center: LatLng(
                  _myLocationData.latitude as double,
                  _myLocationData.longitude as double,
                ),
                zoom: 18.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    // My location
                    Marker(
                      width: 20.0,
                      height: 20.0,
                      point: LatLng(
                        _myLocationData.latitude as double,
                        _myLocationData.longitude as double,
                      ),
                      builder: (ctx) => const Icon(
                        Icons.location_on,
                      ),
                    ),
                    // Vehicle location
                    Marker(
                      width: 20.0,
                      height: 20.0,
                      point: LatLng(
                        _vehicleLocationData[0],
                        _vehicleLocationData[1],
                      ),
                      builder: (ctx) => const Icon(
                        Icons.two_wheeler,
                        color: Colors.black,
                      ),
                    )
                  ],
                )
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SizedBox(
          width: screenWidth * 0.9,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                onPressed: () async {
                  goToDeviceLocation();
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.location_on),
              ),
              FloatingActionButton(
                onPressed: () async {
                  goToVehicleLocation();
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.two_wheeler),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
