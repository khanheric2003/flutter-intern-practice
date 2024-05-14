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
    apiKey: 'AIzaSyAiUCRoe34O6ttTAXFiw0TLT2xqeHsUZjw',
    appId: '1:1029381441351:web:8ed78380f3ce9dd6dc2e62',
    messagingSenderId: '1029381441351',
    projectId: 'intern-flutter-ae32d',
    authDomain: 'intern-flutter-ae32d.firebaseapp.com',
    storageBucket: 'intern-flutter-ae32d.appspot.com',
    measurementId: 'G-18T9MZ9SPF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwHUdCdumuD_qfv7RbFnZ6HqW1BRmaS0M',
    appId: '1:1029381441351:android:5e89b83e7ad7b8a2dc2e62',
    messagingSenderId: '1029381441351',
    projectId: 'intern-flutter-ae32d',
    storageBucket: 'intern-flutter-ae32d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBiWI0QjetOA_VqLq7zVjjHeb8V22DaDjk',
    appId: '1:1029381441351:ios:d75dc60146dc8b18dc2e62',
    messagingSenderId: '1029381441351',
    projectId: 'intern-flutter-ae32d',
    storageBucket: 'intern-flutter-ae32d.appspot.com',
    iosBundleId: 'com.example.taskManager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBiWI0QjetOA_VqLq7zVjjHeb8V22DaDjk',
    appId: '1:1029381441351:ios:d75dc60146dc8b18dc2e62',
    messagingSenderId: '1029381441351',
    projectId: 'intern-flutter-ae32d',
    storageBucket: 'intern-flutter-ae32d.appspot.com',
    iosBundleId: 'com.example.taskManager',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAiUCRoe34O6ttTAXFiw0TLT2xqeHsUZjw',
    appId: '1:1029381441351:web:e54050671a22f83fdc2e62',
    messagingSenderId: '1029381441351',
    projectId: 'intern-flutter-ae32d',
    authDomain: 'intern-flutter-ae32d.firebaseapp.com',
    storageBucket: 'intern-flutter-ae32d.appspot.com',
    measurementId: 'G-9LS8MW1S23',
  );
}
