import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/controllers/random.dart';
import 'package:review_app/models/UserModel.dart';
import 'package:review_app/models/comment.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/models/review.dart';
import 'package:review_app/pages/comments_page.dart';
import 'package:review_app/widgets/form_components.dart';
import 'package:review_app/widgets/location_owner_componenets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:skeletons/skeletons.dart';

const subHeading = TextStyle(fontSize: 15);

Widget heading({required title, double? fontSize, Color? color}) {
  return Text(
    title,
    style: TextStyle(
        fontSize: fontSize ?? 19,
        fontWeight: FontWeight.bold,
        color: color ?? Colors.black),
  );
}

Widget singleReview(
    {required BuildContext context,
    required bool showNumberOfComments,
    required Review review,
    required Location location}) {
  return FutureBuilder(
    future: firestore
        .collection(userCollectionName)
        .doc(review.reviewBy)
        .get()
        .then((value) => value.data() as Map),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SkeletonItem(
          child: Container(
            height: 200,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 0.25),
              borderRadius: BorderRadius.circular(10),
              color: Colors.amber,
            ),
          ),
        );
      }
      if (snapshot.hasData) {
        UserModel userModel = UserModel.fromFirebase(snapshot.data);

        // }
        return Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
          decoration:
              BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      // color: Colors.green,
                      // width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heading(
                              title:
                                  userModel.firstName + " " + userModel.surname,
                              fontSize: 15),
                          RatingBar.builder(
                            ignoreGestures: true,
                            itemSize: 13,
                            initialRating: review.rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                              size: 1,
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Text(
                              review.message,
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              review.createdAt == null
                                  ? Container()
                                  : timeAgoText(cratedAt: review.createdAt),
                              // Text(
                              //   "${timeAgo(review.createdAt).toString()}",
                              //   style: TextStyle(
                              //       color: Color.fromARGB(255, 118, 115, 115)),
                              // ),
                              showNumberOfComments
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentsPage(
                                                location: location,
                                                pinnedReview: review,
                                              ),
                                            ));
                                      },
                                      child: FutureBuilder(
                                        future: firestore
                                            .collection(
                                                uploadedLocationsCollectionName)
                                            .doc(location.id)
                                            .collection(reviewsCollectionName)
                                            .doc(review.id)
                                            .collection(commentsCollectionName)
                                            .get()
                                            .then((value) => value.size),
                                        builder:
                                            (context, commentsCountSnapshot) {
                                          if (commentsCountSnapshot.hasData) {
                                            log(commentsCountSnapshot.data
                                                .toString());
                                            return Text(
                                              "${commentsCountSnapshot.data} comments",
                                              style: TextStyle(
                                                  color: primaryColor),
                                            );
                                          }

                                          return Container();
                                        },
                                      ))
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      color: primaryColor,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        if (location.uploadedBy ==
                            authentication.currentUser?.uid) {
                          showReportCommentWidegt(
                              context: context,
                              location: location,
                              review: review);
                        } else {
                          displayBottomSheetForUserReport(
                              context: context,
                              userToReportId: location.uploadedBy,
                              locationId: location.id,
                              commentId: "",
                              reviewId: review.id);
                        }
                      },
                      icon: Icon(Icons.report))
                ],
              ),

              StreamBuilder(
                  stream: firestore
                      .collection(uploadedLocationsCollectionName)
                      .doc(location.id)
                      .collection(reviewsCollectionName)
                      .doc(review.id)
                      .collection(commentsCollectionName)
                      .where("commentBy", isEqualTo: location.uploadedBy)
                      .limit(1)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          businessOwnerReplySnapshot) {
                    if (businessOwnerReplySnapshot.hasData) {
                      // log(businessOwnerReplySnapshot.data.docs.)
                      if (businessOwnerReplySnapshot.data?.size != 0) {
                        Comment comment = Comment.fromFirebase(
                            businessOwnerReplySnapshot.data?.docs.first.data()
                                as Map<dynamic, dynamic>);
                        // log(snapshot.data.toString());
                        return Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Icons.reply),
                                  ),
                                  heading(
                                      title: "Business Owner response",
                                      fontSize: 14)
                                ],
                              ),
                              Text(
                                comment.message,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }

                    return Container();
                  })

              // FutureBuilder(
              //   future: firestore
              //       .collection(uploadedLocationsCollectionName)
              //       .doc(location.id)
              //       .collection(reviewsCollectionName)
              //       .doc(review.id)
              //       .collection(commentsCollectionName)
              //       .where("commentBy", isEqualTo: location.uploadedBy)
              //       .limit(1)
              //       .get()
              //       .then((value) => value.docs.first.data()),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //        }
              //     return Container();
              //   },
              // )
            ],
          ),
        );
      }
      return Container();
    },
  );
}

