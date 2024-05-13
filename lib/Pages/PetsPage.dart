import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';

class PetsPage extends StatelessWidget {
  final String ShelterId;
  final double latitude;
  final double longitude;
  const PetsPage(
      {Key? key,
      required this.ShelterId,
      required this.latitude,
      required this.longitude});

  void launchMap() async {
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps);

    try {
      print('longitude $longitude');
      bool? isGoogleMapAvailable =
          await MapLauncher.isMapAvailable(MapType.google);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      String locationName = placemarks.first.name ?? 'Unknown location';

      if (isGoogleMapAvailable! == true) {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: Coords(latitude, longitude),
          title: locationName,
        );
      } else if (availableMaps.isNotEmpty) {
        await availableMaps.first.showMarker(
          coords: Coords(latitude, longitude),
          title: locationName,
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pets for Adoption',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shelters')
            .doc(ShelterId) // You need to provide the shelterId
            .collection('animals')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                    child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          data['image'],
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight.normal, // Default style
                                        color: Colors.black, // Add this
                                      ),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Type: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: data['type']),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 26,
                                        fontWeight:
                                            FontWeight.normal, // Default style
                                        color: Colors.black, // Add this
                                      ),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Color: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(text: data['color']),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: launchMap,
                              child: Text(
                                'Launch Map',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                )),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                )

                    /*ListTile(
                    
                   /* title: Text(data['type']),
                    subtitle: Text(data['color']),
                    leading: Image.network(data['image']),*/
                  ),*/
                    ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
