// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat/chat_page.dart';

// Messenger widget, which is a StatefulWidget
class Messenger extends StatefulWidget {
  const Messenger({super.key}); // Constructor for Messenger widget

  @override
  State<Messenger> createState() =>
      _MessengerState(); // Creating state for Messenger widget
}

// State class for Messenger widget
class _MessengerState extends State<Messenger> {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Instance of FirebaseAuth for user authentication

  // Method to navigate back to the previous screen
  void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            goBack(
                context); // Call goBack method when the close icon button is pressed
          },
          icon: const Icon(
              Icons.close_rounded), // Display close icon button in the app bar
        ),
        title: Text('Messenger',
            style: Theme.of(context)
                .textTheme
                .headlineSmall), // Display title in the app bar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        // Stream of user data from Firestore
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Text(
                'error'); // Display error message if there's an error in the stream
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            const Text(
                'loading'); // Display loading message while waiting for data
          }
          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) {
              Map<String, dynamic> data = doc.data()!
                  as Map<String, dynamic>; // Extract user data from document

              if (_auth.currentUser!.displayName != data['username']) {
                // Check if current user is not the same as the user in the list
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data[
                        'profilePictureURL']), // Display user's profile picture
                  ),
                  title: Text(
                    data['username'], // Display user's username
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge, // Set text style for username
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  // Navigate to ChatPage when user is tapped
                                  // Pass username and uid to ChatPage
                                  username: data['username'],
                                  uid: data['userID'],
                                )));
                  },
                );
              } else {
                return Container(); // If current user matches the user in the list, return an empty container
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
