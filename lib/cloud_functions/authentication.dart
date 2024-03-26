import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytime/cloud_functions/models/users.dart' as model;
import 'dart:typed_data';
import 'storage.dart';
import 'exceptions/authentication_failures.dart';

class AuthenticationMethods {
  // Initialise Firebase services
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List profilePicture,
  }) async {
    String message = 'An error occurred'; // Default error message
    try {
      // Input validation: ensure all fields are provided
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          profilePicture != null) {
        // Create a new user with Firebase Authentication
        UserCredential credential = await _authentication
            .createUserWithEmailAndPassword(email: email, password: password);

        print(credential.user!.uid);

        // Upload profile picture to Firebase Storage
        String photoURL = await Storage()
            .uploadImage('profilePictures', profilePicture, false);

        // Create a User object with the data
        model.User user = model.User(
            email: email,
            uid: credential.user!.uid,
            photoURL: photoURL,
            username: username,
            bio: bio,
            connections: [],
            exp: 0);

        // Store the user's data in Firebase Firestore
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
        message = 'User Added Successfully';
      }
    } on FirebaseAuthException catch (error) {
      // Handle Firebase Authentication errors
      final e = AuthenticationFailure.code(error.code);
      throw e;
    } catch (error) {
      // Handle generic errors
      message = error.toString();
    }
    return message;
  }

  Future<String> updateUser({
    required String username,
    required String bio,
    required Uint8List profilePicture,
  }) async {
    String message = 'An error occurred'; // Default error message
    try {
      // Input validation: ensure all fields are provided
      if (username.isNotEmpty ||
          bio.isNotEmpty ||
          profilePicture != null) {
        final currentUser = _authentication.currentUser;
        if (currentUser == null) {
          return 'User not signed in';
        }

        String? photoURL;
        photoURL = await Storage()
            .uploadImage('profilePictures', profilePicture, false);
      
        final docUser = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid);

        await docUser.update({
          'username': username,   // Update username if changed
          'bio': bio,             // Update bio if changed
          'profilePictureURL': photoURL, // Update image URL if changed
        });

        message = 'User updated successfully';
      }
    } on FirebaseAuthException catch (error) {
      // Handle Firebase Authentication errors
      final e = AuthenticationFailure.code(error.code);
      throw e;
    } catch (error) {
      // Handle generic errors
      message = error.toString();
    }
    return message;
  }

  // User login functionality
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String message = 'An error occurred';

    try {
      // Input Validation: Ensure email and password are provided
      if (email.isNotEmpty || password.isNotEmpty) {
        // Sign in the user with Firebase Authentication
        await _authentication.signInWithEmailAndPassword(
            email: email, password: password);
        message = 'User Logged Successfully';
        print(message);
      } else {
        message = 'Fill all fields';
      }
    } on FirebaseAuthException catch (error) {
      // Handle Firebase Authentication errors
      final e = AuthenticationFailure.code(error.code);
      throw e;
    } catch (error) {
      // Handle generic errors
      message = error.toString();
    }
    return message;
  }

  Future<void> logOut() async {
    await _authentication.signOut();
}
}
