// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytime/cloud_functions/authentication.dart';
import 'package:mytime/cloud_functions/database.dart';
import 'package:mytime/constants/assets.dart';
import 'package:mytime/features/authentication/landing/landing_page.dart';
import 'package:mytime/features/authentication/widgets/snackbar.dart';
import 'package:mytime/features/main/home/posts/widgets/post_ui.dart';
import 'package:mytime/features/main/profile/edit_profile/edit_page.dart';
import '../../../theme/colours.dart';

// Profile class, which is a StatefulWidget
class Profile extends StatefulWidget {
  final uid;

  const Profile({super.key, required this.uid}); // Constructor for Profile

  @override
  State<Profile> createState() => _ProfileState(); // Creating state for Profile
}

// State class for Profile widget
class _ProfileState extends State<Profile> {
  var userData = {}; // User data retrieved from Firestore
  int postLength = 0; // Number of posts by the user
  int connections = 0; // Number of connections of the user
  bool areConnected =
      false; // Flag indicating whether the current user is connected to the profile user

  @override
  void initState() {
    super.initState();
    getData(); // Call the method to fetch user data
  }

  // Method to fetch user data from Firestore
  getData() async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get(); // Get user data document from Firestore
      userData = userSnapshot.data()!; // Extract user data from the document

      var postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userID', isEqualTo: widget.uid)
          .get(); // Get user's posts from Firestore
      postLength = postSnapshot.docs.length; // Calculate number of posts

      connections = userSnapshot
          .data()!['connections']
          .length; // Calculate number of connections

      areConnected = userSnapshot.data()!['connections'].contains(FirebaseAuth
          .instance
          .currentUser!
          .uid); // Check if current user is connected to profile user

      setState(() {}); // Update UI with fetched data
    } catch (e) {
      showSnackBar(
          e.toString(), context); // Show error message if data fetching fails
    }
  }

  // Method to determine the badge based on user's experience level
  String getBadge() {
    if (userData['experience'] < 200) {
      return Assets.noviceBadge;
    } else if (userData['experience'] < 400) {
      return Assets.bronzeBadge;
    } else if (userData['experience'] < 800) {
      return Assets.silverBadge;
    } else if (userData['experience'] < 1600) {
      return Assets.goldBadge;
    } else {
      return Assets.diamondBadge;
    }
  }

  void goToEdit() {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => const EditPage()));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(Assets.appLogo), // Display app logo in the app bar
        title: Text('Account',
            style:
                Theme.of(context).textTheme.headlineSmall), // Set app bar title
        actions: [
          IconButton(
              onPressed: () async {
                await AuthenticationMethods().logOut(); // Call logout method
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        const LandingPage() // Navigate to landing page after logout
                    ));
              },
              icon: const Icon(
                // Logout button
                Icons.logout_rounded,
                color: Pallete.tertiaryColour,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Display user profile information
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(userData['profilePictureURL']),
                    radius: 50.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Display number of posts
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(postLength.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            Text('Posts',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                        // Display number of connections
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(connections.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            Text('Connections',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    // Display username and badge
                    Text(userData['username'] ?? 'Loading username...',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 15,
                    ),
                    Image.asset(
                      getBadge(),
                      scale: 35,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 5),
                child: Text(userData['bio'] ?? 'Loading bio...', // Display user bio
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(children: [
                  Expanded(
                    child: FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? ElevatedButton(
                            onPressed: () => goToEdit(),
                            child: const Text(
                                'Edit Profile') // Button to edit profile
                            )
                        : areConnected
                            ? OutlinedButton(
                                onPressed: () async {
                                  await Database().connectUsers(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['userID']);
                                  setState(() {
                                    areConnected = false;
                                    connections--;
                                  });
                                },
                                child: const Text(
                                    'Disconnect') // Button to disconnect from user
                                )
                            : ElevatedButton(
                                onPressed: () async {
                                  await Database().connectUsers(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      userData['userID']);
                                  setState(() {
                                    areConnected = true;
                                    connections++;
                                  });
                                },
                                child: const Text(
                                    'Connect') // Button to connect with user
                                ),
                  ),
                ]),
              ),
              const Divider(),
              // Display user's posts using StreamBuilder
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('userID', isEqualTo: widget.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => PostCard(
                              postData: snapshot.data!.docs[index].data(),
                            ));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
