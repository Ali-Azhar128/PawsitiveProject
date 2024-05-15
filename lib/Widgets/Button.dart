import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  const Button({required this.text, this.isLoading});

  final String text;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(5.w, 8.h, 5.w, 8.h),
        margin: EdgeInsets.fromLTRB(5.w, 8.h, 5.w, 10.h),
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(8)),
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
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900)),
                ),
        ),
      ),
    );
  }
}
