// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytime/cloud_functions/models/message.dart';

// ChatService class, extending ChangeNotifier
class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance; // Firebase Auth instance for user authentication
  final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance; // Firestore instance for database operations

  // Method to send a message
  Future<void> sendMessage(String rid, String message) async {
    // Get current user's UID
    final String currentUid = _firebaseAuth.currentUser!.uid;
    // Fetch current user's username from Firestore
    DocumentSnapshot userSnapshot =
        await _firebaseFirestore.collection('users').doc(currentUid).get();
    final String currentUsername = userSnapshot['username'].toString();
    final Timestamp timestamp = Timestamp.now(); // Get current timestamp

    // Create a new message instance
    Message newMessage = Message(
        senderID: currentUid,
        senderUsername: currentUsername,
        receiverID: rid,
        message: message,
        timestamp: timestamp);

    // Construct chat room ID from current user's UID and receiver's UID
    List<String> ids = [currentUid, rid];
    ids.sort();
    String chatID = ids.join('_');

    // Add message to Firestore under the specified chat room ID
    await _firebaseFirestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // Method to retrieve messages
  Stream<QuerySnapshot> getMessages(String rUid, String cUid) {
    // Construct chat room ID from receiver's UID and current user's UID
    List<String> ids = [rUid, cUid];
    ids.sort();
    String chatID = ids.join('_');
    // Return a stream of messages from Firestore under the specified chat room ID, ordered by timestamp
    return _firebaseFirestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
