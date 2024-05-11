import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawsitive1/Widgets/Button.dart';
import 'package:pawsitive1/payment.dart'; // Ensure this import points to your actual file that handles payment.

class DonationAmountPage extends StatefulWidget {
  final shelterId;
  DonationAmountPage({required this.shelterId});

  @override
  State<DonationAmountPage> createState() => _DonationAmountPageState();
}

class _DonationAmountPageState extends State<DonationAmountPage> {
  // Text editing controllers for each field
  final TextEditingController donationAmountController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressLineController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  bool isLoading = false;

  // Form Keys
  final formKeyDonationAmount = GlobalKey<FormState>();
  final formKeyName = GlobalKey<FormState>();
  final formKeyAddressLine = GlobalKey<FormState>();
  final formKeyCity = GlobalKey<FormState>();
  final formKeyState = GlobalKey<FormState>();
  final formKeyCountry = GlobalKey<FormState>();
  final formKeyPincode = GlobalKey<FormState>();

  Future<void> handleSuccessfulPayment() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Firestore collection setup
      var donationsRef = FirebaseFirestore.instance.collection('donations');

      // Donation data
      var donationData = {
        'amount': int.parse(donationAmountController.text),
        'date': DateTime.now(),
        'userId': user.uid,
        'name': nameController.text,
        'address': addressLineController.text,
        'city': cityController.text,
        'state': stateController.text,
        'country': countryController.text,
        'zipCode': pincodeController.text,
        'shelterId': widget.shelterId
      };

      // Add donation data to Firestore
      await donationsRef.add(donationData).then((docRef) async {
        print("Donation recorded with ID: ${docRef.id}");

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'donationAmt':
              FieldValue.increment(int.parse(donationAmountController.text))
        });

        // Update totalFundingDone in shelters collection
        await FirebaseFirestore.instance
            .collection('shelters')
            .doc(widget.shelterId)
            .update({
          'totalFundingDone':
              FieldValue.increment(int.parse(donationAmountController.text))
        });
      }).catchError((error) {
        print("Error adding donation: $error");
      });
    }
  }

  Future<void> initPaymentSheet() async {
    try {
      setState(() {
        isLoading = true;
      });
      // 1. create payment intent on the client side
      final data = await createPaymentIntent(
          name: nameController.text,
          address: addressLineController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text,
          currency: 'pkr',
          amount: (int.parse(donationAmountController.text) * 100));

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options

          style: ThemeMode.dark,
        ),
      );

      print(data);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

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
        title: const Text('Donation Page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Please fill your donation details:',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 35),
              Form(
                key: formKeyDonationAmount,
                child: TextFormField(
                  controller: donationAmountController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Donation Amount',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Cannot be empty" : null,
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: formKeyName,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Name',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Cannot be empty" : null,
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: formKeyAddressLine,
                child: TextFormField(
                  controller: addressLineController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelStyle: TextStyle(color: Colors.black),
                    labelText: 'Address Line',
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Cannot be empty" : null,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKeyCity,
                      child: TextFormField(
                        controller: cityController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'City',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Cannot be empty" : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Form(
                      key: formKeyState,
                      child: TextFormField(
                        controller: stateController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'State',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Cannot be empty" : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKeyCountry,
                      child: TextFormField(
                        controller: countryController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Country',
                        ),
                        validator: (value) =>
                            value!.isEmpty ? "Cannot be empty" : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Form(
                      key: formKeyPincode,
                      child: TextFormField(
                        controller: pincodeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          labelStyle: TextStyle(color: Colors.black),
                          labelText: 'Zip Code',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? "Cannot be empty" : null,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                    onTap: () async {
                      if (formKeyAddressLine.currentState!.validate() &&
                          formKeyCity.currentState!.validate() &&
                          formKeyCountry.currentState!.validate() &&
                          formKeyDonationAmount.currentState!.validate() &&
                          formKeyName.currentState!.validate() &&
                          formKeyPincode.currentState!.validate() &&
                          formKeyState.currentState!.validate()) {
                        await initPaymentSheet();
                        try {
                          await Stripe.instance.presentPaymentSheet();
                          handleSuccessfulPayment();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Payment Done",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ));

                          nameController.clear();
                          addressLineController.clear();
                          cityController.clear();
                          stateController.clear();
                          countryController.clear();
                          pincodeController.clear();
                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          print("payment sheet failed");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Payment Failed",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                          ));
                        }
                      }
                      // Implement the submission logic here
                    },
                    child: Button(
                      text: 'Donate!',
                      isLoading: isLoading,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
