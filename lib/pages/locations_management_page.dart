import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/pages/location_page.dart';
import 'package:review_app/widgets/ui_components.dart';

class LocationsManagementPage extends StatefulWidget {
  const LocationsManagementPage({super.key});

  @override
  State<LocationsManagementPage> createState() =>
      _LocationsManagementPageState();
}

class _LocationsManagementPageState extends State<LocationsManagementPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: primaryColor,
          title: Text("Locations Management"),
          centerTitle: true,
          bottom: TabBar(
            indicatorWeight: 5,
            indicatorColor: secondaryColor,

            // indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              tabOption(icon: Icon(Icons.check), text: "Publised"),
              tabOption(icon: Icon(Icons.pending), text: "Pending"),
              tabOption(icon: Icon(Icons.error), text: "Declined")
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: [
                tabContent(status: "published"),
              ],
            ),
            ListView(
              children: [tabContent(status: "pending")],
            ),
            ListView(
              children: [tabContent(status: "declined")],
            ),
            // Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  tabOption({required icon, required text}) {
    return Column(
      children: [Tab(icon: icon), Text(text)],
    );
  }

  Widget tabContent({required String status}) {
    return GestureDetector(
      onTap: () {
        if (status == "published") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPage(locationId: ""),
              ));
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 12),
              // child: ,
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                  image: DecorationImage(
                      image: AssetImage("assets/images/placeholder.jpg"),
                      fit: BoxFit.cover)),
            ),
            Container(
              // color: Colors.amberAccent,
              width: MediaQuery.of(context).size.width / 1.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading(title: "Title ", fontSize: 15),
                  Text("Restaurant"),
                  Text("Abuja - Nigeria"),
                  status == "published"
                      ? RatingBar.builder(
                          // tapOnlyMode: false,
                          // updateOnDrag: true,
                          ignoreGestures: true,
                          itemSize: 13,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          // itemPadding:
                          //     EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            size: 1,
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      : Container(),
                  status == "pending"
                      ? Text(
                          "Decision Pending",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  status == "declined"
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reason: The image provided is too small diohdsiod dsioh dih sdihds oidhio ih oih iohioh io hioh",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primaryColor,
                              ),
                              child: Text(
                                "Reupload",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      : Container(),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "3 days ago",
                  //       style: TextStyle(color: Color.fromARGB(255, 118, 115, 115)),
                  //     ),

                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
