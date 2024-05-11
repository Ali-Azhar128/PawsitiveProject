import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Pages/DonationAmountPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:map_launcher/map_launcher.dart';

class ShelterInfoPage extends StatefulWidget {
  final String img;
  final String name;
  final String description;
  final String address;
  final String contact;
  final double latitude;
  final double longitude;
  final String shelterId;
  const ShelterInfoPage(
      {required this.img,
      required this.name,
      required this.description,
      required this.address,
      required this.contact,
      required this.latitude,
      required this.longitude,
      required this.shelterId});

  @override
  State<ShelterInfoPage> createState() => _ShelterInfoPageState();
}

class _ShelterInfoPageState extends State<ShelterInfoPage> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    void launchMap() async {
      final availableMaps = await MapLauncher.installedMaps;
      print(availableMaps);
      setState(() {
        isLoading = true;
      });
      try {
        bool? isGoogleMapAvailable =
            await MapLauncher.isMapAvailable(MapType.google);
        List<Placemark> placemarks =
            await placemarkFromCoordinates(widget.latitude, widget.longitude);
        String locationName = placemarks.first.name ?? 'Unknown location';

        if (isGoogleMapAvailable! == true) {
          await MapLauncher.showMarker(
            mapType: MapType.google,
            coords: Coords(widget.latitude, widget.longitude),
            title: locationName,
          );
        } else if (availableMaps.isNotEmpty) {
          await availableMaps.first.showMarker(
            coords: Coords(widget.latitude, widget.longitude),
            title: locationName,
          );
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            widget.img,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'About Us',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(widget.description),
                SizedBox(height: 10),
                Text(
                  'Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(widget.address),
                SizedBox(height: 10),
                Text(
                  'Contact',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text(widget.contact),
                SizedBox(height: 22),
                GestureDetector(
                  onTap: () {
                    launchMap();
                    print('launhced');
                  },
                  child: Button(
                    text: 'Find on Map',
                    isLoading: isLoading,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(DonationAmountPage(shelterId: widget.shelterId));
                  },
                  child: Button(
                    text: 'Donate',
                    isLoading: isLoading,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
