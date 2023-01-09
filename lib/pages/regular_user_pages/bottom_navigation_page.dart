import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/pages/regular_user_pages/favorites_page.dart';
import 'package:review_app/pages/regular_user_pages/home_page.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/pages/regular_user_pages/settings_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  // final autoSizeGroup = AutoSizeGroup();

  var selectedIndex = 0; //default index of a first screen

  // late AnimationController _fabAnimationController;
  // late AnimationController _borderRadiusAnimationController;
  // late Animation<double> fabAnimation;
  // late Animation<double> borderRadiusAnimation;
  // late CurvedAnimation fabCurve;
  // late CurvedAnimation borderRadiusCurve;
  // late AnimationController _hideBottomBarAnimationController;

  static List<Widget> _pages = <Widget>[
    HomePage(),
    FavoritesPage(),
    SettingsPage()
    // SettingsPage()
  ];
  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    log(index.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: secondaryColor,
          currentIndex:selectedIndex ,
          onTap: _onTap,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),

             BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.chat),
            //   label: 'Chats',
            // ),
          ],
        ));

    // GNav(
    //   // color: ,
    //   backgroundColor: primaryColor,
    //   padding: EdgeInsets.all(30),
    //   iconSize: 20,
    //   color: Color.fromARGB(183, 0, 0, 0),
    //   activeColor: lightBlueGray,
    //   textStyle: TextStyle(
    //       fontSize: 15, fontWeight: FontWeight.bold, color: lightBlueGray),
    //   gap: 10,
    //   tabs: <GButton>[
    //     GButton(
    //       margin: EdgeInsets.all(10),
    //       padding: EdgeInsets.all(5),
    //       backgroundColor: Color.fromARGB(122, 0, 0, 0),
    //       icon: Icons.home,
    //       text: "Home",
    //     ),
    //     GButton(
    //       margin: EdgeInsets.all(10),
    //       padding: EdgeInsets.all(5),
    //       backgroundColor: Color.fromARGB(122, 0, 0, 0),
    //       icon: Icons.favorite,
    //       text: "Favorites",
    //     ),
    //     // GButton(
    //     //   margin: EdgeInsets.all(10),
    //     //   padding: EdgeInsets.all(5),
    //     //   backgroundColor: Color.fromARGB(122, 0, 0, 0),
    //     //   icon: Icons.settings,
    //     //   text: "Settings",
    //     // ),
    //   ],
    //   onTabChange: (index) {
    //     setState(() {
    //       _bottomNavIndex = index;
    //     });
    //   },
    // ));
  }
}
