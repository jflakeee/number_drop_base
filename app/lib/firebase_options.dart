// Firebase configuration for Number Drop Clone
// Generated from Firebase Console

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyBt7LfofX6huMtQ3oYXIzPKzfM8Jb3wbaI',
    appId: '1:300353188801:web:224b594c588976fb06f540',
    messagingSenderId: '300353188801',
    projectId: 'number-drop-7145d',
    authDomain: 'number-drop-7145d.firebaseapp.com',
    storageBucket: 'number-drop-7145d.firebasestorage.app',
    measurementId: 'G-DPE95RRHWN',
    databaseURL: 'https://number-drop-7145d-default-rtdb.firebaseio.com',
  );

  // Android configuration (add from Firebase Console if needed)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBt7LfofX6huMtQ3oYXIzPKzfM8Jb3wbaI',
    appId: '1:300353188801:web:224b594c588976fb06f540',
    messagingSenderId: '300353188801',
    projectId: 'number-drop-7145d',
    storageBucket: 'number-drop-7145d.firebasestorage.app',
    databaseURL: 'https://number-drop-7145d-default-rtdb.firebaseio.com',
  );

  // iOS configuration (add from Firebase Console if needed)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBt7LfofX6huMtQ3oYXIzPKzfM8Jb3wbaI',
    appId: '1:300353188801:web:224b594c588976fb06f540',
    messagingSenderId: '300353188801',
    projectId: 'number-drop-7145d',
    storageBucket: 'number-drop-7145d.firebasestorage.app',
    databaseURL: 'https://number-drop-7145d-default-rtdb.firebaseio.com',
    iosBundleId: 'com.example.numberDropClone',
  );

  // macOS configuration
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBt7LfofX6huMtQ3oYXIzPKzfM8Jb3wbaI',
    appId: '1:300353188801:web:224b594c588976fb06f540',
    messagingSenderId: '300353188801',
    projectId: 'number-drop-7145d',
    storageBucket: 'number-drop-7145d.firebasestorage.app',
    databaseURL: 'https://number-drop-7145d-default-rtdb.firebaseio.com',
    iosBundleId: 'com.example.numberDropClone',
  );

  // Windows configuration
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBt7LfofX6huMtQ3oYXIzPKzfM8Jb3wbaI',
    appId: '1:300353188801:web:224b594c588976fb06f540',
    messagingSenderId: '300353188801',
    projectId: 'number-drop-7145d',
    storageBucket: 'number-drop-7145d.firebasestorage.app',
    databaseURL: 'https://number-drop-7145d-default-rtdb.firebaseio.com',
  );
}
