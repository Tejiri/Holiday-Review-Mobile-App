import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/pages/comments_page.dart';
import 'package:review_app/widgets/ui_components.dart';

class LocationPage extends StatefulWidget {
  String locationId;

  LocationPage({super.key, required this.locationId});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController reviewComment = TextEditingController();
  double rating = 3.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Ratings"),
        actions: [
          IconButton(
              onPressed: () {
                showBottomSheet();
              },
              icon: Icon(Icons.info))

          // PopupMenuButton(
          //     // add icon, by default "3 dot" icon
          //     // icon: Icon(Icons.book)
          //     itemBuilder: (context) {
          //   return [
          //     PopupMenuItem<int>(
          //       value: 0,
          //       child: Text("Filter Search"),
          //     ),
          //     // PopupMenuItem<int>(
          //     //   value: 1,
          //     //   child: Text("Settings"),
          //     // ),
          //     PopupMenuItem<int>(
          //       value: 1,
          //       child: Text("Logout"),
          //     ),
          //   ];
          // }, onSelected: (value) {
          //   if (value == 0) {
          //     showBottomSheet();
          //     // print("My account menu is selected.");
          //   } else if (value == 1) {
          //     // Navigator.pushAndRemoveUntil(
          //     //     context,
          //     //     MaterialPageRoute(
          //     //       builder: (context) => LoginPage(),
          //     //     ),
          //     //     (route) => false);
          //   }
          // }),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 3.5,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/placeholder.jpg"))),

                // child: SafeArea(
                //   child:
                //   Align(
                //     alignment: Alignment.topLeft,
                //     child: Padding(
                //       padding: const EdgeInsets.all(10),
                //       child: Container(
                //         color: lightBlueGray,
                //         child: Icon(Icons.arrow_back, color: Colors.red)),
                //     ),
                //   ),
                // ),
                // child: Image.asset("assets/images/placeholder.jpg"),
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
                              heading(title: "5 recent ratings", fontSize: 15),
                              heading(
                                  title: "view all ratings",
                                  fontSize: 15,
                                  color: primaryColor),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: ListView(
                          children: [
                            singleReview(
                                context: context, showNumberOfComments: true),
                            singleReview(
                                context: context, showNumberOfComments: true),
                            singleReview(
                                context: context, showNumberOfComments: true),
                            singleReview(
                                context: context, showNumberOfComments: true),
                            singleReview(
                                context: context, showNumberOfComments: true)
                          ],
                        ),
                      ))
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
                    heading(title: "This is the title"),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        "Abuja, Nigeria",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    RatingBar.builder(
                      // tapOnlyMode: false,
                      // updateOnDrag: true,
                      ignoreGestures: true,
                      itemSize: 15,
                      initialRating: rating,
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
                    ),
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
                      // color: Colors.amberAccent,
                      child: RatingBar.builder(
                        // tapOnlyMode: false,
                        // updateOnDrag: true,
                        // ignoreGestures: true,
                        itemSize: 40,
                        initialRating: rating,
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
                      ),
                    ),
                    Container(
                        // color: Colors.amberAccent,
                        child: TextField(
                      controller: reviewComment,
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
                            // log(rating.toString());
                            // log(reviewComment.text.toString());

                            // firestore
                            //     .collection(uploadedLocationsCollectionName)
                            //     .doc(widget.locationId)
                            //     .collection(reviewsCollectionName)
                            //     .add();
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
          },
          child: Icon(Icons.reviews)),
    );
  }

  // Widget singleReview() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 10),
  //     padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
  //     decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CircleAvatar(),
  //         Expanded(
  //           child: Container(
  //             margin: EdgeInsets.only(left: 10),
  //             // color: Colors.green,
  //             // width: 150,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 heading(title: "Username", fontSize: 15),
  //                 RatingBar.builder(
  //                   // tapOnlyMode: false,
  //                   // updateOnDrag: true,
  //                   ignoreGestures: true,
  //                   itemSize: 13,
  //                   initialRating: 3,
  //                   minRating: 1,
  //                   direction: Axis.horizontal,
  //                   allowHalfRating: true,
  //                   itemCount: 5,
  //                   // itemPadding:
  //                   //     EdgeInsets.symmetric(horizontal: 4.0),
  //                   itemBuilder: (context, _) => Icon(
  //                     size: 1,
  //                     Icons.star,
  //                     color: Colors.amber,
  //                   ),
  //                   onRatingUpdate: (rating) {
  //                     print(rating);
  //                   },
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 5, bottom: 5),
  //                   child: Text(
  //                     "didsidni dsodsj sdoo sd osdj oopds jopjojs odsjosd jpd dsijdsio ij disd jiosdjio djioi oi idsojsd ioido idsojo djiod osidio oiio jsdio sjdoij",
  //                     style: TextStyle(fontSize: 13),
  //                   ),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       "3 days ago",
  //                       style: TextStyle(
  //                           color: Color.fromARGB(255, 118, 115, 115)),
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => CommentsPage(),
  //                             ));
  //                       },
  //                       child: Text(
  //                         "4 comments",
  //                         style: TextStyle(color: primaryColor),
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  showBottomSheet() {
    // showBottomSheet()

    // SafeArea(child: )
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // height: 50,
                // color: Colors.black,
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [heading(title: "Description")],
                ),
              ),

              Container(
                height: 200,
              )
              // Expanded(child: StatefulBuilder(
              //     builder: (BuildContext content, StateSetter setState) {
              //   return Container(
              //     // decoration: BoxDecoration(image: primaryColor),
              //       );
              // })

              // )
            ],
          );
        });
  }
}
