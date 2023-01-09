import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/constants.dart';
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
          // IconButton(
          //     icon: cusIcon,
          //     onPressed: () {
          //       if (mounted) {
          //         setState(() {
          //           if (cusIcon.icon == Icons.search) {
          //             cusIcon = Icon(Icons.cancel);
          //             cusSearchBar = TextField(
          //               focusNode: focusUserSearch,
          //               controller: searchController,
          //               onChanged: (value) async {
          //                 nameToSearch = value;

          //                 setState(() {});
          //               },
          //               decoration: const InputDecoration(
          //                   hintStyle: TextStyle(color: Colors.white),
          //                   hintText: "Search",
          //                   border: InputBorder.none),
          //               textInputAction: TextInputAction.go,
          //               style: const TextStyle(
          //                   color: Colors.white, fontSize: 16.0),
          //             );

          //             // setState(() {});
          //             focusUserSearch.requestFocus();
          //           } else {
          //             cusIcon = Icon(Icons.search);
          //             nameToSearch = '';
          //             searchController.text = '';
          //             setState(() {});
          //             cusSearchBar = const Text(
          //               "RenMiss Chat",
          //               style: TextStyle(color: Colors.white),
          //             );
          //           }
          //         });
          //       }
          //     }),

          PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
            return [
              // PopupMenuItem<int>(
              //   value: 1,
              //   child: Text("Settings"),
              // ),
              // PopupMenuItem<int>(
              //   value: 1,
              //   child: Text("Settings"),
              // ),
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
              // showBottomSheet();
              // print("My account menu is selected.");
            }

            // else if (value == 1) {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => SettingsPage(),
            //       ));
            // }
          }),

          // IconButton(
          //     onPressed: () {

          //     }, icon: Icon(Icons.more_vert))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
        child: ListView(children: [
          // TODO Transactions history here:
          moderatorDashboardWidget(iconData: Icons.report, title: "REPORTS"),
          moderatorDashboardWidget(
              iconData: Icons.location_city, title: "PENDING UPLOADS"),
          // moderatorDashboardWidget(
          //     iconData: Icons.phone_android_outlined, title: "REPORTS"),
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
          case "PENDING UPLOADS":
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
