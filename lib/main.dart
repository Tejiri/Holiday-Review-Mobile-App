import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/pages/bottom_navigation_page.dart';
import 'package:review_app/pages/home_page.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/pages/moderator_pages/moderator_homepage.dart';
import 'package:review_app/providers/UserProvider.dart';
import 'package:review_app/providers/UserRatingProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => userRatingProvider())
      // ChangeNotifierProvider(
      //   create: (context) => UserProvider(),
      // ),
    ],
    child: MaterialApp(
      home: SplashScreen(),
    ),
  ));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pushLoginPageAfterDelay();
  }

  void pushLoginPageAfterDelay() async {
    await Future.delayed(Duration(seconds: 2), _navi);
  }

  Future<void> _navi() async {
    if (authentication.currentUser == null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    } else {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.getBool("isModerator") != null &&
          prefs.getBool("isModerator") == true) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => ModeratorHomePage()));
      } else if (prefs.getBool("isModerator") != null &&
          prefs.getBool("isModerator") == false) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => BottomNavigationPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Icon(
                Icons.star_border,
                size: 100,
                color: Colors.white,
              ),
            ),
            Text(
              "Software Engineering",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              "Principles",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Group 20",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
