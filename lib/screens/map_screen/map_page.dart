import 'dart:async';

import 'package:ParkShield/services/Firebase/FireDatabase/firedatabase.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key, required this.vehicleID})
      : super(key: key);
  final String vehicleID;
  @override
  State<CurrentLocationScreen> createState() =>
      CurrentLocationScreenState(vehicleID: vehicleID);
}

class CurrentLocationScreenState extends State<CurrentLocationScreen> {
  CurrentLocationScreenState({required this.vehicleID});
  late Timer _timer;
  final String vehicleID;

  late GoogleMapController _mapController;
  late BitmapDescriptor bikeIcon;
  final Location location = Location();

  late LocationData _myLocationData;
  late List<double> _vehicleLocationData;
  late StreamSubscription locationSubscription;

  bool locationsHaveLoaded = false;

  // Get Device Location
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

  Future<void> getVehicleLocation({required int vehicleID}) async {
    _vehicleLocationData = await readVehicleCoordinates(vehicleID: vehicleID);
  }

  // Load initial locations
  Future<bool> loadLocations({required int vehicleID}) async {
    try {
      // Get user's current location
      await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(2, 2)), "assets/img/bike.png")
          .then((d) {
        bikeIcon = d;
      });
      await getDeviceLocation();
      await getVehicleLocation(vehicleID: vehicleID);
      print("FIRST TIME !");
      // Update location from realtime database
    } catch (e) {
      print(e);

      return false;
    }

    // _timer is not initialized
    try {
      _timer;
    } catch (error) {
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        await getDeviceLocation();
        await getVehicleLocation(vehicleID: vehicleID);
        setState(() {});
        _timer = timer;
      });
    }
    setState(() {
      locationsHaveLoaded = true;
    });
    return true;
  }

  // Center map to device location
  Future<void> goToDeviceLocation() async {
    setState(() {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_myLocationData.latitude as double,
                  _myLocationData.longitude as double),
              zoom: 18),
        ),
      );
    });
  }

  Future<void> goToVehicleLocation() async {
    setState(() {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_vehicleLocationData[0], _vehicleLocationData[1]),
              zoom: 18),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    loadLocations(vehicleID: int.parse(vehicleID));
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer.isActive) {
      _timer.cancel();
    }

    locationSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final num screenWidth = MediaQuery.of(context).size.width;
    final num screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Location",
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 32,
              ),
        ),
        centerTitle: true,
      ),
      body: !locationsHaveLoaded
          ? const CircularProgressIndicator()
          : GoogleMap(
              mapType: MapType.normal,
              markers: {
                Marker(
                    markerId: MarkerId(widget.vehicleID),
                    icon: bikeIcon,
                    position: LatLng(
                        _vehicleLocationData[0], _vehicleLocationData[1]))
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(_myLocationData.latitude as double,
                    _myLocationData.longitude as double),
              ),
              onMapCreated: (GoogleMapController controller) async {
                _mapController = controller;
                await _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(_myLocationData.latitude as double,
                            _myLocationData.longitude as double),
                        zoom: 18),
                  ),
                );
              },
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


// class CurrentLocationScreeTEMP extends StatefulWidget {
//   const CurrentLocationScreeTEMP({Key? key, required this.vehicleID})
//       : super(key: key);
//   final String vehicleID;
//   @override
//   _CurrentLocationScreeTEMPState createState() => _CurrentLocationScreeTEMPState();
// }

// class _CurrentLocationScreeTEMPState extends State<CurrentLocationScreeTEMP> {
//   late LocationData _myLocationData;
//   late List<double> _vehicleLocationData;
//   final MapController _mapController = MapController();
//   bool locationsHaveLoaded = false;
//   final Location location = Location();

//   late StreamSubscription locationSubscription;

//   // Get Device Location
//   Future<void> getDeviceLocation() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;

//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     print("ME");

//     _myLocationData = await location.getLocation();

//     locationSubscription = location.onLocationChanged.listen((event) {
//       _myLocationData = event;
//     });
//   }

//   // Load initial locations
//   Future<bool> loadLocations() async {
//     try {
//       // Get user's current location
//       await getDeviceLocation();
//       print("FIRST TIME !");
//       // Update location from realtime database
//       _vehicleLocationData = [
//         (_myLocationData.latitude as double) - 0.001,
//         (_myLocationData.longitude as double) - 0.001,
//       ];
//     } catch (e) {
//       print(e);

//       return false;
//     }
//     setState(() {
//       locationsHaveLoaded = true;
//     });
//     return true;
//   }

//   // Center map to device location
//   Future<void> goToDeviceLocation() async {
//     setState(() {
//       _mapController.move(
//           LatLng(_myLocationData.latitude as double,
//               _myLocationData.longitude as double),
//           18);
//     });
//   }

//   Future<void> goToVehicleLocation() async {
//     setState(() {
//       _mapController.move(
//           LatLng(_vehicleLocationData[0], _vehicleLocationData[1]), 18);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadLocations();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     locationSubscription.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print(widget.vehicleID);
//     final num screenWidth = MediaQuery.of(context).size.width;
//     final num screenHeight = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Location"),
//         centerTitle: true,
//       ),
//       body: !locationsHaveLoaded
//           ? const CircularProgressIndicator()
//           : FlutterMap(
//               mapController: _mapController,
//               options: MapOptions(
//                 maxZoom: 18,
//                 center: LatLng(
//                   _myLocationData.latitude as double,
//                   _myLocationData.longitude as double,
//                 ),
//                 zoom: 18.0,
//               ),
//               layers: [
//                 TileLayerOptions(
//                     urlTemplate:
//                         "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                     subdomains: ['a', 'b', 'c']),
//                 MarkerLayerOptions(
//                   markers: [
//                     // My location
//                     Marker(
//                       width: 20.0,
//                       height: 20.0,
//                       point: LatLng(
//                         _myLocationData.latitude as double,
//                         _myLocationData.longitude as double,
//                       ),
//                       builder: (ctx) => const Icon(
//                         Icons.location_on,
//                       ),
//                     ),
//                     // Vehicle location
//                     Marker(
//                       width: 20.0,
//                       height: 20.0,
//                       point: LatLng(
//                         _vehicleLocationData[0],
//                         _vehicleLocationData[1],
//                       ),
//                       builder: (ctx) => const Icon(
//                         Icons.two_wheeler,
//                         color: Colors.black,
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 35),
//         child: SizedBox(
//           width: screenWidth * 0.9,
//           child: Wrap(
//             alignment: WrapAlignment.spaceBetween,
//             children: [
//               FloatingActionButton(
//                 onPressed: () async {
//                   goToDeviceLocation();
//                 },
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 child: const Icon(Icons.location_on),
//               ),
//               FloatingActionButton(
//                 onPressed: () async {
//                   goToVehicleLocation();
//                 },
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//                 child: const Icon(Icons.two_wheeler),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
