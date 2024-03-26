import 'package:flutter/material.dart';

// Custom widget for input fields
class InputFields extends StatelessWidget {
  // Properties for the input field
  final TextEditingController textEditingController; // Controller for handling text input
  final bool isPassword; // Indicates whether the input is for a password
  final String hintText; // Hint text displayed in the input field
  final TextInputType textInputType; // Type of keyboard to display

  // Constructor for the InputFields widget
  const InputFields(
      {super.key,
      required this.textEditingController,
      required this.textInputType,
      required this.hintText,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    // Return a TextField widget with specified properties
    return TextField(
      controller: textEditingController, // Assign the provided controller
      decoration: InputDecoration(
        hintText: hintText, // Set the hint text for the input field
        hintStyle: const TextStyle(color: Colors.black),
        filled: true, // Fill the background of the input field
        contentPadding: const EdgeInsets.all(8), // Padding around the input field content
      ),
      keyboardType: textInputType, // Set the keyboard type for the input field
      obscureText: isPassword, // Whether to obscure text for password input
    );
  }
}
