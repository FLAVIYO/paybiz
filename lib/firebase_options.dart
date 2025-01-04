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
    apiKey: 'ANDROID_API_KEY_PLACEHOLDER',
    appId: 'ANDROID_APP_ID_PLACEHOLDER',
    messagingSenderId: 'ANDROID_MESSAGING_SENDER_ID_PLACEHOLDER',
    projectId: 'ANDROID_PROJECT_ID_PLACEHOLDER',
    storageBucket: 'ANDROID_STORAGE_BUCKET_PLACEHOLDER',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'IOS_API_KEY_PLACEHOLDER',
    appId: 'IOS_APP_ID_PLACEHOLDER',
    messagingSenderId: 'IOS_MESSAGING_SENDER_ID_PLACEHOLDER',
    projectId: 'IOS_PROJECT_ID_PLACEHOLDER',
    storageBucket: 'IOS_STORAGE_BUCKET_PLACEHOLDER',
    iosBundleId: 'IOS_BUNDLE_ID_PLACEHOLDER',
  );
}
