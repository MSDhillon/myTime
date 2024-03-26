import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mytime/theme/colours.dart';
import 'package:mytime/constants/UI_constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _HomePage();
}

class _HomePage extends State<Dashboard> {
  int _currentPageIndex = 0; // Index of the current page in the bottom navigation bar
  String username = ''; // Variable to hold the username

  @override
  void initState() {
    super.initState();
    getUserDetails(); // Fetch user details when the widget initializes
  }

  // Method to fetch user details from Firestore
  void getUserDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      // Set the username retrieved from Firestore
      username = (snapshot.data() as Map<String, dynamic>)['username'];
    });
  }

  // Method to navigate to the messenger page
  void navigateMessenger() {
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Messen))
  }

  // Method to handle bottom navigation bar page changes
  void pageChange(int index) {
    setState(() {
      _currentPageIndex = index; // Update the current page index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentPageIndex,
        children: UIConstants.tabBarPages, // List of pages to be displayed based on the current index
      ),
      bottomNavigationBar: CupertinoTabBar(
        onTap: pageChange, // Callback function for bottom navigation bar item tap
        items: [
          // Bottom navigation bar items
          BottomNavigationBarItem(
            icon: _currentPageIndex == 0
                ? const Icon(
                    Icons.home,
                    color: Pallete.tertiaryColour, // Apply primary color when selected
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Pallete.secondaryColour, // Apply secondary color when not selected
                  ),
          ),
          BottomNavigationBarItem(
            icon: _currentPageIndex == 1
                ? const Icon(
                    Icons.search,
                    color: Pallete.tertiaryColour,
                  )
                : const Icon(
                    Icons.search_outlined,
                    color: Pallete.secondaryColour,
                  ),
          ),
          BottomNavigationBarItem(
            icon: _currentPageIndex == 3
                ? const Icon(
                    Icons.person,
                    color: Pallete.tertiaryColour,
                  )
                : const Icon(
                    Icons.person_outline,
                    color: Pallete.secondaryColour,
                  ),
          ),
        ],
      ),
    );
  }
}
