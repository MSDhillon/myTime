// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytime/features/main/messenger/chat/widgets/chat_system.dart';
import 'package:mytime/features/main/messenger/chat/widgets/chat_ui.dart';

// ChatPage widget, which is a StatefulWidget
class ChatPage extends StatefulWidget {
  final String username; // Username of the chat recipient
  final String uid; // UID of the chat recipient

  const ChatPage(
      {super.key,
      required this.username,
      required this.uid}); // Constructor for ChatPage widget

  @override
  State<ChatPage> createState() =>
      _ChatPageState(); // Creating state for ChatPage widget
}

// State class for ChatPage widget
class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController =
      TextEditingController(); // Controller for the text field to send messages
  final ChatService _chatService =
      ChatService(); // Instance of ChatService for handling chat operations
  final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance; // Instance of FirebaseAuth for user authentication

  // Method to send a message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.uid,
          _messageController.text); // Send message using ChatService
      _messageController.clear(); // Clear the message text field after sending
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController
        .dispose(); // Dispose the text controller when the widget is disposed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username,
            style: Theme.of(context)
                .textTheme
                .headlineSmall // Display the username in the app bar
            ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: StreamBuilder(
                stream: _chatService.getMessages(
                    widget.uid, _firebaseAuth.currentUser!.uid),
                // Stream of messages between users
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    Text(
                        'Error: ${snapshot.error}'); // Display error if there's an error in the stream
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(), // Display loading indicator while waiting for messages
                    );
                  }
                  return ListView(
                    children: snapshot.data!.docs
                        .map((document) => _messageItem(document))
                        .toList(), // Display messages in a ListView
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  // Controller for the message text field
                  obscureText: false,
                  decoration: const InputDecoration(
                      hintText: 'Type here',
                      // Placeholder text for the message text field
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      )),
                ),
              ),
              IconButton(
                  onPressed: sendMessage,
                  // Call sendMessage method when send button is pressed
                  icon:
                      const Icon(Icons.send_rounded) // Display send icon button
                  )
            ],
          ),
        ],
      ),
    );
  }

  Widget _messageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data()
        as Map<String, dynamic>; // Extract message data from document

    var alignment = (data['senderID'] ==
            _firebaseAuth
                .currentUser!.uid) // Determine alignment based on sender ID
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderID'] ==
                _firebaseAuth
                    .currentUser!.uid) // Align message based on sender ID
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisAlignment: (data['senderID'] ==
                _firebaseAuth
                    .currentUser!.uid) // Align message based on sender ID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Text(data['senderUsername']),
          // Display sender's username
          ChatUI(message: data['message'])
          // Display message using ChatUI widget
        ],
      ),
    );
  }
}
