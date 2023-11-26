import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:pawsitive1/styles/textStyles.dart';

class ImageCaptureButton extends StatefulWidget {
  const ImageCaptureButton({Key? key}) : super(key: key);

  @override
  State<ImageCaptureButton> createState() => _AddItemState();
}

class _AddItemState extends State<ImageCaptureButton> {
  TextEditingController _controllerColor = TextEditingController();
  TextEditingController _controllerType = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('animals');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    textStyles txtStyle = textStyles();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Found a Stray Animal?',
                  style: txtStyle.kHeadingTextStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextFormField(
                    controller: _controllerType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 245, 225),
                      hintStyle: TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .grey, // Change the border color when focused
                            width: 0.5 // Change the border width when focused
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
                      labelText: 'What animal is it?',
                      hintText: 'e.g. Dog, cat...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5), // Hide the border lines
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the animal name';
                      }

                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 245, 225),
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .grey, // Change the border color when focused
                          width: 0.5 // Change the border width when focused
                          ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        // Change the border color when not focused
                        width: 0.1, // Change the border width when not focused
                      ),
                    ),
                    labelText: 'Please specify color',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5), // Hide the border lines
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 245, 225),
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .grey, // Change the border color when focused
                          width: 0.5 // Change the border width when focused
                          ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        // Change the border color when not focused
                        width: 0.1, // Change the border width when not focused
                      ),
                    ),
                    labelText: 'Enter Breed if known',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 0.5), // Hide the border lines
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () async {
                    /*
                    * Step 1. Pick/Capture an image   (image_picker)
                    * Step 2. Upload the image to Firebase storage
                    * Step 3. Get the URL of the uploaded image
                    * Step 4. Store the image URL inside the corresponding
                    *         document of the database.
                    * Step 5. Display the image on the list
                    *
                    * */

                    /*Step 1:Pick image*/
                    //Install image_picker
                    //Import the corresponding library

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    print('${file?.path}');

                    if (file == null) return;
                    //Import dart:core
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                        referenceDirImages.child('name');

                    //Handle errors/success
                    try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(file!.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                    height: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Click to Add Image",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: () async {
                      if (imageUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please upload an image')));

                        return;
                      }

                      if (key.currentState!.validate()) {
                        String type = _controllerType.text;
                        String color = _controllerColor.text;

                        //Create a Map of data
                        Map<String, String> dataToSend = {
                          'type': type,
                          'color': color,
                          'image': imageUrl,
                        };

                        //Add a new item
                        _reference.add(dataToSend);
                      }
                    },
                    child: Button(
                      text: 'Submit',
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
