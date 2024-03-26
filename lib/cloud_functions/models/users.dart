class User{
  // Member variables representing user properties
  final String email;
  final String uid;
  final String photoURL;
  final String username;
  final String bio;
  final List connections;
  final int exp;

  // Constructor for creating User objects
  const User ({
    required this.email,
    required this.uid,
    required this.photoURL,
    required this.username,
    required this.bio,
    required this.connections,
    required this.exp,
});

  // Method to convert a User object into a Map for storing in Firestore
  Map<String, dynamic> toJson() => {
    'username': username,
    'userID' : uid,
    'email' : email,
    'bio' : bio,
    'connections' : [],
    'profilePictureURL': photoURL,
    'experience': exp,
  };
}
