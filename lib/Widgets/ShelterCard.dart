import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:pawsitive1/Pages/DonationAmountPage.dart';

class ShelterCard extends StatelessWidget {
  const ShelterCard({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: FutureBuilder(
          future: firebaseFirestore.collection('shelters').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final shelters = snapshot.data!.docs;

            return Container(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: shelters.length,
                  itemBuilder: ((context, index) {
                    var shelter = shelters[index];
                    final data = shelters[index].data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        print(shelter.id);
                        Get.to(() => DonationAmountPage(shelterId: shelter.id));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 245, 245, 245),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 186, 186, 186),
                                offset: Offset(0, 1),
                                blurRadius: 4,
                              )
                            ]),
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: data['image'] == ""
                                    ? Center(child: Text('No Image'))
                                    : Image.network(
                                        data['image'],
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 100, 0, 100),
                                                child: SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 5,
                                                    strokeCap: StrokeCap.round,
                                                    color: Colors.yellow,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      )),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                data['name'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: LinearProgressIndicator(
                                value: data['totalFundingDone'] /
                                    data['totalFundingReq'],
                                backgroundColor:
                                    Color.fromARGB(255, 222, 221, 221),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 248, 203, 69)),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBar.builder(
                                    unratedColor:
                                        Color.fromARGB(255, 213, 213, 213),
                                    ignoreGestures: true,
                                    itemSize: 30,
                                    initialRating: data['ratings'] == null
                                        ? 0
                                        : data['ratings'].toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(right: 7),
                                      child: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                'Rs ${data['totalFundingDone']} ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text:
                                                '/ ${data['totalFundingReq']}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 151, 151, 151),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            );
          }),
    );
  }
}
