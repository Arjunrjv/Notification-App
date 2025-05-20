import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:notification_app/screens/principal/principalCompose.dart';
import 'package:notification_app/screens/principal/principalLogout.dart';
import 'package:notification_app/screens/principal/principalProfile.dart';
import 'package:notification_app/screens/principal/principalSent.dart';

class PrincipalHome extends StatefulWidget {
  const PrincipalHome({Key? key, User? user}) : super(key: key);

  @override
  _PrincipalHomeState createState() => _PrincipalHomeState();
}

class _PrincipalHomeState extends State<PrincipalHome> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ComposeMessage(),
    const SentMessages(),
    const LogoutPage(),
    const ProfilePage(),
  ];

  Future<bool> _onWillPop() async {
    // If the current tab index is 0 (ComposeMessage tab), exit the app
    if (_selectedIndex == 0) {
      return true; // Allow the app to exit
    } else {
      // If the current tab index is not 0, switch to the ComposeMessage tab and prevent exiting the app
      setState(() {
        _selectedIndex = 0;
      });
      return false; // Prevent the app from exiting
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              child: GNav(
                gap: 8,
                tabBackgroundColor: Colors.black.withOpacity(0.10),
                tabBorderRadius: 20,
                tabs: const [
                  GButton(
                    icon: Iconsax.message_add4,
                    text: 'Compose',
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  GButton(
                    icon: Iconsax.send_14,
                    text: 'Sent',
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  GButton(
                    icon: Iconsax.logout4,
                    text: 'Logout',
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                  GButton(
                    icon: Iconsax.personalcard4,
                    text: 'Profile',
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                    ),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
                backgroundColor: const Color(0xFFD1C3DB),
              ),
            ),
          ),
        ));
  }
}
