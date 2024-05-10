import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class AnimalMapScreen extends StatefulWidget {
  final double currentLongitude;
  final double currentLatitude;
  const AnimalMapScreen(
      {required this.currentLongitude, required this.currentLatitude});

  @override
  State<AnimalMapScreen> createState() => _AnimalMapScreenState();
}

class _AnimalMapScreenState extends State<AnimalMapScreen> {
  Set<Marker> markers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    addInitialLocationMarker();
    fetchAnimalLocations();
  }

  void addInitialLocationMarker() {
    LatLng initialPosition =
        LatLng(widget.currentLatitude, widget.currentLongitude);
    markers.add(
      Marker(
        markerId: MarkerId("currentLocation"),
        position: initialPosition,
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: "Your Location"),
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  void fetchAnimalLocations() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('animals').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['longitude'] != null && data['latitude'] != null) {
        LatLng position = LatLng(data['latitude'], data['longitude']);
        markers.add(Marker(
          markerId: MarkerId(doc.id),
          position: position,
          draggable: false,
          infoWindow: InfoWindow(title: data['type']),
        ));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Animals Map',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontWeight: FontWeight.bold,
          )),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.currentLatitude, widget.currentLongitude),
                zoom: 12,
              ),
              markers: markers,
            ),
    );
  }
}
