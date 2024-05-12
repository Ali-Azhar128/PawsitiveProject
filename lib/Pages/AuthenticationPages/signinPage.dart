import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:pawsitive1/Controllers/getxControllers/hideIconController.dart';
import 'package:pawsitive1/Controllers/getxControllers/iconColorController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Controllers/getxControllers/loginButtonController.dart';
import 'package:pawsitive1/Controllers/getxControllers/signupFieldController.dart';
import 'package:pawsitive1/Main%20Screen/MainScreen.dart';
import 'package:pawsitive1/Widgets/BottomNav.dart';

import 'package:pawsitive1/Widgets/Button.dart';
import 'package:pawsitive1/Widgets/imageCaptureButton.dart';
import 'package:pawsitive1/styles/textStyles.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:pawsitive1/styles/textStyles.dart';

class signinPage extends StatelessWidget {
  const signinPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    signupFieldController inputFieldController =
        Get.find<signupFieldController>();

    bool blockLogin;

    //Icon controllers to toggle between outlined and normal icons
    IconColorController iconColorController = Get.find<IconColorController>();

    //Controller to toggle visibility icon
    HideIconController hideIconController = Get.find<HideIconController>();

    //Controller for toggling loading indicator inside sign in Button
    loginButtonController loginController = Get.find<loginButtonController>();

    //Functions to determine email and password are valid or not
    bool isEmailValid(String email) {
      return email.contains('@') &&
          (email.endsWith('gmail.com') ||
              email.endsWith('yahoo.com') ||
              email.endsWith('outlook.com'));
    }

    bool isPasswordValid(String password) {
      final passwordRegExp =
          RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@_]).{10,}$');
      return passwordRegExp.hasMatch(password);
    }

    //Firebase function to create user
    //Firebase Auth Instance
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    Future<void> login(String email, String pass) async {
      try {
        print("Done 1");
        final credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        loginController.resetLoading();
        print("done");
      } on FirebaseAuthException catch (e) {
        blockLogin = true;
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        } else if (e.code == 'invalid-email') {
          print('Badly formatted email');
        } else {
          print(e);
        }
      } catch (e) {
        print(e);
      }
    }

    //Global keys for forms
    final _emailFormKey = GlobalKey<FormState>();
    final _passFormKey = GlobalKey<FormState>();

    //Function to check if fields are valid
    bool isFormValid() {
      _emailFormKey.currentState?.validate();
      _passFormKey.currentState?.validate();
      if (_emailFormKey.currentState?.validate() == true &&
          _passFormKey.currentState?.validate() == true) {
        print(_emailFormKey.currentState?.validate());
        print('In if block');
        return true;
      } else {
        print(_emailFormKey.currentState?.validate());
        print(_passFormKey.currentState?.validate());
        print('In else block');
        return false;
      }
    }

    //Form field controllers
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    //Variables
    String email;
    String pass;

    //Text style
    textStyles textStyle = textStyles();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 12, 5),
          child: Obx(
            () => SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                  ),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 40,
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 80, 0, 10),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Welcome Back to ',
                              style: textStyle.kHeadingTextStyle),
                          TextSpan(
                            text: 'PAW',
                            style: textStyle.kHeadingTextStyle,
                          ),
                          TextSpan(
                            text: 'SITIVE',
                            style: textStyle.kHeadingTextStyle
                                .copyWith(color: Color(0xffffba40)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
                    child: Text(
                      "Login to Spread Pawsitivity",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 19, // Set the font size
                          // Make the text bold
                          color: Color.fromARGB(
                              255, 128, 128, 128) // Set your desired text color
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Form(
                      key: _emailFormKey,
                      child: TextFormField(
                        controller: emailController,
                        onChanged: (value) {
                          email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter an email';
                          } else if (!isEmailValid(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 255, 245, 225),
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(
                            color: iconColorController.emailFocus.value
                                ? Colors.black
                                : Color(0xff4a454f),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: iconColorController.emailFocus.value
                                  ? Colors.black
                                  : Colors
                                      .grey, // Change the border color when focused
                              width: iconColorController.emailFocus.value
                                  ? 0.9
                                  : 0.3, // Change the border width when focused
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              // Change the border color when not focused
                              width:
                                  0.1, // Change the border width when not focused
                            ),
                          ),
                          prefixIcon: Icon(
                            iconColorController.emailFocus.value
                                ? Icons.email_rounded
                                : Icons.email_outlined,
                            color: Colors.black,
                          ),
                          labelText: 'Enter Email',
                          hintText: 'johndoe@email.com',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 0.5), // Hide the border lines
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () {
                          iconColorController.setEmailFocus();
                          iconColorController.resetPassFocus();
                          print(iconColorController.emailFocus.value);
                        },
                      ),
                    ),
                  ),
                  Form(
                    key: _passFormKey,
                    child: TextFormField(
                      controller: passwordController,
                      onChanged: (value) {
                        pass = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter a Password';
                        } else if (!isPasswordValid(value)) {
                          return 'Weak Password';
                        } else if (value.length <= 8) {
                          return 'Length should be > 8';
                        }
                        return null;
                      },
                      obscureText: hideIconController.hide.value,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 245, 225),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(
                          color: iconColorController.emailFocus.value
                              ? Colors.black
                              : Color(0xff4a454f),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: iconColorController.passFocus.value
                                ? Colors.black
                                : Colors
                                    .grey, // Change the border color when focused
                            width: iconColorController.passFocus.value
                                ? 0.9
                                : 0.3, // Change the border width when focused
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            // Change the border color when not focused
                            width:
                                0.1, // Change the border width when not focused
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(hideIconController.hide.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () {
                            hideIconController.hide.value == true
                                ? hideIconController.unHide()
                                : hideIconController.setHide();
                          },
                        ),
                        prefixIcon: Icon(
                          iconColorController.passFocus.value
                              ? Icons.lock
                              : Icons.lock_outline,
                          color: Colors.black,
                        ),
                        labelText: 'Enter Password',
                        hintText: 'Must Contain Characters and Numbers',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 0.5), // Hide the border lines
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () {
                        iconColorController.setPassFocus();
                        iconColorController.resetEmailFocus();
                        print(iconColorController.emailFocus.value);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Forgot password? ',
                              style: TextStyle(
                                color: Colors
                                    .black, // Color for the text before "Login"
                                fontSize: 16, // Set your desired font size
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () {},
                              text: 'Reset Your Password',
                              style: TextStyle(
                                color: Colors.blue, // Color for "Login"
                                fontSize: 16, // Set your desired font size
                                // Add more styling here if needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: GestureDetector(
                      onTap: () async {
                        if (!isFormValid()) {
                          print('Credentials are invalid');
                        } else {
                          try {
                            loginController.setLoading();
                            final credential =
                                await firebaseAuth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            loginController.resetLoading();
                            return;
                          }

                          print(emailController.text);
                          print(passwordController.text);

                          loginController.resetLoading();
                          User? currentUser = firebaseAuth.currentUser;
                          String userId = currentUser!.uid;
                          DocumentReference userDocRef =
                              firebaseFirestore.collection('users').doc(userId);
                          DocumentSnapshot userDoc = await userDocRef.get();
                          var data = userDoc.data();

                          print('User data:  ${userDoc['donationAmt']}');
                          Get.offAll(() => BottomNav());
                        }
                      },
                      child: Obx(() => Button(
                            text: "Login",
                            isLoading: loginController.isLoading.value,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
