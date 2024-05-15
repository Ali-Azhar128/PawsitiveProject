import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawsitive1/Pages/AnimalMapScreen.dart';

class NearbyAnimalsScreen extends StatefulWidget {
  @override
  _NearbyAnimalsScreenState createState() => _NearbyAnimalsScreenState();
}

class _NearbyAnimalsScreenState extends State<NearbyAnimalsScreen> {
  Stream<List<DocumentSnapshot>>? animalStream;

  @override
  void initState() {
    super.initState();
    setupLocation();
  }

  Future<void> setupLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Handle location permission denied
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    GeoFirePoint center = GeoFlutterFire()
        .point(latitude: position.latitude, longitude: position.longitude);
    print(position.latitude);

    CollectionReference animals =
        FirebaseFirestore.instance.collection('animals');

    double radius = 50; // Adjust this value as needed
    String field = 'locations'; // The field that contains the GeoPoint

    animalStream = GeoFlutterFire()
        .collection(collectionRef: animals)
        .within(center: center, radius: radius, field: field, strictMode: true);

    print('here');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Animals'),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: animalStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while waiting for data
          }

          List<DocumentSnapshot> animals = snapshot.data!;
          return ListView.builder(
            itemCount: animals.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> animal =
                  animals[index].data() as Map<String, dynamic>;
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimalMapScreen(
                          currentLongitude: animal['longitude'],
                          currentLatitude: animal['latitude'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.network(animal['image']),
                    title: Text(animal['type']),
                    subtitle: Text(
                        'Color: ${animal['color']}, Breed: ${animal['breed']}'),
                  ),
                ),
              );
            },
          );
          ;
        },
      ),
    );
  }
}
