import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Pages/ShelterReviewPage.dart';
import 'package:pawsitive1/Widgets/Button.dart';

class ShelterReview extends StatefulWidget {
  final String shelterId;
  const ShelterReview({Key? key, required this.shelterId}) : super(key: key);

  @override
  _ShelterReviewState createState() => _ShelterReviewState();
}

class _ShelterReviewState extends State<ShelterReview> {
  User? user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _reviewsStream;

  @override
  void initState() {
    super.initState();
    _reviewsStream = FirebaseFirestore.instance
        .collection('shelters')
        .doc(widget.shelterId)
        .collection('reviews')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shelter Reviews'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('shelters')
                    .doc(widget.shelterId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> shelterSnapshot) {
                  if (shelterSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (shelterSnapshot.hasError) {
                    return Text("Error: ${shelterSnapshot.error}");
                  }
                  var shelterData =
                      shelterSnapshot.data!.data() as Map<String, dynamic>;
                  double averageRating = shelterData['ratings'].toDouble();
                  double totalReviews = shelterData['totalReviews'].toDouble();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: averageRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 50.0,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            averageRating.toStringAsFixed(2),
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 20, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                totalReviews.toInt().toString() + ' reviews',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey)),
                              ),
                              user == null
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () =>
                                          Get.to(() => ShelterReviewPage(
                                                shelterId: widget.shelterId,
                                                shelterName:
                                                    shelterData['name'],
                                              )),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        padding:
                                            EdgeInsets.fromLTRB(10, 3, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors
                                              .black, //Color.fromARGB(255, 255, 221, 163),
                                        ),
                                        child: Row(children: [
                                          Text(
                                            'Add Review',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_right,
                                            size: 34,
                                            color: Colors.white,
                                          ),
                                        ]),
                                      ),
                                    )
                            ]),
                      ),
                    ],
                  );
                },
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'All Reviews',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 36,
                )),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _reviewsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 0, 0),
                  child: Column(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(data['user'])
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (userSnapshot.hasError) {
                            return Text("Error: ${userSnapshot.error}");
                          }
                          var userData =
                              userSnapshot.data!.data() as Map<String, dynamic>;
                          return Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      RatingBar.builder(
                                        ignoreGestures: true,
                                        initialRating:
                                            data['ratings'].toDouble(),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        userData['username'],
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(data['review']),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                ]),
                            //title: Text(data['review']),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
