import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:pawsitive1/Controllers/getxControllers/hideIconController.dart';
import 'package:pawsitive1/Controllers/getxControllers/iconColorController.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Controllers/getxControllers/signupFieldController.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/signinPage.dart';

import 'package:pawsitive1/Widgets/Button.dart';

class signupPage extends StatelessWidget {
  const signupPage({super.key});

  @override
  Widget build(BuildContext context) {
    signupFieldController inputFieldController =
        Get.find<signupFieldController>();

    //Icon controllers to toggle between outlined and normal icons
    IconColorController iconColorController = Get.find<IconColorController>();

    //Controller to toggle visibility icon
    HideIconController hideIconController = Get.find<HideIconController>();

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
    Future<void> createUser(String email, String pass) async {
      try {
        print("Done 1");
        final credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
        print("done");
      } on FirebaseAuthException catch (e) {
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
    final _usernameFormKey = GlobalKey<FormState>();

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
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    //Variables
    String username;
    String email;
    String pass;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
          ),
          Container(
            color: Color.fromARGB(255, 250, 201, 115),
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.57,
            left: 0,
            right: 0,
            child: Image(
              height: 300,
              image: AssetImage('Assets/Images/signupPageImage.png'),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 12, 5),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        "Embark on Your Pet-loving Journey",
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 30, // Set the font size
                              fontWeight: FontWeight.w900, // Make the text bold
                              color: Color.fromARGB(255, 68, 68,
                                  68) // Set your desired text color
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      child: Text(
                        "Sign Up and Be a Pet Hero",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 19, // Set the font size
                            // Make the text bold
                            color: Color.fromARGB(255, 128, 128,
                                128) // Set your desired text color
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Form(
                        key: _usernameFormKey,
                        child: TextFormField(
                          onChanged: (value) {
                            username = value;
                          },
                          controller: usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 255, 245, 225),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(
                              color: iconColorController.nameFocus.value
                                  ? Colors.black
                                  : Color(0xff4a454f),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: iconColorController.nameFocus.value
                                    ? Colors.black
                                    : Colors
                                        .grey, // Change the border color when focused
                                width: iconColorController.nameFocus.value
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
                              iconColorController.nameFocus.value
                                  ? Icons.person_2_rounded
                                  : Icons.person_2_outlined,
                              color: Colors.black,
                            ),
                            labelText: 'Enter Username',
                            hintText: 'John Doe',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5), // Hide the border lines
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTap: () {
                            iconColorController.resetEmailFocus();
                            iconColorController.resetPassFocus();
                            iconColorController.setUsernameFocus();
                            print(iconColorController.nameFocus.value);
                          },
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
                            iconColorController.resetUsernameFocus();
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
                          iconColorController.resetUsernameFocus();
                          iconColorController.resetEmailFocus();
                          print(iconColorController.emailFocus.value);
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (!isFormValid()) {
                          print('Credentials are invalid');
                        } else {
                          await createUser(
                              emailController.text, passwordController.text);
                          // Get.to(AnimalScreen());
                          print('User created');
                        }
                      },
                      child: Button(text: "Register"),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already a member? ',
                              style: TextStyle(
                                color: Colors
                                    .black, // Color for the text before "Login"
                                fontSize: 16, // Set your desired font size
                              ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.to(signinPage());
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
