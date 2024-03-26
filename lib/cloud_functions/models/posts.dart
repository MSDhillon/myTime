class Post {
  // Member variables representing post properties
  final String description;
  final String uid; // User ID of the post's author
  final String username;
  final String postID;
  final DateTime publicationDate;
  final String postURL;
  final String profileImage;
  final List<String> upvotes; // List of user IDs who upvoted
  final List<String> downvotes; // List of user IDs who downvoted

  // Constructor for creating Post objects
  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postID,
    required this.publicationDate,
    required this.postURL,
    required this.profileImage,
    required this.upvotes,
    required this.downvotes,
  });

  // Method to convert a Post object into a Map for storing in Firestore
  Map<String, dynamic> toJson() => {
        'description': description,
        'userID': uid,
        'username': username,
        'postID': postID,
        'publicationDate': publicationDate,
        'postURL': postURL,
        'profileImage': profileImage,
        'upvotes': upvotes,
        'downvotes': downvotes,
      };
}