middleAlert(
    {required BuildContext context,
    required String type,
    required String? title,
    required String? desc}) {
  return Alert(
    context: context,
    type: type == "success" ? AlertType.success : AlertType.error,
    title: title,
    desc: desc,
    buttons: [
      DialogButton(
        child: Text(
          "Okay",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

bottomAlert(
    {required BuildContext context,
    String? title,
    String? message,
    required bool isError}) {
  return Flushbar(
    icon: Icon(
      Icons.info,
      color: Colors.white,
    ),
    backgroundColor: isError ? Colors.red : Colors.green,
    // maxWidth: ,
    borderRadius: BorderRadius.circular(10),
    margin: EdgeInsets.all(20),
    title: title,
    message: message,
    duration: Duration(seconds: 2),
  )..show(context);
}

displayBottomSheetForUserReport(
    {required context,
    required userToReportId,
    required locationId,
    required commentId,
    required reviewId}) {
  showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      elevation: 50,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          margin: EdgeInsets.all(20),
          // padding: EdgeInsets.only( top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Padding(padding: EdgeInsets.only(top: 10)),

              Text(
                'Report ${commentId == "" ? "Review" : "Comment"}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: primaryColor),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Reason for report',
                  style: TextStyle(fontSize: 14),
                ),
              ),

              Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              reportReason(
                context: context,
                reportReason: 'Violence',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Nudity',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Harrassment',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Spam',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Hate Speech',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Fraud',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),

              reportReason(
                context: context,
                reportReason: 'False Information',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Bullying',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Just don\'t like it',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),
              reportReason(
                context: context,
                reportReason: 'Something else',
                userToReportId: userToReportId,
                commentId: commentId,
                locationId: locationId,
                reviewId: reviewId,
              ),

              // Padding(padding: EdgeInsets.only(bottom: 10))
              // TextField(
              //   decoration: InputDecoration(
              //       hintText: 'Any additional infomation?',
              //       label: Text('Additional information')),
              // )
            ],
          ),
        );
      });
}

Widget reportReason(
    {required context,
    required reportReason,
    required userToReportId,
    required locationId,
    required reviewId,
    required commentId}) {
  // required additionalComment,
  // required postByUserId,
  // required reportReason,

  TextEditingController additionalComment = TextEditingController();
  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                  title: Text(
                    'Additional Comment?',
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: additionalComment,
                      ),
                      GestureDetector(
                        onTap: () {
                          reportUser(
                            additionalComment: additionalComment.text,
                            postByUserId: userToReportId,
                            reportReason: reportReason,
                            commentId: commentId,
                            locationId: locationId,
                            reviewId: reviewId,
                          );

                          additionalComment.text = '';
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // Navigator.pop(context);
                          // Navigator.pop(context);
                          bottomAlert(
                              context: context,
                              title: "Success",
                              message: 'Report sent successfully',
                              isError: false);
                        },
                        child: customButton(
                            context: context, text: 'Submit', isLoading: false),
                      )
                    ],
                  ))));
    },
    child: Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5))),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(reportReason), Icon(Icons.arrow_forward_ios)],
      ),
    ),
  );
}

reportUser(
    {required additionalComment,
    required postByUserId,
    required reportReason,
    required locationId,
    required reviewId,
    required commentId}) {
  firestore.collection(reportsCollectionName).add({
    'message': additionalComment,
    'reportedById': authentication.currentUser?.uid,
    'reportedId': postByUserId,
    'locationId': locationId,
    'reviewId': reviewId,
    'commentId': commentId,
    'reportReason': reportReason,
    'createdAt': FieldValue.serverTimestamp(),
    'reportStatus': 'pending'
  }).then((value) {
    value.update({"id": value.id});
  });
}

showReportCommentWidegt({
  required BuildContext context,
  Comment? comment,
  required Review review,
  required Location location,
}) {
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
                    Navigator.pop(context);
                    displayBottomSheetForUserReport(
                        context: context,
                        userToReportId: comment == null
                            ? review.reviewBy
                            : comment.commentBy,
                        locationId: location.id,
                        commentId: comment == null ? "" : comment.id,
                        reviewId: review.id);
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.2))),
                    child: Text(
                      'Report',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    firestore
                        .collection(uploadedLocationsCollectionName)
                        .doc(location.id)
                        .collection(reviewsCollectionName)
                        .doc(review.id)
                        .collection(commentsCollectionName)
                        .where("commentBy",
                            isEqualTo: authentication.currentUser?.uid)
                        .limit(1)
                        .get()
                        .then((value) {
                      Navigator.pop(context);
                      if (value.docs.isNotEmpty) {
                        Comment comment = Comment.fromFirebase(
                            value.docs.first.data() as Map<dynamic, dynamic>);
                        showReplyReview(
                            context: context,
                            replyExists: true,
                            location: location,
                            review: review,
                            comment: comment);
                      } else {
                        showReplyReview(
                          context: context,
                          replyExists: false,
                          location: location,
                          review: review,
                        );
                      }

                      // log(value.docs.first.data().toString());
                    });
                    // Navigator.pop(context);
                    // FutureBuilder(
                    //   future: firestore
                    //       .collection(uploadedLocationsCollectionName)
                    //       .doc(location.id)
                    //       .collection(reviewsCollectionName)
                    //       .doc(review.id)
                    //       .collection(commentsCollectionName)
                    //       .where("commentBy",
                    //           isEqualTo: authentication.currentUser?.uid)
                    //       .limit(1)
                    //       .get()
                    //       .then((value) => value.docs.first.data()),
                    //   builder: (context, snapshot) {
                    //     log("disjdodsopdsjdsjsodjsdopjp");
                    //     if (snapshot.hasData) {
                    //       log(snapshot.data.toString());

                    //     }
                    //     return Container();
                    //   },
                    // );
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    // padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.2))),
                    child: Text(
                      'Reply Review',
                      // style: TextStyle(color: greenRenMissColor),
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
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
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
