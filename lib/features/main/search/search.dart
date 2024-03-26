// Importing necessary packages and files
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytime/constants/assets.dart';
import 'package:mytime/features/main/profile/profile.dart';

// Search widget, which is a StatefulWidget
class Search extends StatefulWidget {
  const Search({super.key}); // Constructor for Search widget

  @override
  State<Search> createState() =>
      _SearchState(); // Creating state for Search widget
}

// State class for Search widget
class _SearchState extends State<Search> {
  final TextEditingController _searchController =
      TextEditingController(); // Controller for search text field
  bool showUsers = false; // Flag to indicate whether to show search results

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose(); // Dispose the text controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(Assets.appLogo), // Display app logo in the app bar
        title: TextFormField(
          controller: _searchController,
          // Set the controller for the search text field
          decoration: const InputDecoration(hintText: 'Search'),
          // Set placeholder text for search field
          onFieldSubmitted: (String _) {
            setState(() {
              showUsers =
                  true; // Set showUsers flag to true when search is submitted
            });
          },
        ),
      ),
      body:
          showUsers // Display search results if showUsers is true, otherwise display a message
              ? FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('username',
                          isGreaterThanOrEqualTo: _searchController
                              .text) // Query Firestore for users with usernames starting with the search query
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                      uid: snapshot.data!.docs[index][
                                          'userID'] // Navigate to the profile page of the selected user
                                      ))),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                snapshot.data!.docs[index][
                                    'profilePictureURL'], // Display user's profile picture
                              ),
                            ),
                            title: Text(
                              snapshot.data!.docs[index]['username'],
                              // Display user's username
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge, // Set text style for username
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'Search for a user',
                    // Display message prompting user to search for a user
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall, // Set text style for the message
                  )),
    );
  }
}
