// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytime/cloud_functions/database.dart';
import 'package:mytime/features/main/home/posts/comments/widgets/comments_ui.dart';

class CommentsPage extends StatefulWidget {
  final snapshot;  // Holds data related to the post for which comments are being displayed

  const CommentsPage({super.key, required this.snapshot});

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  String currentUid = '';
  String currentUsername = '';
  String currentProfPic = '';
  final TextEditingController _commentsController = TextEditingController();  // Controller for the comment input field

  @override
  void initState() {
    super.initState();
    getUserDetails(); // Get user details
  }

  @override
  void dispose() {
    super.dispose();
    _commentsController.dispose();  // Release resources when the widget is disposed
  }

  // Method to navigate back to the previous screen
  void _goBack() {
    Navigator.of(context).pop();
  }

  void getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      currentUid = (snapshot.data() as Map<String, dynamic>)['userID']; // Set user ID
      currentUsername = (snapshot.data() as Map<String, dynamic>)['username']; // Set user ID
      currentProfPic = (snapshot.data() as Map<String, dynamic>)['profilePictureURL']; // Set user ID
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: _goBack, icon: const Icon(Icons.close_rounded) // Close button
        ),
        title:
            Text('Comments', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: StreamBuilder(  // Fetches comments in real-time
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snapshot['postID'])
            .collection('comments')
            .orderBy('publicationDate', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),  // Loading indicator
            );
          }
          // Display the list of comments
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                  CommentCard(commentData: snapshot.data!.docs[index].data()));
        },
      ),
      bottomNavigationBar: SafeArea(  //  Bottom area for comment input
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16.0, right: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentsController,
                  decoration: const InputDecoration(
                    hintText: 'Leave a comment',
                    border: InputBorder.none,
                  ),
                ),
              ),
              // Button to submit a new comment
              ElevatedButton(
                onPressed: () async {
                  // Upload the new comment to Firestore
                  await Database().uploadComment(
                    widget.snapshot['postID'],
                    _commentsController.text,
                    /*widget.snapshot['userID'],
                    widget.snapshot['username'],
                    widget.snapshot['profileImage'],*/
                    currentUid,
                    currentUsername,
                    currentProfPic,
                  );
                  // Clear the comment text field after submission
                  setState(() {
                    _commentsController.text = '';
                  });
                },
                child: const Text('Comment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
