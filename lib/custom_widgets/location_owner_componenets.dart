import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:review_app/utils/constants.dart';
import 'package:review_app/models/comment.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/models/review.dart';

showReplyReview({
  required BuildContext context,
  required bool replyExists,
  required Location location,
  required Review review,
  Comment? comment,
}) {
  TextEditingController reviewReplyController = TextEditingController();
  if (comment !=  null) {
     reviewReplyController.text = comment.message;
  }
 
  return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
                title: Text("Reply Review"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(
                    //     "Your review is valued to us to validate the authenticity of locations"),
                    Container(
                        // color: Colors.amberAccent,
                        child: TextField(
                      controller: reviewReplyController,
                      decoration: InputDecoration(
                          label: Text("Comment"), hintText: "Enter comment"),
                    ))
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.grey[200],
                            height: 30,
                            child: Center(
                                child: Text(
                              "Cancel",
                            )),
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5, right: 5)),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (replyExists) {
                              firestore
                                  .collection(uploadedLocationsCollectionName)
                                  .doc(location.id)
                                  .collection(reviewsCollectionName)
                                  .doc(review.id)
                                  .collection(commentsCollectionName)
                                  .doc(comment?.id)
                                  .update(
                                      {"message": reviewReplyController.text});
                              setState(
                                () {},
                              );
                            } else {
                              //  Comment comment =
                              firestore
                                  .collection(uploadedLocationsCollectionName)
                                  .doc(location.id)
                                  .collection(reviewsCollectionName)
                                  .doc(review.id)
                                  .collection(commentsCollectionName)
                                  .add(Comment(
                                          createdAt:
                                              FieldValue.serverTimestamp(),
                                          id: "",
                                          message: reviewReplyController.text,
                                          commentBy:
                                              authentication.currentUser!.uid)
                                      .toMap())
                                  .then((value) {
                                value.update({"id": value.id});
                              });
                            }

                            Navigator.pop(context);

                            // replyExists
                            //     ?
                            //     :

                            // log(rating.toString());
                            // log(reviewComment.text.toString());
                          },
                          child: Container(
                            color: darkBlueGray,
                            height: 30,
                            child: Center(
                                child: Text(
                              "Send",
                            )),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )));
}
