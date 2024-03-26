import 'package:flutter/material.dart';

// Function to show a snackbar with the provided message
showSnackBar(String message, BuildContext context) {
  // Retrieve the ScaffoldMessenger for the current context and show the snackbar
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message) // Display the provided message in the snackbar
      ));
}
