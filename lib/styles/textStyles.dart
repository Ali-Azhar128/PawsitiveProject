import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Controllers/getxControllers/hideIconController.dart';
import 'package:pawsitive1/Controllers/getxControllers/iconColorController.dart';

class textStyles {
  TextStyle kHeadingTextStyle = GoogleFonts.roboto(
    textStyle: TextStyle(
        fontSize: 30, // Set the font size
        fontWeight: FontWeight.w900, // Make the text bold
        color: Color.fromARGB(255, 68, 68, 68) // Set your desired text color
        ),
  );

  TextStyle kSubheadingTextStyle = GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 19, // Set the font size
      // Make the text bold
      color: Color.fromARGB(255, 128, 128, 128) // Set your desired text color
      );
}
