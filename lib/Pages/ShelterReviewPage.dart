import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Widgets/Button.dart';

class ShelterReviewPage extends StatefulWidget {
  final String shelterId;
  final String shelterName;

  ShelterReviewPage({required this.shelterId, required this.shelterName});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ShelterReviewPage> {
  final _reviewController = TextEditingController();
  double _rating = 0.0;

  Future<void> _submitReview() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    CollectionReference shelters =
        FirebaseFirestore.instance.collection('shelters');
    DocumentSnapshot shelterDoc = await shelters.doc(widget.shelterId).get();
    double oldRating = shelterDoc['ratings'].toDouble();
    double totalReviews = shelterDoc['totalReviews'].toDouble();
    double newRating =
        (oldRating * totalReviews + _rating) / (totalReviews + 1);
    print(newRating);

    await shelters.doc(widget.shelterId).update({
      'ratings': newRating,
      'totalReviews': totalReviews + 1,
    });

    await shelters.doc(widget.shelterId).collection('reviews').add({
      'ratings': _rating,
      'review': _reviewController.text,
      'user': user.uid,
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Review submitted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Review ${widget.shelterName}',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(fontWeight: FontWeight.w500)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tap to Rate',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
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
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              'Tell us more (optional)',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            ),
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Your review',
              ),
            ),
            GestureDetector(
                onTap: () => _submitReview(),
                child: Button(text: 'Submit Review'))
          ],
        ),
      ),
    );
  }
}
