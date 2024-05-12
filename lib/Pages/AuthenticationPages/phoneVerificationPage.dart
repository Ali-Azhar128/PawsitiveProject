import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/OTPAuthPage.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/signinPage.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:sms_autofill/sms_autofill.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final User? user;
  const PhoneVerificationPage(
      {required this.email,
      required this.password,
      required this.name,
      this.user});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  @override
  Widget build(BuildContext context) {
    String TextReceived = '';
    String phoneNumber = '';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Text recieved: $TextReceived'),
                Text(
                  'Phone Verification',
                  style: GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 20),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: '+92',
                  onChanged: (phone) {
                    phoneNumber = phone.completeNumber;
                    print(phone.completeNumber);
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phoneNumber,
                        verificationCompleted:
                            (PhoneAuthCredential credential) {
                          print('verificationCompleted');
                        },
                        verificationFailed: (FirebaseAuthException e) {
                          Get.snackbar('Error', e.toString(),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red);
                        },
                        codeSent:
                            (String verificationId, int? resendToken) async {
                          print('codeSent');

                          Get.to(() => OTPAuthPage(
                                verificationId: verificationId,
                                email: widget.email,
                                password: widget.password,
                                name: widget.name,
                                user: widget.user,
                              ));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          print('codeAutoRetrievalTimeout');
                        },
                      );
                    },
                    child: Button(text: 'Send OTP'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
