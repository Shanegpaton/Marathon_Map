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
    apiKey: 'AIzaSyB__6ereeAGrTje_wIGre7alPf4AGKMj3k',
    appId: '1:181271702282:web:05d63b171e0f29c076e8f3',
    messagingSenderId: '181271702282',
    projectId: 'marathon-map-acf60',
    authDomain: 'marathon-map-acf60.firebaseapp.com',
    storageBucket: 'marathon-map-acf60.firebasestorage.app',
    measurementId: 'G-X31D89NWF8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSjvNRlCF-L0xJpTxzEUr96VJkqOjL9gM',
    appId: '1:181271702282:android:e274d289705a002976e8f3',
    messagingSenderId: '181271702282',
    projectId: 'marathon-map-acf60',
    storageBucket: 'marathon-map-acf60.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDU646a35HrDefOfmbWHvgleoUDUG_e0P8',
    appId: '1:181271702282:ios:f75046eb519f795a76e8f3',
    messagingSenderId: '181271702282',
    projectId: 'marathon-map-acf60',
    storageBucket: 'marathon-map-acf60.firebasestorage.app',
    iosBundleId: 'com.example.marthonMap',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDU646a35HrDefOfmbWHvgleoUDUG_e0P8',
    appId: '1:181271702282:ios:f75046eb519f795a76e8f3',
    messagingSenderId: '181271702282',
    projectId: 'marathon-map-acf60',
    storageBucket: 'marathon-map-acf60.firebasestorage.app',
    iosBundleId: 'com.example.marthonMap',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB__6ereeAGrTje_wIGre7alPf4AGKMj3k',
    appId: '1:181271702282:web:1111aa38ce859d8e76e8f3',
    messagingSenderId: '181271702282',
    projectId: 'marathon-map-acf60',
    authDomain: 'marathon-map-acf60.firebaseapp.com',
    storageBucket: 'marathon-map-acf60.firebasestorage.app',
    measurementId: 'G-0TT731G6TN',
  );
}
