# Giggle & Grow 🌱

A Flutter mobile app for young children that makes learning fun through lessons, games, stories and drawing. Built as a Mobile Application Development course project.

## Features

- **Authentication:** sign up, login and password reset (Firebase Auth)
- **Onboarding:** splash screen and a short intro walkthrough
- **Learning:** alphabet, numbers, animal sounds and shapes, with audio
- **Games:** memory match, color match and sun puzzle
- **Stories:** illustrated stories (The Brave Little Fox, A Day at the Beach, The Star's Best Friend, The Silly Rainbow)
- **Drawing:** a canvas to draw and save artwork (Cloud Firestore)
- **Rewards:** points and score tracking on the home dashboard 

## Tech Stack

- Flutter / Dart
- Firebase Authentication and Cloud Firestore
- Provider (state management)
- audioplayers, flutter_svg, dotted_border

## Project Structure

Feature-based, with a clean-architecture layout (presentation / domain / data):

```
lib/
├── core/          # constants, colors, utils
├── features/
│   ├── authentication/
│   ├── onboarding/
│   ├── dashboard/
│   ├── learning/
│   ├── games/
│   ├── drawing/
│   └── stories/
├── widgets/       # shared widgets (bottom navbar)
└── main.dart
```

## Getting Started

**Prerequisites:** Flutter SDK (Dart ^3.10.7), Android Studio, an emulator or Android device.

```bash
git clone https://github.com/YOURUSER/giggle-and-grow.git
cd giggle-and-grow
flutter pub get
flutter run
```

**Firebase:** the app uses Firebase Auth and Firestore. To use your own project, run `flutterfire configure` and enable Email/Password sign-in in the Firebase console.

 
