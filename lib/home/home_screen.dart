import 'package:daun/home/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'coming_soon_screen.dart';
import 'dashboard_screen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final tabs = [
    DashboardScreen(),
    ComingSoonScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.green,
            ),
            label: 'Homepage',
          ),
          BottomNavigationBarItem(
            icon:  Icon(
              Icons.messenger,
              color: Colors.green,
            ),
            label: 'Coming Soon',
          ),
          BottomNavigationBarItem(
            icon:  Icon(
              Icons.person,
              color: Colors.green,
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.green,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: tabs[_currentIndex],
    );
  }
}

void toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}
