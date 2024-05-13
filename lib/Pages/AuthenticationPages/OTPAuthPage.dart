import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/signinPage.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPAuthPage extends StatefulWidget {
  final String verificationId;
  final String email;
  final String password;
  final String name;
  final User? user;
  final String phoneNumber;
  const OTPAuthPage(
      {required this.verificationId,
      required this.email,
      required this.password,
      required this.name,
      required this.user,
      required this.phoneNumber});

  @override
  State<OTPAuthPage> createState() => _OTPAuthPageState();
}

class _OTPAuthPageState extends State<OTPAuthPage> {
  Future<void> createUser(String email, String pass, String userName) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      print("Starting OTP");

      if (widget.user != null) {
        // Create a new document with UID as the document ID
        await firestore.collection('users').doc(widget.user?.uid).set({
          'email': email,
          'username': userName,
          'createdAt': FieldValue.serverTimestamp(),
          'donationAmt': 0,
          'straysReported': 0,
          'phoneNumber': widget.phoneNumber,
        });

        print("User and document created successfully.");
        Get.offAll(() =>
            signinPage()); // Navigate to sign-in page after successful registration
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      } else {
        print('FirebaseAuthException: ${e.message}');
      }
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('General Exception: $e');
    }
  }

  String? smsCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OTP Authentication'),
        ),
        body: SafeArea(
            child: Column(
          children: [
            PinFieldAutoFill(
              codeLength: 6,
              onCodeChanged: (code) {
                smsCode = code;
                print('code: $code');
              },
              /*Uncomment this code if you want to automatically submit the OTP
              onCodeSubmitted: (code) {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId, smsCode: 'smsCode');

              },*/
            ),
            GestureDetector(
                onTap: () async {
                  try {
                    print(widget.verificationId);
                    PhoneAuthCredential credential =
                        await PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: smsCode!);
                    print('email: ${widget.email}');
                    createUser(widget.email, widget.password, widget.name);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Button(text: 'Verify OTP')),
          ],
        )));
  }
}
