# Habit_Zen / Habit_Trackers App
This is a cross-platform Habit Tracker application built with Flutter. This Flutter app (Android, iOS, Web, Windows, macOS, Linux) to create, track, and manage daily habits, visualize progress, and stay motivated with quotes. Firebase for auth & sync. SharedPreferences for local preferences (theme + session).

## Project Demo
Click the link to watch a short demo video of the Habit Trackers app - 

## Features
**Login Screen**
The Login Screen of the Habit Tracker app, named HabitZen, provides a straightforward and clean interface for user authentication. It features standard `TextFormField`s for secure email and password input. This screen ensures a seamless and secure entry point, and upon successful authentication, it navigates the user to the main habit tracking interface.
<img width="1297" height="985" alt="Login" src="https://github.com/user-attachments/assets/f88ed9ce-36ba-4afa-8c3b-db590294378c" />

**Register Screen**
The registration screen in HabitZen provides a comprehensive form for new users to create an account. It includes validated fields for name, email, and password, as well as a dropdown for gender, and inputs for height and date of birth. The screen also features checkboxes for accepting terms and conditions and for the "Remember me" functionality, ensuring a complete and user-friendly registration process. 
<img width="1302" height="992" alt="Register" src="https://github.com/user-attachments/assets/8a976094-b164-4e19-a32f-e6d47fdcf3c6" />

**User data stored in Cloud Firestore**
The `users` collection in the Firestore Database stores individual user information, securely partitioned under unique user IDs. For each user, a document contains their `displayName`, `email`, `dob` (date of birth), `gender`, and `height`. It also includes a `lastUpdated` timestamp and a list of their `habits`, demonstrating how user data is structured and managed for the Habit Tracker application. 
<img width="1833" height="865" alt="Firestore_user" src="https://github.com/user-attachments/assets/40de8259-9025-44c1-ac65-976a555bfabe" />

**Create Habit Screen**
The Create Habit screen in HabitZen provides a simple and intuitive interface for defining new habits. Users can enter a title, select a category and frequency from a dropdown, and add optional notes. This screen simplifies the process of goal-setting, making it easy for users to quickly add new habits to their tracker and begin their progress journey. 
<img width="1302" height="983" alt="Create_Habit" src="https://github.com/user-attachments/assets/10ce11ff-5e6b-4832-abb8-df7c3d0894dc" />

**Habits List**
Habits List serves as the central hub for the app. It provides a clean, scrollable list of all your habits, categorized for easy organization. Each habit card displays the title, a brief description, and a streak counter to motivate you to keep going. It also features a `Mark Today` button to track daily completion, as well as `Edit` and `Delete` icons for managing your habits. The floating action button allows for quick habit creation. 
<img width="1302" height="986" alt="Habits_List" src="https://github.com/user-attachments/assets/f89f9039-bfa5-4709-964d-4d78368cba76" />

**Habits data stored in Cloud Firestore**
The `habits` collection in the Firestore Database stores the details for each habit created by the user. Each habit document is uniquely identified and contains fields like `category`, `completionHistory`, `currentStreak`, and `frequency`. This structure allows the app to accurately track the user's progress and streaks, providing real-time data to motivate and support their habit-building journey. 
<img width="1827" height="871" alt="Firestore_habit" src="https://github.com/user-attachments/assets/75fd2adc-1f66-474f-b1d8-f7ae6ca96f68" />

**Progress Screen**
The Progress screen provides users with a visual overview of their habit-building journey. The screen displays a detailed chart that tracks completion over the last 7 days, allowing users to easily monitor their consistency and identify patterns. This feature provides a clear, data-driven view of their progress, helping them stay motivated and committed to their goals. 
<img width="1298" height="987" alt="Progress" src="https://github.com/user-attachments/assets/0f951832-17b6-40df-bc88-5b6e7254679e" />

**Quotes List**
The Quotes List screen in HabitZen provides a source of daily inspiration and motivation. It displays a curated collection of quotes from well-known figures, each presented in a clean, readable format. Users can easily copy a quote to their clipboard or add it to their favorites list for quick access later, making it a valuable tool for staying positive and focused on their goals. 
<img width="1297" height="986" alt="Quotes_List" src="https://github.com/user-attachments/assets/4a350bc3-f4d0-4b38-aa5c-ea02c28eb947" />

**Favorites List**
The Favorites List screen in HabitZen provides a personalized collection of quotes that the user has selected. This feature allows users to save and revisit their most inspiring and motivational quotes. Each card displays the quote, its author, a `Copy` button, and the option to remove it from their favorites, providing a curated space for inspiration. 
<img width="1298" height="988" alt="Favorites_List" src="https://github.com/user-attachments/assets/a2b15076-7443-4b0b-83e3-8cb81d3aae13" />

**Favorites Quotes data stored in Cloud Firestore**
The `favorite_quotes` collection in the Firestore Database is specifically designed to store the quotes a user has saved. Each document within this collection contains a unique key and the corresponding quote ID, allowing the app to efficiently retrieve and display a user's curated list of favorite quotes. This structure ensures that users can easily access their most meaningful and motivational quotes across all their devices. 
<img width="1820" height="875" alt="Firestore_Favorites_quotes" src="https://github.com/user-attachments/assets/05442c26-1cdd-40a0-ad2b-cffafaaee2d2" />

**Profile Screen**
The Profile screen in HabitZen allows users to manage and update their personal information. This screen displays a user's name, email, gender, height, and date of birth, all of which can be edited. It also provides a secure field to create a new password and a "Save" button to apply changes, giving users full control over their account details. 
<img width="1302" height="990" alt="Profile" src="https://github.com/user-attachments/assets/5d16b87f-f680-44f0-9b96-f73d9d4832ea" />

**Refresh Button**
The Refresh feature, as shown in the Quotes screen, is a crucial part of the app's user experience. It provides a skeleton loading state while the content is being fetched, ensuring a smooth and responsive feel. This prevents the user from seeing a blank screen and provides a clear visual cue that the app is actively working to update the content, such as new motivational quotes or updated habit data. 
<img width="1301" height="986" alt="Refresh" src="https://github.com/user-attachments/assets/a9b6ba70-d552-4c73-b9dd-1696644063b3" />

**Dark Mode**
The Dark Mode feature of the Habit Tracker app offers a visually comfortable and accessible experience, especially in low-light conditions. As seen on the Habits List screen, the dark color scheme reduces eye strain and conserves battery life. This feature is seamlessly integrated throughout the app, including the main list, navigation bar, and individual habit cards, ensuring a consistent user experience. 
<img width="1305" height="988" alt="Dark_Mode" src="https://github.com/user-attachments/assets/8ac69688-def1-4fcb-89eb-355a9ec55532" />


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
