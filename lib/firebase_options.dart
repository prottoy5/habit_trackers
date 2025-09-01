// GENERATED VIA `flutterfire configure`
// This file contains all Firebase configuration for your Flutter project.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const String apiKey = 'AIzaSyBu6y4LLfYTdkOk5vzMYY9gGXOK5-pr63U';

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: apiKey,
        authDomain: 'habit-tracker-4a123.firebaseapp.com',
        projectId: 'habit-tracker-4a123',
        storageBucket: 'habit-tracker-4a123.appspot.com',
        messagingSenderId: '316630727639',
        appId: '1:316630727639:web:YOUR_WEB_APP_HASH', // Replace with your actual Web App ID
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return FirebaseOptions(
        apiKey: apiKey,
        appId: '1:316630727639:android:9f738b7d2e78089a10a992',
        messagingSenderId: '316630727639',
        projectId: 'habit-tracker-4a123',
        storageBucket: 'habit-tracker-4a123.appspot.com',
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return FirebaseOptions(
        apiKey: apiKey,
        appId: '1:316630727639:ios:4c4edfbacd9e8d0510a992',
        messagingSenderId: '316630727639',
        projectId: 'habit-tracker-4a123',
        storageBucket: 'habit-tracker-4a123.appspot.com',
        iosBundleId: 'com.prottoy.habitzen.ios',
      );
    } else {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.',
      );
    }
  }
}
