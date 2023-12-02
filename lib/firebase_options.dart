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
    apiKey: 'AIzaSyCrg_cAiVVwB8eRHsrTi6l6Csuxe-_wvjw',
    appId: '1:663990303984:web:6961695a09badb0edb9635',
    messagingSenderId: '663990303984',
    projectId: 'tiffsy-805bb',
    authDomain: 'tiffsy-805bb.firebaseapp.com',
    storageBucket: 'tiffsy-805bb.appspot.com',
    measurementId: 'G-JLZ3C76RQC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9DhjhCSsH1ZSHyHiIgPPJfWkoYep-0XY',
    appId: '1:663990303984:android:4cdddf7712d23d6bdb9635',
    messagingSenderId: '663990303984',
    projectId: 'tiffsy-805bb',
    storageBucket: 'tiffsy-805bb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBeHl0wDrSzTCUfMWQKfp8wJY0KwuCDhQ',
    appId: '1:663990303984:ios:79c042b2f53ee5bedb9635',
    messagingSenderId: '663990303984',
    projectId: 'tiffsy-805bb',
    storageBucket: 'tiffsy-805bb.appspot.com',
    iosBundleId: 'com.example.tiffsyApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCBeHl0wDrSzTCUfMWQKfp8wJY0KwuCDhQ',
    appId: '1:663990303984:ios:9c36e9d1525392dfdb9635',
    messagingSenderId: '663990303984',
    projectId: 'tiffsy-805bb',
    storageBucket: 'tiffsy-805bb.appspot.com',
    iosBundleId: 'com.example.tiffsyApp.RunnerTests',
  );
}
