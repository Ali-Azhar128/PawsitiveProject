import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pawsitive1/Widgets/ShelterCard.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        body: Center(
          child: Text("No user signed in."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Get.back(),
            );
          },
        ),
        title: Text('Donation'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text("No data found for this user.");
            }

            var userData = snapshot.data!;
            int amt = userData['donationAmt'] ?? 0;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 15, 12, 8),
                  child: Card(
                    color: Color(0xfffcbc59),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 30, 8, 30),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            Icons.wallet_outlined,
                            size: 40,
                          ),
                          height: 60,
                          width: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Total Fundings',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 61, 61, 61),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  amt.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                )
                              ]),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 40,
                          width: 110,
                          padding: EdgeInsets.fromLTRB(15, 0, 8, 0),
                          child: Center(
                            child: Text(
                              'View',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 15),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(
                          255, 237, 237, 237), // Background color
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 16), // Hint text
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 22,
                      ), // Search Icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            12.0), // Adjust the value as needed
                        borderSide:
                            BorderSide.none, // Make the border invisible
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                            color: Color(0xff99a2b9),
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Expanded(child: ShelterCard())
              ],
            );
          },
        ),
      ),
    );
  }
}
