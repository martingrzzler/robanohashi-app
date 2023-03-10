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
    apiKey: 'AIzaSyCtmXA0jJeAD_kfnLXn4A0ULhAvOds6Z8I',
    appId: '1:1051987053339:web:9bfb8777b40b8d5294a1be',
    messagingSenderId: '1051987053339',
    projectId: 'robanohashi',
    authDomain: 'robanohashi.firebaseapp.com',
    storageBucket: 'robanohashi.appspot.com',
    measurementId: 'G-JGLFSDY474',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCTzP5uNtbn8awFUM-BcuhH7hccvdwuuUY',
    appId: '1:1051987053339:android:94c7a926595d605894a1be',
    messagingSenderId: '1051987053339',
    projectId: 'robanohashi',
    storageBucket: 'robanohashi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCvhakmUkBpUUk_lC9qutWT-1LSwi0DnxQ',
    appId: '1:1051987053339:ios:3095ead23580d00894a1be',
    messagingSenderId: '1051987053339',
    projectId: 'robanohashi',
    storageBucket: 'robanohashi.appspot.com',
    androidClientId: '1051987053339-v4gpot9mbndvfp3qvm6kmsbn185agm9c.apps.googleusercontent.com',
    iosClientId: '1051987053339-nl7g9jlljb5bi0c0jmrq4bigi21h40c3.apps.googleusercontent.com',
    iosBundleId: 'com.example.robanohashi',
  );
}
