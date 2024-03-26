import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart'; // Importing the Flutter Material package
import 'package:mytime/cloud_functions/authentication.dart'; // Importing authentication methods
import 'package:image_picker/image_picker.dart'; // Importing image picker package
import '../widgets/input_fields.dart'; // Importing custom input fields widget
import 'dart:typed_data'; // Importing typed_data library for handling byte data
import '../widgets/image_pick.dart'; // Importing custom image picker widget
import '../widgets/snackbar.dart'; // Importing custom snackbar widget
import 'package:mytime/features/authentication/login/login_page.dart'; // Importing the login page

// Defining a StatefulWidget called RegistrationPage
class RegistrationPage extends StatefulWidget {
  const RegistrationPage(
      {super.key}); // Constructor for RegistrationPage widget

  @override
  State<RegistrationPage> createState() =>
      _LoginPage(); // Creating state for RegistrationPage
}

// Defining the state for RegistrationPage
class _LoginPage extends State<RegistrationPage> {
  // Text editing controllers for various input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image; // Variable to hold the selected image

  @override
  void disposeController() {
    // Disposing text editing controllers when the state is disposed
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _infoController.dispose();
    _usernameController.dispose();
  }

  // Method to select an image from the gallery
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  // Method to navigate to the login page
  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  // Method to register the user
  void registerUser() async {
    String msg = await AuthenticationMethods().registerUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _infoController.text,
      profilePicture: _image!,
    );
    if (msg == 'User Added Successfully') {
      onceRegistered('User Registered');
    } else {
      showSnackBar(msg, context);
    }
  }

  // Method to handle actions once the user is registered
  void onceRegistered(String msg) {
    showSnackBar(msg, context);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    // Building the UI for RegistrationPage
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar image selection section
                const SizedBox(
                  height: 28,
                ),
                Stack(
                  children: [
                    // Displaying the selected image if available, otherwise showing a default image
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            // Setting the background image of the CircleAvatar with the selected image
                            backgroundImage: MemoryImage(_image!))
                        : const CircleAvatar(
                            radius: 64,
                            // Setting a default background image using NetworkImage
                            backgroundImage: NetworkImage(
                                'https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg'),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                // Username input field
                InputFields(
                  textEditingController: _usernameController,
                  textInputType: TextInputType.text,
                  hintText: 'Username',
                ),
                const SizedBox(
                  height: 28,
                ),
                // Email input field
                InputFields(
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 28,
                ),
                // Password input field
                InputFields(
                    textEditingController: _passwordController,
                    textInputType: TextInputType.text,
                    hintText: 'Password',
                    isPassword: true),
                const SizedBox(
                  height: 28,
                ),
                // Bio input field
                InputFields(
                  textEditingController: _infoController,
                  textInputType: TextInputType.text,
                  hintText: 'Bio',
                ),
                const SizedBox(
                  height: 32,
                ),
                // Register button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_usernameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _infoController.text.isEmpty) {
                          showSnackBar('Please fill all fields', context);
                          return;
                        }
                        if (_image == null) {
                          showSnackBar('Please upload an image', context);
                          return;
                        }
                        if (_usernameController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty &&
                            _infoController.text.isNotEmpty &&
                            _image != null) {
                          if (_passwordController.text.length < 6) {
                            showSnackBar(
                                'Password must be at least 6 characters long',
                                context);
                            return;
                          }
                          if (!EmailValidator.validate(_emailController.text)) {
                            showSnackBar(
                                'Please enter a valid email address', context);
                            return;
                          }
                          registerUser();
                        }
                      },
                      child: const Text('Register')),
                ),
                const SizedBox(
                  height: 32,
                ),
                // Row for already registered users to navigate to the login page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Already Have An Account?"),
                    ),
                    TextButton(
                      onPressed: navigateToLogin,
                      child: const Text("Log In"),
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
