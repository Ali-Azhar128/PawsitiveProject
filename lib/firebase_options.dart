// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZ0VZXf1ExAjllr_E14O-dwb-Ka96xluQ',
    appId: '1:630811212273:web:b1d162fd9ab3f36f8eac50',
    messagingSenderId: '630811212273',
    projectId: 'pawsitive1',
    authDomain: 'pawsitive1.firebaseapp.com',
    storageBucket: 'pawsitive1.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNnX8IONraQsY7M57JxzydUGzCYCHfxxc',
    appId: '1:630811212273:android:0afe88eb108c2bc38eac50',
    messagingSenderId: '630811212273',
    projectId: 'pawsitive1',
    storageBucket: 'pawsitive1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZCXABLPeGMrWPP1TVa7yY3-u-GRCY2i4',
    appId: '1:630811212273:ios:7bb25267626f3fd08eac50',
    messagingSenderId: '630811212273',
    projectId: 'pawsitive1',
    storageBucket: 'pawsitive1.appspot.com',
    iosBundleId: 'com.example.pawsitive1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZCXABLPeGMrWPP1TVa7yY3-u-GRCY2i4',
    appId: '1:630811212273:ios:c27fae3fa78996da8eac50',
    messagingSenderId: '630811212273',
    projectId: 'pawsitive1',
    storageBucket: 'pawsitive1.appspot.com',
    iosBundleId: 'com.example.pawsitive1.RunnerTests',
  );
}