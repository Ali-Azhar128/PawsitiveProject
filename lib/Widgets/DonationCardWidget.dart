import 'package:flutter/material.dart';

class DonationCard extends StatelessWidget {
  const DonationCard({required this.amt});

  final String amt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 240, 240, 241),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          'Rs ${amt}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
