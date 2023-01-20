import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/utils/constants.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/pages/moderator_pages/pending_locations_page.dart';
import 'package:review_app/pages/moderator_pages/reports_page.dart';

class ModeratorHomePage extends StatefulWidget {
  const ModeratorHomePage({super.key});

  @override
  State<ModeratorHomePage> createState() => _ModeratorHomePageState();
}

class _ModeratorHomePageState extends State<ModeratorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 195, 195),
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        leading: Container(),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Text("Logout"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              authentication.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false);
              });
            }
          }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
        child: ListView(children: [
          moderatorDashboardWidget(iconData: Icons.report, title: "REPORTS"),
          moderatorDashboardWidget(
              iconData: Icons.location_city, title: "PENDING LOCATIONS"),
        ]),
      ),
    );
  }

  Widget moderatorDashboardWidget(
      {required IconData iconData, required String title}) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case "REPORTS":
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportsPage(),
                ));
            break;
          case "PENDING LOCATIONS":
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PendingLocationsPage(),
                ));
            break;
          default:
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.only(right: 30),
                child: Icon(
                  iconData,
                  color: Colors.black,
                  size: 25,
                )),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
          ],
        ),
      ),
    );
  }
}
