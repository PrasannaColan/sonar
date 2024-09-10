import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Permission Example',
      home: LocationScreen(),
    );
  }
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String locationStatus = "Press the button to check location";

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<void> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // Permissions are denied, display message
      setState(() {
        locationStatus = "Location permission denied";
      });
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, show open app settings dialog
      setState(() {
        locationStatus = "Location permission denied forever, please enable it in settings";
      });
      openAppSettings();
    } else if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      // Permission granted, fetch location
      setState(() {
        locationStatus = "Permission granted, fetching location...";
      });
      fetchLocation();
    }
  }

  Future<void> fetchLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      setState(() {
        locationStatus = "Location services are disabled";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locationStatus = "Current Location: Lat: ${position.latitude}, Long: ${position.longitude}";
    });
  }

  Future<void> openAppSettings() async {
    openAppSettings();
    // if (opened) {
    //   checkPermission(); // Re-check permission if user returns after enabling
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Location Permission Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationStatus),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: checkPermission,
              child: Text("Check Location Permission"),
            ),
          ],
        ),
      ),
    );
  }
}
