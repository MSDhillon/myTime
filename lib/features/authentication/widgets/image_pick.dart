import 'package:image_picker/image_picker.dart';

// Method to pick an image from the specified source (gallery or camera)
pickImage (ImageSource source) async {
  // Creating an instance of ImagePicker
  final ImagePicker imagePicker = ImagePicker();
  // Using ImagePicker to pick an image from the specified source
  XFile? profilePicture = await imagePicker.pickImage(source: source);

  // If an image is successfully picked return the image data as bytes
  if (profilePicture != null) {
    return await profilePicture.readAsBytes();
  }
  // If no image is selected, print a message
  print('No image selected');
}
