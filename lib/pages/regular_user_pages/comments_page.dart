import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/models/comment.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/models/review.dart';
import 'package:review_app/custom_widgets/ui_components.dart';

class CommentsPage extends StatefulWidget {
  Review pinnedReview;
  Location location;

  CommentsPage({super.key, required this.pinnedReview, required this.location});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool showReview = true;
  TextEditingController commentController = TextEditingController();
  var commentsStream;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentsStream = firestore
        .collection(uploadedLocationsCollectionName)
        .doc(widget.location.id)
        .collection(reviewsCollectionName)
        .doc(widget.pinnedReview.id)
        .collection(commentsCollectionName)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (_scrollController.hasClients) {
      //  ScrollController _scrollController = new ScrollController();
      // _scrollController.animateTo(
      //     duration: Duration(milliseconds: 350), curve: curve);
      // .animateToPage(
      //     widget.currentSlide,
      //     duration: Duration(milliseconds: 350),
      //     curve: Curves.easeIn,
      //   );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        elevation: 0,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                if (showReview) {
                  setState(() {
                    showReview = false;
                  });
                } else {
                  setState(() {
                    showReview = true;
                  });
                }

                // showBottomSheet();
              },
              icon: Icon(Icons.pin_end))
        ],
      ),
      body: Column(
        children: [
          showReview
              ? singleReview(
                  location: widget.location,
                  review: widget.pinnedReview,
                  context: context,
                  showNumberOfComments: false)
              : Container(),
          // : Container(),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder(
                  stream: commentsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          commentsSnapshot) {
                    if (commentsSnapshot.hasData) {
                      // var size =  locationSnapshot.data?.size.toString();
                      // log(size.toString());
                      if (commentsSnapshot.data?.size == 0) {
                        return Container(
                            margin: EdgeInsets.only(top: 10),
                            child: heading(title: "No comments available"));
                      }
                      // if (locationSnapshot.data?.docs.length != null) {

                      //   }
                      return ListView(
                        controller: _scrollController,
                        reverse: true,
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: commentsSnapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          Comment comment = Comment.fromFirebase(data);
                          if (comment.createdAt == null) {
                            return Container();
                          }
                          if (comment.commentBy == widget.location.uploadedBy) {
                            return Container();
                          }
                          return commentWidget(
                              myMessage: comment.commentBy ==
                                  authentication.currentUser?.uid,
                              comment: comment);
                        }).toList(),
                      );
                    }

                    return Container();
                  }),
            ),
          ),
          widget.location.uploadedBy == authentication.currentUser?.uid
              ? Container()
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            border: Border.all(),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1.0, 3.0), //(x,y)
                                blurRadius: 3.0,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: commentController,
                            decoration: InputDecoration(
                                hintText: "Type your comment here",
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          
                          if (commentController.text.trim() == "") {
                            bottomAlert(
                                context: context,
                                isError: true,
                                title: "Error",
                                message: "Comment Field cannot be empty");
                          } else {
                            firestore
                                .collection(uploadedLocationsCollectionName)
                                .doc(widget.location.id)
                                .collection(reviewsCollectionName)
                                .doc(widget.pinnedReview.id)
                                .collection(commentsCollectionName)
                                .add({
                              "createdAt": FieldValue.serverTimestamp(),
                              "message": commentController.text,
                              "commentBy": authentication.currentUser?.uid
                            }).then((value) => value.update({"id": value.id}));
                          }
                          if (_scrollController.hasClients) {
                            _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                            );
                            commentController.text = "";
                          }
                        },
                        child: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Icon(
                              Icons.send,
                              color: lightBlueGray,
                            )),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }

  Widget commentWidget({required bool myMessage, required Comment comment}) {
    return Row(
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment:
                myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () {
                  displayBottomSheetForUserReport(
                      context: context,
                      userToReportId: comment.commentBy,
                      locationId: widget.location.id,
                      commentId: comment.id,
                      reviewId: widget.pinnedReview.id);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: myMessage ? primaryColor : Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    comment.message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              timeAgoText(cratedAt: comment.createdAt),
            ],
          ),
        )
      ],
    );
  }

  Widget otherMessages() {
    return Container();
  }
}
