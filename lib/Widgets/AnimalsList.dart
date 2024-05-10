import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Pages/AnimalMapScreen.dart';
import 'package:pawsitive1/Widgets/Button.dart';

class AnimalsList extends StatelessWidget {
  const AnimalsList({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return Container(
      height: 260,
      child: FutureBuilder(
          future: firebaseFirestore.collection('animals').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final animals = snapshot.data!.docs;

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  final data = animals[index].data() as Map<String, dynamic>;
                  return Container(
                    margin: EdgeInsets.only(right: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),

                            blurRadius:
                                2, // Adjust this value for the shadow size
                            offset: Offset(0, 2), // Adjust the offset if nee
                          ),
                        ]),
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 6, 5),
                      child: Column(children: [
                        Container(
                          height: 170,
                          child: Image.network(
                            data['image'],
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${data['type']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 20),
                            ),
                            Icon(
                              Icons.male,
                              size: 30,
                              weight: 100,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () => Get.to(() => AnimalMapScreen(
                                currentLongitude: data['longitude'],
                                currentLatitude: data['latitude'],
                              )),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(7)),
                            child: Center(
                              child: Text(
                                'Find on Map',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  );
                });
          }),
    );
  }
}
