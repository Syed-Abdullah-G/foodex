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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD7QPxNdjBVXiJcVbY0_NeX2WeK7_yCA6I',
    appId: '1:1049496760089:android:581854cab62b20e1261f88',
    messagingSenderId: '1049496760089',
    projectId: 'food-f88e3',
    storageBucket: 'food-f88e3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9Zmx0bvz_2oXkghpo15G-JNaruoOE0Oc',
    appId: '1:1049496760089:ios:729227543412ba17261f88',
    messagingSenderId: '1049496760089',
    projectId: 'food-f88e3',
    storageBucket: 'food-f88e3.appspot.com',
    androidClientId: '1049496760089-jcnkpedhmsi38rdt15im7vc2jrhue29q.apps.googleusercontent.com',
    iosClientId: '1049496760089-dd56tn189f4600gjh0l8ulkbquebbae1.apps.googleusercontent.com',
    iosBundleId: 'com.example.foodex',
  );

}