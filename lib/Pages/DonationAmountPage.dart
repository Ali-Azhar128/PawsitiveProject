import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pawsitive1/Widgets/DonationCardWidget.dart';

class DonationAmountPage extends StatelessWidget {
  const DonationAmountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Get.back();
              },
            );
          },
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Column(
              children: [
                Text(
                  'Donation Amount',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: DonationCard(amt: '100')),
                SizedBox(
                  height: 5,
                ),
                Expanded(child: DonationCard(amt: '500')),
                SizedBox(
                  height: 5,
                ),
                Expanded(child: DonationCard(amt: '1000')),
                SizedBox(
                  height: 5,
                ),
                Expanded(child: DonationCard(amt: '1500')),
                SizedBox(
                  height: 5,
                ),
                Expanded(child: DonationCard(amt: '2000')),
                SizedBox(
                  height: 5,
                ),
                Expanded(child: DonationCard(amt: '10000')),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Other Amount',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 15),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(
                            255, 237, 237, 237), // Background color
                        hintText: 'Enter your donation amount',
                        hintStyle: TextStyle(fontSize: 16), // Hint text
                        prefixIcon: Icon(
                          Icons.money_rounded,
                          color: Colors.black,
                          size: 22,
                        ), // Search Icon
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              12.0), // Adjust the value as needed
                          borderSide:
                              BorderSide.none, // Make the border invisible
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Select Payment Method',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
