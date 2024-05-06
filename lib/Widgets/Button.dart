import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  const Button({required this.text, this.isLoading});

  final String text;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 25, 5, 15),
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: isLoading == true
              ? CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  color: Colors.white,
                  strokeWidth: 4,
                )
              : Text(
                  text,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900)),
                ),
        ),
      ),
    );
  }
}
