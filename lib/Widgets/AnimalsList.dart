import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
                    width: 230,
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
                              '${data['age']} Years',
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
                      ]),
                    ),
                  );
                });
          }),
    );
  }
}
