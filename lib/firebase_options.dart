// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return desktop;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDpFn9FO7wd4QKjt6K-5mpBRlU4BZ0grJg',
    authDomain: 'financas-start-3178a.firebaseapp.com',
    projectId: 'financas-start-3178a',
    storageBucket: 'financas-start-3178a.firebasestorage.app',
    messagingSenderId: '384943250407',
    appId: '1:384943250407:web:00000000000000000000000',
    measurementId: 'G-XXXXXXXXXX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpFn9FO7wd4QKjt6K-5mpBRlU4BZ0grJg',
    appId: '1:384943250407:android:809bb3e5ff8442850f3b42',
    messagingSenderId: '384943250407',
    projectId: 'financas-start-3178a',
    storageBucket: 'financas-start-3178a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpFn9FO7wd4QKjt6K-5mpBRlU4BZ0grJg',
    appId: '1:384943250407:ios:000000000000000000000000',
    messagingSenderId: '384943250407',
    projectId: 'financas-start-3178a',
    storageBucket: 'financas-start-3178a.firebasestorage.app',
    iosClientId: '000000000000-xxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com',
    iosBundleId: 'com.app.financas',
  );

  static const FirebaseOptions desktop = FirebaseOptions(
    apiKey: 'AIzaSyDpFn9FO7wd4QKjt6K-5mpBRlU4BZ0grJg',
    appId: '1:384943250407:desktop:00000000000000000000000',
    messagingSenderId: '384943250407',
    projectId: 'financas-start-3178a',
    storageBucket: 'financas-start-3178a.firebasestorage.app',
  );
}
