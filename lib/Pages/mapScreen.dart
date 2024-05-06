import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MapWidget> {
  var count = 0;
  Set<Marker> markers = {};
  bool isLoading = true;
  LatLng? latLng;
  void getLocation() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('shelters').get();
    //print(querySnapshot.docs);
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      var location = data['location'];

      if (location is GeoPoint) {
        print(
            'Latitude: ${location.latitude}, Longitude: ${location.longitude}');
        var myLatLng = LatLng(location.latitude, location.longitude);
        print(myLatLng);

        if (location != null) {
          count++;
          markers!.add(Marker(
              markerId: MarkerId(count.toString()),
              position: myLatLng,
              draggable: false,
              infoWindow: InfoWindow(title: data['name'])));
        }
      }
    }

    /*FirebaseFirestore.instance
        .collection('shelters')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        
        
      });
    });*/

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      LocationPermission permission = await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        isLoading = false;
      });
      print(latLng);
      print(position.latitude);
      print(position.longitude);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading || latLng == null
          ? Center(
              child: CircularProgressIndicator(
                strokeCap: StrokeCap.round,
                color: Colors.white,
                strokeWidth: 7,
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: latLng!, zoom: 10),
              markers: markers,
            ),
    );
  }
}

      /*body: GoogleMap(
        initialCameraPosition: CameraPosition(target: latLng!, zoom: 12),
      ),*/