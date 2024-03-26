import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class Storage {
  // Initialise Firebase Storage and Authentication instances
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth authentication = FirebaseAuth.instance;

  // Uploads an image to Firebase Storage and returns the download URL
  Future<String> uploadImage(
      String childName, Uint8List image, bool isPost) async {
    // Create a reference to the storage location based on the provided 'childName' and current user ID
    Reference reference =
        storage.ref().child(childName).child(authentication.currentUser!.uid);

    // If there is a post generate a unique ID for the image within the storage path
    if (isPost) {
      String iD = const Uuid().v1();
      reference = reference.child(iD);
    }

    // Upload the image data to the Firebase Storage reference
    UploadTask uploadTask = reference.putData(image);

    // Wait for the upload task to complete and get the snapshot
    TaskSnapshot snapshot = await uploadTask;

    // Retrieve the download URL for the uploaded image
    String url = await snapshot.ref.getDownloadURL();

    // Return the download URL
    return url;
  }
}
