import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawsitive1/Pages/DonationPage.dart';
import 'package:pawsitive1/Widgets/AnimalsList.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:pawsitive1/styles/textStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    textStyles txtStyle = textStyles();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu_outlined,
                          size: 40,
                        )),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: Center(
                          child: Text(
                        'H',
                      )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfffcbc59),
                    borderRadius: BorderRadius.circular(15)),
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 12, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Join Today\nand Save Lives',
                      style: txtStyle.kHeadingTextStyle,
                    ),
                    Text(
                      'Shelter pets need your monthly gift',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          QuerySnapshot querySnapshot = await firebaseFirestore
                              .collection('animals')
                              .get();

                          querySnapshot.docs.forEach(
                            (e) {
                              print(e['age']);
                            },
                          );
                        } catch (e) {
                          print(e);
                        }

                        print('in button');
                      },
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => DonationPage());
                        },
                        child: Button(
                          text: 'Donate',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 17,
              ),
              Text(
                'Search For a Pet',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      Color.fromARGB(255, 237, 237, 237), // Background color
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
                    borderSide: BorderSide.none, // Make the border invisible
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
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
              SizedBox(
                height: 15,
              ),
              AnimalsList(),
            ],
          ),
        ),
      ),
    );
  }
}
/* FutureBuilder<QuerySnapshot>(
                future: firebaseFirestore.collection('animals').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('here');
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print('here1');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Extract and display data in a container
                  final animals = snapshot.data!.docs;
                  print(animals);

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: animals.length,
                    itemBuilder: (context, index) {
                      final data =
                          animals[index].data() as Map<String, dynamic>;
                      return Container(
                        height: 50,
                        width: 50,
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(16),
                        color: Colors.blue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              child: Image.network(data['image']),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            /*Text('Age: ${data['age']}'),
                  Text('Color: ${data['color']}'),
                  Text('Gender: ${data['gender']}'),
                  Text('Species: ${data['species']}'),
                  Text('Type: ${data['type']}'),*/
                          ],
                        ),
                      );
                    },
                  );
                },
              )*/