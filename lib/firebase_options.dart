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
    apiKey: 'AIzaSyB0Szdn613j70HU5r_s6Fc3-ArYKSHW7dw',
    appId: '1:30184954202:web:2ca18d285d29b3532efb63',
    messagingSenderId: '30184954202',
    projectId: 'salon-management-ee7b0',
    authDomain: 'salon-management-ee7b0.firebaseapp.com',
    storageBucket: 'salon-management-ee7b0.appspot.com',
    measurementId: 'G-ZD08VZH0YN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjNAWti_HpjvdXQ1OivDUlf7KnLSAK_Tk',
    appId: '1:30184954202:android:31225edf8f98ed3c2efb63',
    messagingSenderId: '30184954202',
    projectId: 'salon-management-ee7b0',
    storageBucket: 'salon-management-ee7b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcbnJ7a2WDTayQXRV4pH-NiBbNicAcKRI',
    appId: '1:30184954202:ios:bde7b6e2d82774a12efb63',
    messagingSenderId: '30184954202',
    projectId: 'salon-management-ee7b0',
    storageBucket: 'salon-management-ee7b0.appspot.com',
    iosBundleId: 'com.example.saloon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcbnJ7a2WDTayQXRV4pH-NiBbNicAcKRI',
    appId: '1:30184954202:ios:513254d1079bcb012efb63',
    messagingSenderId: '30184954202',
    projectId: 'salon-management-ee7b0',
    storageBucket: 'salon-management-ee7b0.appspot.com',
    iosBundleId: 'com.example.saloon.RunnerTests',
  );
}
