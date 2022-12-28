import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/pages/locations_management_page.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/pages/upload_location_page.dart';
import 'package:review_app/widgets/ui_components.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsSwitchBool = false;
  bool darkModeSwitchBool = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: ListView(
                children: [
                  // Padding(padding: EdgeInsets.only(top: 10)),

                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: CircleAvatar(
                      backgroundColor: primaryColor,
                      radius: 50.0,
                      child: ClipRRect(
                        // child: Image.network(
                        //   profilePhoto,
                        //   fit: BoxFit.cover,
                        //   height: 100,
                        //   width: 100,
                        // ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        heading(title: "Tejiri Emoghene-Ijatomi", fontSize: 25),
                        Text(
                          "steveijatomi@gmail.com",
                          style: TextStyle(fontSize: 18),
                        ),
                        settingsHeading(title: "Settings"),
                        settingsOption(
                            icon: Icons.person,
                            title: "Edit Profile",
                            trailing: Icon(
                              Icons.chevron_right,
                              size: 35,
                            )),
                        settingsOption(
                            icon: Icons.upload,
                            title: "Upload Location",
                            trailing: Icon(
                              Icons.chevron_right,
                              size: 35,
                            )),
                        settingsOption(
                            icon: Icons.location_city,
                            title: "Locations Management",
                            trailing: Icon(
                              Icons.chevron_right,
                              size: 35,
                            )),
                        settingsHeading(title: "Preferences"),
                        settingsOption(
                            icon: Icons.notifications,
                            title: "Notifications",
                            trailing: Switch(
                              activeColor: primaryColor,
                              value: notificationsSwitchBool,
                              onChanged: (value) {
                                setState(() {
                                  notificationsSwitchBool = value;
                                });
                              },
                            )),
                        settingsOption(
                            icon: Icons.dark_mode,
                            title: "Dark Mode",
                            trailing: Switch(
                              activeColor: primaryColor,
                              value: darkModeSwitchBool,
                              onChanged: (value) {
                                setState(() {
                                  darkModeSwitchBool = value;
                                });
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Builder(
                            builder: (context) {
                              final GlobalKey<SlideActionState> _key =
                                  GlobalKey();
                              return SlideAction(
                                // innerColor: dar,
                                outerColor: primaryColor,
                                sliderButtonIconSize: 25,
                                sliderButtonIconPadding: 10,
                                sliderButtonIcon: Icon(Icons.logout),
                                // child: Text("Logout"),
                                height: 60,
                                text: "Logout",
                                key: _key,
                                onSubmit: () {
                                     authentication.signOut().then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (route) => false);
                });
                                  // Future.delayed(
                                  //   Duration(seconds: 1),
                                  //   () => Navigator.pushAndRemoveUntil(
                                  //       context,
                                  //       // _key.currentState?.reset()
                                  //       MaterialPageRoute(
                                  //         builder: (context) => LoginPage(),
                                  //       ),
                                  //       (route) => false),
                                  // );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   child: IconButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       icon: Icon(Icons.arrow_back)),
            // ),
          ],
        ),
      ),
    );
  }

  settingsHeading({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          heading(
            title: title,
          ),
        ],
      ),
    );
  }

  settingsOption(
      {required IconData icon, required String title, Widget? trailing}) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case "Locations Management":
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationsManagementPage(),
                ));
            break;

          case "Upload Location":
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UploadLocationPage(),
                ));
            break;
          default:
        }
      },
      child: Container(
        height: 65,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: darkBlueGray,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(4.0, 5.0), //(x,y)
                blurRadius: 3.0,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                      // maxRadius: 18,
                      backgroundColor: primaryColor,
                      child: Icon(
                        icon,
                        color: Colors.white,
                      )),
                ),
                heading(title: title, fontSize: 18)
              ],
            ),
            trailing ?? Container()
          ],
        ),
      ),
    );
  }
}
