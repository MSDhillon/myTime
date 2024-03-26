// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytime/cloud_functions/database.dart';
import 'dart:typed_data';
import 'package:mytime/features/authentication/widgets/image_pick.dart';
import 'package:mytime/features/authentication/widgets/snackbar.dart';

// NewPostPage widget
class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  String username = '';  // Variable to store the username
  String photoURL = '';  // Variable to store the profile picture URL
  String uid = '';  // Variable to store the user ID
  Uint8List? _image;  // Variable to store the selected image
  final TextEditingController _postController = TextEditingController();  // Controller for the post text field

  @override
  void initState() {
    super.initState();
    getUserDetails(); // Fetch user details when the widget initialises
  }

  // Method to fetch user details from Firestore
  void getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      // Set user details from the snapshot
      username = (snapshot.data() as Map<String, dynamic>)['username'];
      print(username);
      photoURL =
          (snapshot.data() as Map<String, dynamic>)['profilePictureURL'];
      uid = (snapshot.data() as Map<String, dynamic>)['userID'];
    });
  }

  // Method to navigate back to the previous screen
  void goBack() {
    Navigator.of(context).pop();
  }

  // Method to select an image from the gallery
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });
  }

  // Method to publish the post
  void publishPost(
    String uid,
    String username,
    String profileImage,
  ) async {
    try {
      // Upload post to Firestore using Database class method
      String msg = await Database().uploadPost(
          _postController.text, _image!, uid, username, profileImage);
      if (msg == 'Post uploaded successfully') {
        showSnackBar('Posted', context); // Show success message in a snackbar
        Navigator.of(context).pop(); // Close the current screen
      } else {
        showSnackBar(msg, context); // Show error message in a snackbar
      }
    } catch (error) {
      showSnackBar(error.toString(), context); // Show error message in a snackbar
    }
  }

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.close),
        ),
        title: Text('New Post', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          ElevatedButton(
            onPressed: () => publishPost(uid, username, photoURL), // Call publishPost method
            child: const Text('Post'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(photoURL),
                    radius: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: _postController,
                      decoration: const InputDecoration(
                        hintText: 'Write your post...',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(children: [
                  _image != null
                      ? Image(image: MemoryImage(_image!))
                      : Container(),
                ]),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: selectImage, // Call selectImage method
              icon: const Icon(
                Icons.add_photo_alternate_rounded,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}
