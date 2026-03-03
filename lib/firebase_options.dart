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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAzKecQBA4AeuN5Nn7Pn7es6tsOdWOO0f8',
    appId: '1:945477783265:web:a92af3855435755f1fb1a0',
    messagingSenderId: '945477783265',
    projectId: 'acacia-ceramics',
    authDomain: 'acacia-ceramics.firebaseapp.com',
    storageBucket: 'acacia-ceramics.firebasestorage.app',
    measurementId: 'G-FJ1QX2VEQM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAzKecQBA4AeuN5Nn7Pn7es6tsOdWOO0f8',
    appId: '1:945477783265:web:a92af3855435755f1fb1a0',
    messagingSenderId: '945477783265',
    projectId: 'acacia-ceramics',
    storageBucket: 'acacia-ceramics.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAzKecQBA4AeuN5Nn7Pn7es6tsOdWOO0f8',
    appId: '1:945477783265:web:a92af3855435755f1fb1a0',
    messagingSenderId: '945477783265',
    projectId: 'acacia-ceramics',
    storageBucket: 'acacia-ceramics.firebasestorage.app',
    iosBundleId: 'com.acacia.ceramics',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAzKecQBA4AeuN5Nn7Pn7es6tsOdWOO0f8',
    appId: '1:945477783265:web:a92af3855435755f1fb1a0',
    messagingSenderId: '945477783265',
    projectId: 'acacia-ceramics',
    storageBucket: 'acacia-ceramics.firebasestorage.app',
    iosBundleId: 'com.acacia.ceramics',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAzKecQBA4AeuN5Nn7Pn7es6tsOdWOO0f8',
    appId: '1:945477783265:web:a92af3855435755f1fb1a0',
    messagingSenderId: '945477783265',
    projectId: 'acacia-ceramics',
    storageBucket: 'acacia-ceramics.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyAzKecQBA4AeuN5Nn7Pn7es6tsOdWOO0f8',
    appId: '1:945477783265:web:a92af3855435755f1fb1a0',
    messagingSenderId: '945477783265',
    projectId: 'acacia-ceramics',
    storageBucket: 'acacia-ceramics.firebasestorage.app',
  );
}
