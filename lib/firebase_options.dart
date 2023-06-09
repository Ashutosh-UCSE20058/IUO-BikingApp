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
    apiKey: 'AIzaSyBIpjqdSv5vWGaqlNnlaXT0PANqLh1Dq7s',
    appId: '1:983854894523:web:90c219495408b6953a889e',
    messagingSenderId: '983854894523',
    projectId: 'better-route-2',
    authDomain: 'better-route-2.firebaseapp.com',
    storageBucket: 'better-route-2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWuYc_AmHJ8Q4WHkgDwK0Hvaf6NeTu0qE',
    appId: '1:983854894523:android:3d0a01fe8bab2f1e3a889e',
    messagingSenderId: '983854894523',
    projectId: 'better-route-2',
    storageBucket: 'better-route-2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVDIegQjzGyShbuOgm4HrdDs26ZE8sGXk',
    appId: '1:983854894523:ios:5f36b5da5d3fe6d13a889e',
    messagingSenderId: '983854894523',
    projectId: 'better-route-2',
    storageBucket: 'better-route-2.appspot.com',
    iosClientId: '983854894523-rds6hc4bmq2p4bqd23rp4e42q562k707.apps.googleusercontent.com',
    iosBundleId: 'com.iuo.betterroute',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCVDIegQjzGyShbuOgm4HrdDs26ZE8sGXk',
    appId: '1:983854894523:ios:5f36b5da5d3fe6d13a889e',
    messagingSenderId: '983854894523',
    projectId: 'better-route-2',
    storageBucket: 'better-route-2.appspot.com',
    iosClientId: '983854894523-rds6hc4bmq2p4bqd23rp4e42q562k707.apps.googleusercontent.com',
    iosBundleId: 'com.iuo.betterroute',
  );
}
