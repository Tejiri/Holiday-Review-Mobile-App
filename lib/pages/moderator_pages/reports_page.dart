import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:readmore/readmore.dart';
import 'package:review_app/utils/constants.dart';
import 'package:review_app/controllers/random.dart';
import 'package:review_app/models/report.dart';
import 'package:review_app/models/review.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/custom_widgets/ui_components.dart';

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

                    return Dismissible(
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
                        confirmDismiss: (value) async {
                          var delete;
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you want to delete this comment?"),
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
                                                  Review.fromFirebase(
                                                      value.data() as Map);
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
                                        Navigator.of(context).pop(true);
                                        bottomAlert(
                                            context: context,
                                            isError: false,
                                            title: "Published",
                                            message: (report.commentId == ""
                                                    ? "Review"
                                                    : "Comment") +
                                                " has been deleted successfully");
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
                        },
                        onDismissed: (direction) {},
                        child: GestureDetector(
                          onLongPress: () {
                            bottomSheetSentText(report.reportedMessage);
                          },
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
                                    Icon(
                                      Icons.report,
                                      size: 40,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
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
                                                  report.additionalComment,
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

                    return Container();
                  }).toList(),
                ),
              );
            }

            return Container();
          }),
    );
  }

  bottomSheetSentText(String reportedMessage) {
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
              height: 300,
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  heading(title: "Reported Text"),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(reportedMessage),
                  )
                ],
              ));
        });
  }
}
