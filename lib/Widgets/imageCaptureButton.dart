import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:pawsitive1/styles/textStyles.dart';

class ImageCaptureButton extends StatefulWidget {
  const ImageCaptureButton({Key? key}) : super(key: key);

  @override
  State<ImageCaptureButton> createState() => _AddItemState();
}

class _AddItemState extends State<ImageCaptureButton> {
  bool isLoading = false;

  TextEditingController _controllerType = TextEditingController();
  TextEditingController _controllerColor = TextEditingController();
  TextEditingController _controllerBreed = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? imageUrl = '';
  double? latitude;
  double? longitude;
  void getLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      LocationPermission permission = await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        isLoading = false;
      });
      latitude = position.latitude;
      longitude = position.longitude;
      print(position.latitude);
      print(position.longitude);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    textStyles txtStyle = textStyles();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Found a Stray Animal?',
                  style: txtStyle.kHeadingTextStyle,
                ),
                TextFormField(
                  controller: _controllerType,
                  decoration: InputDecoration(
                    labelText: 'Animal Type (e.g. Dog, Cat)',
                    prefixIcon: Icon(Icons.pets),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the type of animal';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _controllerColor,
                  decoration: InputDecoration(
                    labelText: 'Color',
                    prefixIcon: Icon(Icons.color_lens),
                  ),
                ),
                TextFormField(
                  controller: _controllerBreed,
                  decoration: InputDecoration(
                    labelText: 'Breed (if known)',
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: isLoading == true
                            ? () {
                                Get.snackbar('Uploading Image',
                                    'Please wait while the image is being uploaded',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red);
                              }
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final picker = ImagePicker();
                                var pickedFile = await picker.pickImage(
                                    imageQuality: 30,
                                    source: ImageSource.camera);

                                if (pickedFile != null) {
                                  File file = File(pickedFile.path);
                                  imageUrl = await uploadImage(file);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              },
                        child: Button(
                          text: 'Capture Image',
                          isLoading: isLoading,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: isLoading == true
                            ? () {
                                Get.snackbar('Uploading Image',
                                    'Please wait while the image is being uploaded',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red);
                              }
                            : () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                    imageQuality: 30,
                                    source: ImageSource.gallery);

                                if (pickedFile != null) {
                                  File file = File(pickedFile.path);
                                  imageUrl = await uploadImage(file);
                                }
                              },
                        child: Button(
                          text: 'Select from Gallery',
                          isLoading: isLoading,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: isLoading == true
                      ? () {
                          Get.snackbar('Uploading Image',
                              'Please wait while the image is being uploaded',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red);
                        }
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            if (imageUrl == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Please upload an image')),
                              );
                              return;
                            }

                            // Implement data submission to Firestore
                            await submitStrayDetails();
                          }
                        },
                  child: Button(
                    text: 'Submit Details',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadImage(File? imageFile) async {
    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = storageRef.putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      imageFile = null;
    });
    return downloadUrl;
  }

  Future<void> submitStrayDetails() async {
    isLoading = true;
    Map<String, dynamic> strayData = {
      'type': _controllerType.text,
      'color': _controllerColor.text,
      'breed': _controllerBreed.text,
      'image': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
    };

    await FirebaseFirestore.instance.collection('animals').add(strayData);

    // Increment the stray count in the user's document
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    userDocRef.update({
      'straysReported': FieldValue.increment(1),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Stray details submitted successfully')),
    );
    setState(() {
      isLoading = false;
      imageUrl = null;
    });
  }
}
