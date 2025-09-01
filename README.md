# HabitZen

A Flutter app (Android, iOS, Web, Windows, macOS, Linux) to create, track, and manage daily habits, visualize progress, and stay motivated with quotes. 
Firebase for auth & sync. SharedPreferences for local preferences (theme + session).

## Quick Start

1) **Install Flutter (stable)** and enable desktop/web platforms:
```bash
flutter config --enable-web
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop
```

2) **Add Firebase to all platforms** with FlutterFire (replace your bundle ids as needed):
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=<your-firebase-project-id>
```
This generates `lib/firebase_options.dart` and platform configs. The project already references it. 

3) **Firestore rules (development)** (loosen as needed only for testing):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /habits/{habitId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      match /favorites/quotes/{quoteId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

4) **Run**:
```bash
flutter pub get
flutter run -d chrome   # or any device
```

## Notes
- Quotes fetched from https://api.quotable.io or https://zenquotes.io. You can switch in `QuotesService`.
- Offline: Firestore persistence enabled (web uses multi-tab persistence if available). 
- Category list is predefined; edit in `models/habit.dart` if you want more.
