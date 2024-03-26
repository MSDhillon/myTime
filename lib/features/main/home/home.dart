// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytime/constants/assets.dart';
import 'package:mytime/features/main/home/posts/new_post.dart';
import 'package:mytime/features/main/home/posts/widgets/post_ui.dart';
import 'package:mytime/features/main/messenger/messenger.dart';
import '../../../theme/colours.dart';

// Home widget
class Home extends StatelessWidget {
  const Home({super.key});

  // Method to open the messenger page
  void openMessenger(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Messenger()));
  }

  // Method to create a new post
  void createNewPost(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewPostPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(Assets.appLogo),
        // Displaying the app logo in the app bar leading section
        title: Text('myTime', style: Theme.of(context).textTheme.headlineSmall),
        // App title with custom text style
        actions: [
          IconButton(
            onPressed: () {
              openMessenger(
                  context); // Open messenger when the messenger icon is tapped
            },
            icon: const Icon(Icons.messenger_rounded), // Messenger icon
            color: Pallete.tertiaryColour, // Custom color for the icon
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewPost(
              context); // Create new post when the floating action button is pressed
        },
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        // Stream to listen for changes in the 'posts' collection
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(), // Display a loading indicator while data is loading
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(
              postData: snapshot.data!.docs[index]
                  .data(), // Pass post data to the PostCard widget
            ),
          );
        },
      ),
    );
  }
}
