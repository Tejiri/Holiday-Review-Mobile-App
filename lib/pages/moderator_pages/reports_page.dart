import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:readmore/readmore.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/controllers/random.dart';
import 'package:review_app/models/Report.dart';
import 'package:review_app/models/review.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/widgets/ui_components.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 201, 195, 195),
      appBar: AppBar(
        title: Text("Reports"),
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
            }
          }),
        ],
      ),
      body: StreamBuilder(
          stream: firestore
              .collection(reportsCollectionName)
              // .where("status", isEqualTo: "published")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                  reportsSnapshot) {
            if (reportsSnapshot.data?.size == 0) {
              return Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      heading(title: "No reports available"),
                    ],
                  ));
            }
            if (reportsSnapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: reportsSnapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    Report report = Report.fromFirebase(data);
                    log(report.message);
                    return Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter sto
                        // uniquely identify widgets.
                        key: UniqueKey(),
                        background: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.only(
                              left: 10, top: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // direction: DismissDirection.startToEnd,
                        // Provide a function that tells the app
                        // what to do after an item has been swiped away.
                        confirmDismiss: (value) async {
                          var delete;
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you wish to delete this comment?"),
                                actions: <Widget>[
                                  ElevatedButton(
                                      onPressed: () {
                                        if (report.commentId == "") {
                                          firestore
                                              .collection(
                                                  uploadedLocationsCollectionName)
                                              .doc(report.locationId)
                                              .collection(reviewsCollectionName)
                                              .doc(report.reviewId)
                                              .get()
                                              .then((value) {
                                            if (value.exists) {
                                              Review review =
                                                  Review.fromFirebase(data);
                                              deleteReview(
                                                  report: report,
                                                  review: review);
                                            } else {
                                              firestore
                                                  .collection(
                                                      reportsCollectionName)
                                                  .doc(report.id)
                                                  .delete();
                                            }

                                            // log(value.data().toString());
                                          });
                                          // deleteReview(report: report);
                                        } else {
                                          firestore
                                              .collection(
                                                  uploadedLocationsCollectionName)
                                              .doc(report.locationId)
                                              .collection(reviewsCollectionName)
                                              .doc(report.reviewId)
                                              .collection(
                                                  commentsCollectionName)
                                              .doc(report.commentId)
                                              .delete()
                                              .then((value) {
                                            firestore
                                                .collection(
                                                    reportsCollectionName)
                                                .doc(document.id)
                                                .delete();
                                          });
                                        }

                                        // firestore
                                        //     .collection(Constants.notificationsName)
                                        //     .doc(FirebaseAuth.instance.currentUser?.uid)
                                        //     .collection(Constants.notificationsName)
                                        //     .doc(documentId)
                                        //     .delete();
                                        // removeCommentFromPost(
                                        //     postId: postId,
                                        //     commentId: commentId,
                                        //     user: senderId);
                                        Navigator.of(context).pop(true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red),
                                      child: const Text("DELETE")),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: primaryColor),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                ],
                              );
                            },
                          );

                          // value = false;

                          // return delete;
                        },
                        onDismissed: (direction) {
                          // log(direction.name);
                          // log(direction.index.toString());
                          // Remove the item from the data source.
                          // setState(() {
                          //   items.removeAt(index);
                          // });

                          // Then show a snackbar.
                          // ScaffoldMessenger.of(context)
                          //     .showSnackBar(SnackBar(content: Text('$item dismissed')));
                        },
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.only(
                                left: 10, top: 10, bottom: 10, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Image.asset(
                                    //   'assets/images/renmiss_logo_2.png',
                                    //   width: 40,
                                    // ),

                                    Icon(
                                      Icons.report,
                                      size: 40,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      // padding: EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                120,
                                            child: Text(
                                              report.reportReason,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                120,
                                            child: Wrap(
                                              children: [
                                                ReadMoreText(
                                                  report.message,
                                                  trimCollapsedText:
                                                      'Read more',
                                                  trimExpandedText: 'Show less',
                                                  trimLines: 1,
                                                  trimMode: TrimMode.Line,
                                                  colorClickableText:
                                                      primaryColor,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                120,
                                            child: Wrap(
                                              children: [
                                                Text(
                                                  report.commentId == ""
                                                      ? "Review"
                                                      : "Comment",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor),
                                                ),
                                                // timeAgoText(
                                                //     cratedAt: report.createdAt),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child:
                                      timeAgoText(cratedAt: report.createdAt),
                                )
                              ],
                            ),
                          ),
                        ));

                    // Location location = Location.fromFirebase(data);
                    // // log(data.toString());
                    // if (searchController.text == "") {
                    //   return singleLocationContainer(location: location);
                    // }
                    // if (location.title
                    //     .toLowerCase()
                    //     .contains(searchController.text.toLowerCase())) {
                    //   return singleLocationContainer(location: location);
                    // }
                    return Container();
                  }).toList(),
                ),
              );
            }

            return Container();
          }),
    );
  }
}
