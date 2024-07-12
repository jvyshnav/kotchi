// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCHedQni1ZdhcZ_l1nFZ4vMDKXs_aCTKYI',
    appId: '1:44325585811:web:d8aa8c2821dbc5d256de66',
    messagingSenderId: '44325585811',
    projectId: 'kotchi-6ae82',
    authDomain: 'kotchi-6ae82.firebaseapp.com',
    storageBucket: 'kotchi-6ae82.appspot.com',
    measurementId: 'G-TY38PB605Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDyq9LSQbAHb029hvTqkKAYkrYWtS1JGWE',
    appId: '1:44325585811:android:d7f55a606feef05556de66',
    messagingSenderId: '44325585811',
    projectId: 'kotchi-6ae82',
    storageBucket: 'kotchi-6ae82.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFNMx8yvW70qUnMJUHemP4koX0JLM8lWQ',
    appId: '1:44325585811:ios:e9689be22d05ec6f56de66',
    messagingSenderId: '44325585811',
    projectId: 'kotchi-6ae82',
    storageBucket: 'kotchi-6ae82.appspot.com',
    iosBundleId: 'com.example.kotchi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFNMx8yvW70qUnMJUHemP4koX0JLM8lWQ',
    appId: '1:44325585811:ios:e9689be22d05ec6f56de66',
    messagingSenderId: '44325585811',
    projectId: 'kotchi-6ae82',
    storageBucket: 'kotchi-6ae82.appspot.com',
    iosBundleId: 'com.example.kotchi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCHedQni1ZdhcZ_l1nFZ4vMDKXs_aCTKYI',
    appId: '1:44325585811:web:59b939eab9b7538356de66',
    messagingSenderId: '44325585811',
    projectId: 'kotchi-6ae82',
    authDomain: 'kotchi-6ae82.firebaseapp.com',
    storageBucket: 'kotchi-6ae82.appspot.com',
    measurementId: 'G-09Y4YDEGBR',
  );
}
