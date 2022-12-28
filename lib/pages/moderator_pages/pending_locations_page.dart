import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/widgets/form_components.dart';
import 'package:review_app/widgets/ui_components.dart';
import 'package:skeletons/skeletons.dart';

class PendingLocationsPage extends StatefulWidget {
  const PendingLocationsPage({super.key});

  @override
  State<PendingLocationsPage> createState() => _PendingLocationsPageState();
}

class _PendingLocationsPageState extends State<PendingLocationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Locations"),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
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
              // showBottomSheet();
              // print("My account menu is selected.");
            }
          }),
        ],
      ),
      body: StreamBuilder(
          stream: firestore
              .collection(uploadedLocationsCollectionName)
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
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: locationSnapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    Location location = Location.fromFirebase(data);
                    return singlePendingLocation(location);
                  }).toList(),
                ),
              );
            }

            return Container();
          }),
    );
  }

  Widget singlePendingLocation(Location location) {
    return GestureDetector(
      onTap: () {
        bottomSheetLocationDescription(location);
      },
      onLongPress: () {
        openModeratorDecisionDialog(location);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: secondaryColor, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.pending),
                ),
                Text(location.title.toString().length > 15
                    ? location.title.substring(0, 14) + "..."
                    : location.title)
              ],
            ),
            timeAgoText(cratedAt: location.createdAt)
            // Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }

  bottomSheetLocationDescription(Location location) {
    // showBottomSheet()

    // SafeArea(child: )
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: heading(title: location.title),
                // ),
                CachedNetworkImage(
                  imageUrl: location.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                      height: 250,
                      // width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider))),
                  placeholder: (context, url) => SkeletonItem(
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.25),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),

                Expanded(
                  // height: 50,
                  // color: Colors.amber,
                  // padding: EdgeInsets.only(left: 20),
                  // margin: EdgeInsets.only(top: 20, left: 20),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: ListView(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        // timeAgoText(cratedAt: location.createdAt),
                        // location.

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                heading(title: "Location"),
                                Text(
                                  location.location,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 103, 100, 100),
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                heading(title: "Category"),
                                Text(
                                  location.category,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 103, 100, 100),
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                heading(title: "Time Ago"),
                                timeAgoText(
                                    cratedAt: location.createdAt,
                                    color: Color.fromARGB(255, 103, 100, 100),
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                                //      Text(

                                //   style: TextStyle(
                                //     color:Color.fromARGB(255, 103, 100, 100),
                                //      fontSize: 15),
                                // ),
                              ],
                            )
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),

                        Text(
                          location.title,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Decription",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),

                        Text(
                          location.description,
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded(child: StatefulBuilder(
                //     builder: (BuildContext content, StateSetter setState) {
                //   return Container(
                //     // decoration: BoxDecoration(image: primaryColor),
                //       );
                // })

                // )
              ],
            ),
          );
        });
  }

  openModeratorDecisionDialog(Location location) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              // width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      firestore
                          .collection(uploadedLocationsCollectionName)
                          .doc(location.id)
                          .update({
                        "status": "published",
                        "publishedAt": FieldValue.serverTimestamp()
                      });
                      Navigator.pop(context);
                      bottomAlert(
                          context: context,
                          isError: false,
                          title: "Published",
                          message: "Location has been published");
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.2))),
                      child: Text(
                        // isBlocked ? 'Unblock' :
                        'Publish',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      TextEditingController declinationReason =
                          TextEditingController();
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Declination Reason"),
                          content: TextField(controller: declinationReason),
                          actions: [
                            customButton(
                              textColor: Colors.white,
                              color: primaryColor,
                              context: context,
                              text: "Decline",
                              onTap: () {
                                firestore
                                    .collection(uploadedLocationsCollectionName)
                                    .doc(location.id)
                                    .update({
                                  "declinationReason": declinationReason.text,
                                  "status": "declined"
                                });
                                Navigator.pop(context);
                                bottomAlert(
                                    context: context,
                                    isError: false,
                                    title: "Declined",
                                    message: "Location has been declined");
                              },
                            )
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Text(
                        "Decline",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      // padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.2))),
                      child: Text(
                        'Cancel',
                        // style: TextStyle(color: greenRenMissColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
