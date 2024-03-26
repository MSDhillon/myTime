import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytime/cloud_functions/models/posts.dart';
import 'package:mytime/cloud_functions/storage.dart';
import 'package:uuid/uuid.dart';

class Database {
  final FirebaseFirestore _database = FirebaseFirestore.instance;

  // Method to upload a new post to Firestore
  Future<String> uploadPost(
    String text,
    Uint8List image,
    String uid,
    String username,
    String profileImage,
  ) async {
    String msg = 'An error occurred'; // Default error message
    try {
      // Upload image to Firebase Storage using the 'Storage' class
      String photoURL = await Storage().uploadImage('posts', image, true);

      // Generate a unique ID for the post
      String postID = const Uuid().v1();

      // Create a Post object with provided data
      Post post = Post(
        description: text,
        uid: uid,
        username: username,
        postID: postID,
        publicationDate: DateTime.now(),
        postURL: photoURL,
        profileImage: profileImage,
        upvotes: [],
        downvotes: [],
      );

      // Store the post data in the 'posts' collection in Firestore
      _database.collection('posts').doc(postID).set(post.toJson());
      msg = 'Post uploaded successfully';
    } catch (error) {
      // Handle errors during the upload process
      msg = error.toString();
    }
    return msg;
  }

  // Method to handle upvoting a post
  Future<void> upvotePost(
      String pid, String uid, List upvotes, List downvotes) async {
    try {
      // Check if the user has already upvoted the post
      if (upvotes.contains(uid)) {
        // User has upvoted -> remove upvote
        await _database.collection('posts').doc(pid).update({
          'upvotes': FieldValue.arrayRemove([uid]),
        });
        // Decrease the user's experience
        await _database.collection('users').doc(uid).update({
          'experience': FieldValue.increment(-1),
        });
      } else {
        // User has not upvoted -> add upvote
        await _database.collection('posts').doc(pid).update({
          'upvotes': FieldValue.arrayUnion([uid]),
        });
        // Increase the user's experience
        await _database.collection('users').doc(uid).update({
          'experience': FieldValue.increment(1),
        });
      }
      // Check if the user downvoted and swap vote if needed
      if (downvotes.contains(uid)) {
        await _database.collection('posts').doc(pid).update({
          'downvotes': FieldValue.arrayRemove([uid]),
          'upvotes': FieldValue.arrayUnion([uid]),
        });
        // Increment experience for switching from downvote to upvote
        await _database.collection('users').doc(uid).update({
          'experience': FieldValue.increment(1),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Method to handle downvoting a post (similar logic to 'upvotePost')
  Future<void> downvotePost(
      String pid, String uid, List upvotes, List downvotes) async {
    try {
      // Check if the user has already downvoted the post
      if (downvotes.contains(uid)) {
        // User has downvoted -> remove downvote
        await _database.collection('posts').doc(pid).update({
          'downvotes': FieldValue.arrayRemove([uid]),
        });
        // Increase the user's experience
        await _database.collection('users').doc(uid).update({
          'experience': FieldValue.increment(1),
        });
      } else {
        // User has not downvoted -> add downvote
        await _database.collection('posts').doc(pid).update({
          'downvotes': FieldValue.arrayUnion([uid]),
        });
        // Decrease the user's experience
        await _database.collection('users').doc(uid).update({
          'experience': FieldValue.increment(-1),
        });
      }
      // Check if the user upvoted and swap vote if needed
      if (upvotes.contains(uid)) {
        await _database.collection('posts').doc(pid).update({
          'upvotes': FieldValue.arrayRemove([uid]),
          'downvotes': FieldValue.arrayUnion([uid]),
        });
        // Decrement experience for switching from upvote to downvote
        await _database.collection('users').doc(uid).update({
          'experience': FieldValue.increment(-1),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Method to upload a comment to a post
  Future<void> uploadComment(String pid, String comment, String uid,
      String username, String profPic) async {
    try {
      if (comment.isNotEmpty) {
        // Generate a unique ID for the comment
        String cid = const Uuid().v1();

        // Store the comment data within the post's 'comments' subcollection
        await _database
            .collection('posts')
            .doc(pid)
            .collection('comments')
            .doc(cid)
            .set({
          'profilePicture': profPic,
          'username': username,
          'userID': uid,
          'comment': comment,
          'commentID': cid,
          'publicationDate': DateTime.now(),
        });
      } else {
        const Text('Empty Text');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Method to delete a post
  Future<void> deletePost(String pid) async {
    try {
      await _database.collection('posts').doc(pid).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> connectUsers(String uid, String cid) async {
    try {
      // 1. Get the 'connections' list for the user with 'uid'
      DocumentSnapshot snapshot =
          await _database.collection('users').doc(uid).get();
      List connections = (snapshot.data()! as dynamic)['connections'];

      // 2. Check if the user with 'cid' is already a connection
      if (connections.contains(cid)) {
        // 2a. Already connected: Remove the connection for both users
        await _database.collection('users').doc(cid).update({
          'connections': FieldValue.arrayRemove([uid])
          // Remove 'uid' from 'cid' connections
        });
        await _database.collection('users').doc(uid).update({
          'connections': FieldValue.arrayRemove([cid])
          // Remove 'cid' from 'uid' connections
        });
      } else {
        // 2b. Not connected: Add the connection for both users
        await _database.collection('users').doc(cid).update({
          'connections': FieldValue.arrayUnion([uid])
          // Add 'uid' to 'cid' connections
        });
        await _database.collection('users').doc(uid).update({
          'connections': FieldValue.arrayUnion([cid])
          // Add 'cid' to 'uid' connections
        });
      }
    } catch (error) {
      // Basic error handling: print error to console
      print(error.toString());
    }
  }
}
