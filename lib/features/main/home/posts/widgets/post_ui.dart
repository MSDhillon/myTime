// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytime/cloud_functions/database.dart';
import 'package:mytime/features/authentication/widgets/snackbar.dart';
import 'package:mytime/features/main/home/posts/comments/comments.dart';
import 'package:mytime/theme/colours.dart';
import 'package:share_plus/share_plus.dart';

// PostCard widget
class PostCard extends StatefulWidget {
  final postData; // Post data
  const PostCard({super.key, required this.postData});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String uid = ''; // User ID
  int comments = 0; // Number of comments
  Color _upvoteColour = Pallete.alternateColour; // Color for upvote button
  Color _downvoteColour = Pallete.alternateColour; // Color for downvote button

  @override
  void initState() {
    super.initState();
    getComments(); // Get comments count
    getUserDetails(); // Get user details
    _updateVoteColours(); // Update vote button colors
  }

  // Method to get comments count
  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postData['postID'])
          .collection('comments')
          .get();
      comments = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context); // Show error message in a snackbar
    }

    setState(() {});
  }

  // Method to get user details
  void getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      uid = (snapshot.data() as Map<String, dynamic>)['userID']; // Set user ID
    });
  }

  // Method to update vote button colors
  void _updateVoteColours() {
    setState(() {
      _upvoteColour = widget.postData['upvotes'].contains(uid)
          ? Colors.green // Change color to green if user has upvoted
          : Pallete.alternateColour; // Use default color otherwise
      _downvoteColour = widget.postData['downvotes'].contains(uid)
          ? Colors.red // Change color to red if user has downvoted
          : Pallete.alternateColour; // Use default color otherwise
    });
  }

  // Method to navigate to comments page
  void _goToComments() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CommentsPage(
              snapshot: widget.postData, // Pass post data to comments page
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.postData['profileImage']),
                  // Profile image of the post author
                  radius: 35.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Text(
                            widget.postData['username'],
                            // Username of the post author
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          ' ●  ${DateFormat.yMMMd().format(widget.postData['publicationDate'].toDate())}',
                          // Publication date of the post
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () async {
                    Database()
                        .deletePost(widget.postData['postID']); // Delete post
                  },
                  icon: const Icon(Icons.delete) // Delete post icon
                  ),
            ],
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: Text(
              widget.postData['description'], // Post description
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.30,
              width: double.infinity,
              child: Image.network(
                widget.postData['postURL'], // Post image URL
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () async {
                    await Database().upvotePost(
                      widget.postData['postID'], // Post ID
                      uid, // User ID
                      widget.postData['upvotes'], // List of upvotes
                      widget.postData['downvotes'], // List of downvotes
                    );
                    _updateVoteColours(); // Update vote button colors
                  },
                  icon: Icon(
                    Icons.arrow_circle_up, // Upvote icon
                    color: _upvoteColour, // Upvote button color
                  )),
              IconButton(
                  onPressed: () async {
                    await Database().downvotePost(
                      widget.postData['postID'], // Post ID
                      uid, // User ID
                      widget.postData['upvotes'], // List of upvotes
                      widget.postData['downvotes'], // List of downvotes
                    );
                    _updateVoteColours(); // Update vote button colors
                  },
                  icon: Icon(
                    Icons.arrow_circle_down_rounded, // Downvote icon
                    color: _downvoteColour, // Downvote button color
                  )),
              IconButton(
                  onPressed: _goToComments,
                  icon: const Icon(
                    Icons.comment_rounded, // Comment icon
                    color: Pallete.alternateColour,
                  )),
              IconButton(
                  onPressed: () async {
                    final image = widget.postData['postURL'];
                    final description = widget.postData['description'];
                    await Share.share(
                        'Check out this post on my Time: $description\n\n$image'); // Share post
                  },
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Pallete.alternateColour,
                  ))
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${widget.postData['upvotes'].length} upvotes',
                      // Upvotes count
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Text('●'),
                    Text(
                      '${widget.postData['downvotes'].length} downvotes',
                      // Downvotes count
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Text('●'),
                    Text(
                      '$comments comments', // Comments count
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Text('●'),
                    Text(
                      'Share',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Divider(), // Divider line
        ],
      ),
    );
  }
}
