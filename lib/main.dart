import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:pawsitive1/Controllers/getxControllers/hideIconController.dart';
import 'package:pawsitive1/Controllers/getxControllers/iconColorController.dart';
import 'package:pawsitive1/Controllers/getxControllers/loginButtonController.dart';
import 'package:pawsitive1/Controllers/getxControllers/signupFieldController.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/signupPage.dart';
import 'package:pawsitive1/Pages/AuthenticationPages/WelcomeScreen.dart';
import 'package:pawsitive1/Widgets/BottomNav.dart';
import 'package:pawsitive1/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Stripe.publishableKey = dotenv.env["STRIPE_PUBLISH_KEY"]!;
  Stripe.merchantIdentifier = "Test Merchant";
  await Stripe.instance.applySettings();
  await ScreenUtil.ensureScreenSize();
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
          useMaterial3: true,
        ),
        home: BottomNav());
  }
}
