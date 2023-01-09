import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/controllers/random.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/pages/regular_user_pages/location_page.dart';
import 'package:review_app/custom_widgets/ui_components.dart';
import 'package:skeletons/skeletons.dart';

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
            // ListView(
            //   children: [
            //     tabContent(status: "published"),
            //   ],
            // ),
            StreamBuilder(
                stream: firestore
                    .collection(uploadedLocationsCollectionName)
                    .where("uploadedBy",
                        isEqualTo: authentication.currentUser?.uid)
                    .where("status", isEqualTo: "published")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        locationSnapshot) {
                  if (locationSnapshot.hasData) {
                    if (locationSnapshot.data?.size == 0) {
                      return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              heading(title: "No published locations found"),
                            ],
                          ));
                    }
                    return ListView(
                      children: locationSnapshot.data!.docs
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        Location location = Location.fromFirebase(data);
                        // log(data.toString());
                        // if (searchController.text == "") {
                        //   return tabContent(status: "pending");
                        // }
                        return tabContent(location: location);
                        return Container();
                      }).toList(),
                    );
                  }

                  return Container();
                }),
            StreamBuilder(
                stream: firestore
                    .collection(uploadedLocationsCollectionName)
                    .where("uploadedBy",
                        isEqualTo: authentication.currentUser?.uid)
                    .where("status", isEqualTo: "pending")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        locationSnapshot) {
                           if (locationSnapshot.data?.size == 0) {
                      return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              heading(title: "No pending locations found"),
                            ],
                          ));
                    }

                  if (locationSnapshot.hasData) {
                    return ListView(
                      children: locationSnapshot.data!.docs
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        Location location = Location.fromFirebase(data);
                        // log(data.toString());
                        // if (searchController.text == "") {
                        //   return tabContent(status: "pending");
                        // }
                        return tabContent(location: location);
                        return Container();
                      }).toList(),
                    );
                  }

                  return Container();
                }),
            StreamBuilder(
                stream: firestore
                    .collection(uploadedLocationsCollectionName)
                    .where("uploadedBy",
                        isEqualTo: authentication.currentUser?.uid)
                    .where("status", isEqualTo: "declined")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        locationSnapshot) {
                  if (locationSnapshot.hasData) {
                     if (locationSnapshot.data?.size == 0) {
                      return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              heading(title: "No declined locations found"),
                            ],
                          ));
                    }
                    return ListView(
                      children: locationSnapshot.data!.docs
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        Location location = Location.fromFirebase(data);
                        // log(data.toString());
                        // if (searchController.text == "") {
                        //   return tabContent(status: "pending");
                        // }
                        return tabContent(location: location);
                        return Container();
                      }).toList(),
                    );
                  }

                  return Container();
                }),

            // ListView(
            //   children: [tabContent(status: "declined")],
            // ),
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

  Widget tabContent({required Location location}) {
    return GestureDetector(
      onTap: () {
        if (location.status == "published") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPage(location: location),
              ));
        }
      },
      onLongPress: () {
        log("dssdsddssdsdsd");
        if (location.status == "declined") {
          firestore
              .collection(uploadedLocationsCollectionName)
              .doc(location.id)
              .delete();
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: location.imageUrl,
              imageBuilder: (context, imageProvider) => GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationPage(location: location),
                      ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    // child: ,
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.amber,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  ),
                ),
              ),
              placeholder: (context, url) => SkeletonItem(
                  child: Container(
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.25),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                ),

                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.width / 4,
                // width: double.infinity,
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Container(
              // color: Colors.amberAccent,
              width: MediaQuery.of(context).size.width / 1.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading(title: "${location.title} ", fontSize: 15),
                  Text("${location.category}"),
                  Text("${location.location}"),
                  location.status == "published"
                      ? RatingBar.builder(
                          // tapOnlyMode: false,
                          // updateOnDrag: true,
                          ignoreGestures: true,
                          itemSize: 13,
                          initialRating: reviewsAverage(location),
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
                  timeAgoText(cratedAt: location.createdAt),

                  location.status == "declined"
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Wrap(
                            children: [
                              Text(
                                "Declination Reason: ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${location.declinationReason}")
                            ],
                          ),
                        )
                      : Container(),
                  // Te
                  // status == "pending"
                  //     ? Text(
                  //         "Decision Pending",
                  //         style: TextStyle(fontWeight: FontWeight.bold),
                  //       )
                  //     : Container(),
                  // location.status == "declined"
                  //     ? Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Reason: The image provided is too small diohdsiod dsioh dih sdihds oidhio ih oih iohioh io hioh",
                  //             style: TextStyle(fontWeight: FontWeight.bold),
                  //           ),
                  //           Container(
                  //             margin: EdgeInsets.only(top: 5),
                  //             padding: EdgeInsets.all(7),
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(5),
                  //               color: primaryColor,
                  //             ),
                  //             child: Text(
                  //               "Reupload",
                  //               style: TextStyle(color: Colors.white),
                  //             ),
                  //           )
                  //         ],
                  //       )
                  //     : Container(),

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
