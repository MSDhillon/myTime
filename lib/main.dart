import 'package:firebase_core/firebase_core.dart'; // Importing Firebase Core package for initializing Firebase services
import 'package:flutter/material.dart'; // Importing the Flutter Material package
import 'package:mytime/features/authentication/onboarding/onboarding.dart';
import 'package:mytime/theme/app_theme.dart'; // Importing the custom application theme

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensuring that Flutter bindings are initialized
  await Firebase.initializeApp(
      // Initializing Firebase services asynchronously
      options: const FirebaseOptions(
          // Providing Firebase configuration options
          apiKey: 'AIzaSyCPlRLJ-bLE67qauWvvWX1XG2TwqkzS0MM',
          // Firebase API key
          appId: '1:18165983971:android:ff2ea4b574014dcaec33d6',
          // Firebase app ID
          messagingSenderId: '18165983971',
          // Firebase messaging sender ID
          projectId: 'mytime-b1e38',
          // Firebase project ID
          storageBucket:
              'mytime-b1e38.appspot.com')); // Firebase storage bucket
  runApp(const MyApp()); // Running the Flutter application
}

// Defining the root application MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for MyApp

  // This method builds the UI of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Creating a MaterialApp widget
      title: 'myTime',
      // Setting the application title
      debugShowCheckedModeBanner: false,
      // Disabling the debug banner in release mode
      theme: AppTheme.lightTheme,
      // Setting the light theme defined in the app_theme.dart file
      darkTheme: AppTheme.darkTheme,
      // Setting the dark theme defined in the app_theme.dart file
      themeMode: ThemeMode.system,
      // Setting the theme mode to follow the system's theme preference
      home: const OnboardingPage(), // Setting the onboarding page as the home screen of the application
    );
  }
}
