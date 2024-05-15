import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/welcomeScreen.dart';
import 'package:pawsitive1/Pages/DonationPage.dart';
import 'package:pawsitive1/Pages/NearbyAnimalsScreen.dart';
import 'package:pawsitive1/Widgets/AnimalsList.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:pawsitive1/styles/textStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    Future<void> signOut() async {
      try {
        await _auth.signOut();
        print('Signed Out sucessfully!');

        Get.offAll(() => WelcomeScreen());
      } catch (e) {
        print("Error Signing Out: $e");
      }
    }

    textStyles txtStyle = textStyles();
    return Scaffold(
      appBar: AppBar(
        // Optional: add an icon for the drawer in the AppBar
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Center(
                child: Text(
                  'User Dashboard',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  userId == null
                      ? ListTile(
                          title: Text(
                            'Log In',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20)),
                          ),
                          leading: Icon(Icons.login, size: 30, weight: 100),
                          onTap: () {
                            Get.to(() => WelcomeScreen());
                          },
                        )
                      : Container(),
                  userId != null
                      ? ListTile(
                          title: Text(
                            'Log Out',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20)),
                          ),
                          leading: Icon(Icons.logout, size: 30, weight: 100),
                          onTap: () {
                            signOut();
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfffcbc59),
                  borderRadius: BorderRadius.circular(15),
                ),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16.sp),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => DonationPage());
                      },
                      child: Button(
                        text: 'Donate',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17.h),
              Text(
                'Search For a Pet',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 237, 237, 237),
                  hintText: 'Search',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  prefixIcon:
                      Icon(Icons.search, color: Colors.black, size: 20.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => NearbyAnimalsScreen()),
                    child: Text(
                      'See All',
                      style: TextStyle(
                          color: Color(0xff99a2b9),
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              AnimalsList()
            ],
          ),
        ),
      ),
    );
  }
}
