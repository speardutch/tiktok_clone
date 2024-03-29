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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBQiBCuje2f4-cptHnR0TQg4gsRB2j0-pM',
    appId: '1:893998821323:web:10e2fbbc0ddb8f6c89904e',
    messagingSenderId: '893998821323',
    projectId: 'speardutch-titok-clone',
    authDomain: 'speardutch-titok-clone.firebaseapp.com',
    storageBucket: 'speardutch-titok-clone.appspot.com',
    measurementId: 'G-PBCEDDMZT7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDf7oxs1AbvJpn3ogXrbuhf0hp7AlCzx20',
    appId: '1:893998821323:android:2299bb7c8cb1485b89904e',
    messagingSenderId: '893998821323',
    projectId: 'speardutch-titok-clone',
    storageBucket: 'speardutch-titok-clone.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA79tPI_rN7tyzbjUgVhijNQnAXf-8RLG4',
    appId: '1:893998821323:ios:6675ba121ce4e83f89904e',
    messagingSenderId: '893998821323',
    projectId: 'speardutch-titok-clone',
    storageBucket: 'speardutch-titok-clone.appspot.com',
    iosBundleId: 'com.example.tiktokClone',
  );
}
