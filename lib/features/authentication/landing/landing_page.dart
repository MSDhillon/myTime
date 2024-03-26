import 'package:flutter/material.dart'; // Importing the Flutter Material package
import 'package:mytime/constants/assets.dart'; // Importing custom assets
import 'package:mytime/features/authentication/login/login_page.dart'; // Importing the login page
import 'package:mytime/features/authentication/registration/registration_page.dart'; // Importing the registration page

// Defining a StatefulWidget called LandingPage
class LandingPage extends StatefulWidget {
  const LandingPage({super.key}); // Constructor for LandingPage widget

  @override
  State<LandingPage> createState() =>
      _LandingPage(); // Creating state for LandingPage
}

// Defining the state for LandingPage
class _LandingPage extends State<LandingPage> {
  // Navigates to the Login screen
  void goToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  // Navigates to the Registration screen
  void goToRegistration() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const RegistrationPage()));
  }

  @override
  Widget build(BuildContext context) {
    // Building the UI for LandingPage
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0), // Adds padding around the content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // Distributes children evenly
          children: [
            Image(
              image: const AssetImage(Assets.landingImage),
              // Displaying an image
              height: MediaQuery.of(context).size.height *
                  0.85, // Image takes up most of screen
            ),
            Row(
              children: [
                Expanded(
                  // Login button expands to take available space
                  child: OutlinedButton(
                      onPressed: goToLogin,
                      child: const Text(
                          'Login') // Displaying 'Login' text on the button
                      ),
                ),
                const SizedBox(
                  width: 10, // Adds a space between buttons
                ),
                Expanded(
                  // Register button expands to take available space
                  child: ElevatedButton(
                    onPressed: goToRegistration,
                    child: const Text(
                        'Register'), // Displaying 'Register' text on the button
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
