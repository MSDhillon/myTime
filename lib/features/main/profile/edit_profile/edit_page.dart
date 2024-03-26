import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Importing the Flutter Material package
import 'package:mytime/cloud_functions/authentication.dart'; // Importing authentication methods
import 'package:image_picker/image_picker.dart'; // Importing image picker package
import 'dart:typed_data'; // Importing typed_data library for handling byte data
import '../../../authentication/widgets/image_pick.dart';
import '../../../authentication/widgets/input_fields.dart';
import '../../../authentication/widgets/snackbar.dart'; // Importing the login page

// Defining a StatefulWidget called RegistrationPage
class EditPage extends StatefulWidget {
  const EditPage({super.key}); // Constructor for RegistrationPage widget

  @override
  State<EditPage> createState() =>
      _EditPage(); // Creating state for RegistrationPage
}

// Defining the state for RegistrationPage
class _EditPage extends State<EditPage> {
  // Text editing controllers for various input fields
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image; // Variable to hold the selected image
  late String imagePlaceholder = '';

  @override
  void initState() {
    super.initState();
    getUserDetails(); // Get user details
  }

  @override
  void disposeController() {
    // Disposing text editing controllers when the state is disposed
    super.dispose();
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
  void navigateBack() {
    Navigator.of(context).pop();
  }

  void getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

    setState(() {
      _infoController.text = userData['bio']; // Set user ID
      _usernameController.text = userData['username']; // Set username
      imagePlaceholder = userData['profilePictureURL']; // Set user picture
    });
  }

  // Method to register the user
  void updateUser() async {
    String msg = await AuthenticationMethods().updateUser(
      profilePicture: _image!,
      bio: _infoController.text,
      username: _usernameController.text,
    );
    if (msg == 'User updated successfully') {
      showSnackBar(msg, context);
      navigateBack();
    } else {
      showSnackBar(msg, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Building the UI for RegistrationPage
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              navigateBack();
            },
            icon: const Icon(Icons.close_rounded)),
        title: Text('Edit Profile', style: Theme.of(context).textTheme.headlineSmall),
      ),
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
                        : CircleAvatar(
                            radius: 64,
                            // Setting a default background image using NetworkImage
                            backgroundImage: NetworkImage(imagePlaceholder),
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
                        updateUser();
                      },
                      child: const Text('Save Changes')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
