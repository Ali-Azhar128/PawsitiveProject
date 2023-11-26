import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pawsitive1/Controllers/getxControllers/hideIconController.dart';
import 'package:pawsitive1/Controllers/getxControllers/iconColorController.dart';
import 'package:pawsitive1/Controllers/getxControllers/loginButtonController.dart';
import 'package:pawsitive1/Controllers/getxControllers/signupFieldController.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/signupPage.dart';
import 'package:pawsitive1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final signupFieldController inputFieldController =
        Get.put(signupFieldController());
    final IconColorController iconColorController =
        Get.put(IconColorController());
    final HideIconController hideIconController = Get.put(HideIconController());
    final loginButtonController loginController =
        Get.put(loginButtonController());

    return GetMaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: signupPage());
  }
}
