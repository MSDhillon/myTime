// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:mytime/theme/colours.dart';

// ChatUI widget, which is a StatelessWidget
class ChatUI extends StatelessWidget {
  final String message; // The message to be displayed
  const ChatUI(
      {super.key, required this.message}); // Constructor for ChatUI widget

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5), // Padding around the container
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // Rounded corners for the container
          color: Pallete.secondaryColour // Background color for the container
          ),
      child: Text(
        message, // Display the message text
        style: const TextStyle(color: Colors.white // Text color for the message
            ),
      ),
    );
  }
}
