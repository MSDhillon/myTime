import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID; // Unique identifier of the message sender
  final String senderUsername; // Display name of the message sender
  final String receiverID; // Unique identifier of the message recipient
  final String message; // The text content of the message
  final Timestamp timestamp; // Date and time that the message was sent

  Message({
    required this.senderID,
    required this.senderUsername,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    // Convert the Message object into a Map suitable for storing in Firestore
    return {
      'senderID': senderID,
      'senderUsername': senderUsername,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
