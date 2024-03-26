import 'package:flutter/material.dart'; // Importing the Flutter Material package
import 'package:mytime/features/authentication/widgets/input_fields.dart'; // Importing custom input fields widget
import 'package:mytime/features/authentication/widgets/snackbar.dart'; // Importing custom snackbar widget
import 'package:mytime/cloud_functions/authentication.dart'; // Importing authentication methods
import 'package:mytime/constants/assets.dart'; // Importing custom assets
import 'package:mytime/features/main/home_page.dart'; // Importing the home page
import 'package:mytime/features/authentication/registration/registration_page.dart'; // Importing the registration page

// Defining a StatefulWidget called LoginPage
class LoginPage extends StatefulWidget {
  const LoginPage({super.key}); // Constructor for LoginPage widget

  @override
  State<LoginPage> createState() =>
      _LoginPage(); // Creating state for LoginPage
}

// Defining the state for LoginPage
class _LoginPage extends State<LoginPage> {
  // Text editing controllers for email and password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void disposeController() {
    // Disposing text editing controllers when the state is disposed
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  // Method to handle the login process
  void loginUser() async {
    String msg = await AuthenticationMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    // If login is successful, navigate to the Dashboard page
    if (msg == 'User Logged Successfully') {
      goToDashboard();
    } else {
      // If login fails, show a snackbar with the error message
      showSnackBar(msg, context);
    }
  }

  void goToDashboard() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dashboard()));
  }

  // Method to navigate to the registration page
  void navigatedToLogin() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const RegistrationPage()));
  }

  @override
  Widget build(BuildContext context) {
    // Building the UI for LoginPage
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Assets.appLogo),
                // Displaying the app logo image
                // Input field for email
                InputFields(
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 28,
                ),
                // Input field for password
                InputFields(
                    textEditingController: _passwordController,
                    textInputType: TextInputType.text,
                    hintText: 'Password',
                    isPassword: true),
                const SizedBox(
                  height: 32,
                ),
                // Log in button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if(_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                          showSnackBar('Please fill all fields', context);
                          return;
                        }
                        if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                          loginUser();
                        }
                      },
                      child: const Text(
                          'Log In') // Displaying 'Log In' text on the button
                      ),
                ),
                const SizedBox(
                  height: 32,
                ),
                // Row containing text and a button to navigate to the registration page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                          "Don't have an account?"), // Displaying text
                    ),
                    TextButton(
                      onPressed: navigatedToLogin,
                      child: const Text(
                          "Register"), // Displaying 'Register' button
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
