import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/controllers/random.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/models/review.dart';
import 'package:review_app/pages/comments_page.dart';
import 'package:review_app/providers/UserRatingProvider.dart';
import 'package:review_app/widgets/ui_components.dart';
import 'package:skeletons/skeletons.dart';

class LocationPage extends StatefulWidget {
  Location location;

  LocationPage({super.key, required this.location});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController reviewComment = TextEditingController();
  // double rating = 3.0;
  var reviewsStream;
  var averageRatingStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reviewsStream = firestore
        .collection(uploadedLocationsCollectionName)
        .doc(widget.location.id)
        .collection(reviewsCollectionName)
        .orderBy("createdAt", descending: true)
        .limit(5)
        .snapshots();

    averageRatingStream = firestore
        .collection(uploadedLocationsCollectionName)
        .doc(widget.location.id)
        .snapshots();
    log(widget.location.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.location.title),
        actions: [
          IconButton(
              onPressed: () {
                showBottomSheet();
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.location.imageUrl,
                imageBuilder: (context, imageProvider) => Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider))),
                placeholder: (context, url) => SkeletonItem(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3.5,
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
                child: Container(
                  padding: EdgeInsets.only(
                    top: 55,
                  ),
                  // height: 200,

                  // color: Colors.amber,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration:
                            BoxDecoration(border: Border(bottom: BorderSide())),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              heading(title: "5 recent reviews", fontSize: 15),
                              heading(
                                  title: "view all reviews",
                                  fontSize: 15,
                                  color: primaryColor),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            setState(() {});
                            return;
                          },
                          child: StreamBuilder(
                              stream: reviewsStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      locationSnapshot) {
                                if (locationSnapshot.hasData) {
                                  // var size =  locationSnapshot.data?.size.toString();
                                  // log(size.toString());
                                  if (locationSnapshot.data?.size == 0) {
                                    return Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: heading(
                                            title: "No reviews available"));
                                  }
                                  // if (locationSnapshot.data?.docs.length != null) {

                                  //   }
                                  return SingleChildScrollView(
                                    child: ListView(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      children: locationSnapshot.data!.docs
                                          .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;
                                        Review review =
                                            Review.fromFirebase(data);

                                        return singleReview(
                                            context: context,
                                            location: widget.location,
                                            review: review,
                                            showNumberOfComments: true);
                                      }).toList(),
                                    ),
                                  );
                                }

                                return Container();
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 100,
                width: MediaQuery.of(context).size.width / 1.2,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3.5 - 50,
                ),
                decoration: BoxDecoration(
                  color: darkBlueGray,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(4.0, 5.0), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heading(title: widget.location.title),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        widget.location.location,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    StreamBuilder(
                        stream: averageRatingStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                averageRatingSnapshot) {
                          if (averageRatingSnapshot.hasData) {
                            Location averageForLocation = Location.fromFirebase(
                                averageRatingSnapshot.data?.data() as Map);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBar.builder(
                                  ignoreGestures: true,
                                  itemSize: 15,
                                  initialRating:
                                      reviewsAverage(averageForLocation),
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
                                Text(
                                    " (${reviewsAverage(averageForLocation).toStringAsFixed(2)})")
                              ],
                            );
                          }

                          return Container();
                        })
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            if (authentication.currentUser?.uid == widget.location.uploadedBy) {
              bottomAlert(
                  context: context,
                  isError: true,
                  title: "Review Failed",
                  message: "Cannot send review on your uploaded location");
            } else {
              firestore
                  .collection(uploadedLocationsCollectionName)
                  .doc(widget.location.id)
                  .collection(reviewsCollectionName)
                  .where("reviewBy", isEqualTo: authentication.currentUser?.uid)
                  .limit(1)
                  .get()
                  .then((userPreviousReview) {
                     var previousRating;
                if (userPreviousReview.size != 0) {
                  Review userReview =
                      Review.fromFirebase(userPreviousReview.docs.first.data());
                 previousRating = userReview.rating;
                  Provider.of<userRatingProvider>(context, listen: false)
                      .rating = userReview.rating;

                  reviewComment.text = userReview.message;
                } else {}
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Leave Review"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "Your review is valued to us to validate the authenticity of locations"),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: RatingBar.builder(
                            itemSize: 40,
                            initialRating: Provider.of<userRatingProvider>(
                                    context,
                                    listen: false)
                                .rating,
                            minRating: 0,
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
                            onRatingUpdate: (currentRating) {
                              Provider.of<userRatingProvider>(context,
                                      listen: false)
                                  .updateUserRatingProvider(currentRating);
                            },
                          ),
                        ),
                        Container(
                            // color: Colors.amberAccent,
                            child: TextField(
                          controller: reviewComment,
                          decoration: InputDecoration(
                              label: Text("Comment"),
                              hintText: "Enter comment"),
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
                                sendReview(
                                  previousRating: previousRating,
                                    reviewId: userPreviousReview.size == 0
                                        ? null
                                        : userPreviousReview.docs.first.id,
                                    location: widget.location,
                                    newReview: userPreviousReview.size == 0
                                        ? true
                                        : false,
                                    reviewComment: reviewComment.text,
                                    userRating: Provider.of<userRatingProvider>(
                                            context,
                                            listen: false)
                                        .rating);
                                reviewComment.text = "";
                                Navigator.pop(context);
                                Provider.of<userRatingProvider>(context,
                                        listen: false)
                                    .updateUserRatingProvider(3.0);
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
                  ),
                );
              });
            }
          },
          child: Icon(Icons.reviews)),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // height: 50,
                  // color: Colors.black,
                  // margin: EdgeInsets.only(top: 20,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [heading(title: "Description")],
                  ),
                ),
                Container(
                  height: 200,
                  child: Text(widget.location.description),
                )
              ],
            ),
          );
        });
  }
}
