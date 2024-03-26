import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytime/features/main/profile/profile.dart';
import 'package:mytime/features/main/search/search.dart';
import '../features/main/home/home.dart';

class UIConstants{
  // Static list to hold the widgets (screens) that will be used in a BottomNavigationBar or similar
  static List<Widget> tabBarPages = [
    const Home(), // Home screen widget
    const Search(), // Search screen widget
    Profile(uid: FirebaseAuth.instance.currentUser!.uid,), // Profile screen, passing the current user's ID
  ];
}
