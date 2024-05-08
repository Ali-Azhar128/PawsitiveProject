import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/signinPage.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/signupPage.dart';
import 'package:pawsitive1/Widgets/BottomNav.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
      if (_user != null) {
        print(_user!.displayName);
        Get.offAll(() => BottomNav());
      }
    });
  }

  Future<void> handleGoogleSignin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google Sign-in cancelled by user');
        return; // Early return if user cancels the Google sign-in
      }
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final DocumentReference userDocRef =
            firestore.collection('users').doc(user.uid);

        final DocumentSnapshot userDoc = await userDocRef.get();
        if (!userDoc.exists) {
          // User document does not exist, create one
          await userDocRef.set({
            'email': user.email,
            'username': user.displayName,
            'createdAt': FieldValue.serverTimestamp(),
            'donationAmt': 0,
            'straysReported': 0,
          });
          print("New user document created.");
        }

        // Now redirect the user to the BottomNav, passing the donation amount
        int donationAmt = userDoc.exists
            ? (userDoc.data() as Map<String, dynamic>)['donationAmt']
            : 0;
        Get.offAll(() => BottomNav());
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        "Sign In Failed",
        "Failed to sign in with Google: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    // Default text color for all spans
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Connecting kind hearts to needy ',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 22.sp)),
                    TextSpan(
                      text: 'paws',

                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22.sp,
                          color: Color.fromARGB(
                              255, 244, 195, 110)), // Specific style for "paws"
                    ),
                    TextSpan(
                        text: '. Help us make a difference!',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 22.sp)),
                  ],
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              GoogleAuthButton(
                darkMode: true,
                onPressed: () {
                  handleGoogleSignin();
                },
                style: AuthButtonStyle(
                  width: double.infinity,
                  height: 50.h,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () {
                  // Handle the button tap here
                  Get.to(() => signupPage());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: double
                      .infinity, // Make the container fill the width of its parent
                  height: 50.h, // Set the height of the container
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        255, 221, 221, 221), // Background color of the button
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  child: Text(
                    'Sign up with email',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: Colors.black, // Text color
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: 20, // Font size
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already a member? ',
                      style: TextStyle(
                        color:
                            Colors.black, // Color for the text before "Login"
                        fontSize: 16, // Set your desired font size
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => signinPage());
                        },
                      text: 'Login',
                      style: TextStyle(
                        color: Colors.blue, // Color for "Login"
                        fontSize: 16, // Set your desired font size
                        // Add more styling here if needed
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
