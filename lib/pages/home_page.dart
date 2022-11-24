import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/pages/location_page.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/pages/reviews_page.dart';
import 'package:review_app/pages/settings_page.dart';
import 'package:review_app/widgets/ui_components.dart';
import 'package:skeletons/skeletons.dart';
// import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon cusIcon = Icon(Icons.search);
  Widget cusSearchBar = const Text(
    "Regional App",
    style: TextStyle(color: Colors.white, fontSize: 16.0),
  );
  var nameToSearch = '';
  TextEditingController searchController = TextEditingController();
  late FocusNode focusUserSearch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusUserSearch = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: cusSearchBar,
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          leading: Container(),
          actions: [
            IconButton(
                icon: cusIcon,
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      if (cusIcon.icon == Icons.search) {
                        cusIcon = Icon(Icons.cancel);
                        cusSearchBar = TextField(
                          focusNode: focusUserSearch,
                          controller: searchController,
                          onChanged: (value) async {
                            nameToSearch = value;

                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: "Search",
                              border: InputBorder.none),
                          textInputAction: TextInputAction.go,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
                        );

                        // setState(() {});
                        focusUserSearch.requestFocus();
                      } else {
                        cusIcon = Icon(Icons.search);
                        nameToSearch = '';
                        searchController.text = '';
                        setState(() {});
                        cusSearchBar = const Text(
                          "RenMiss Chat",
                          style: TextStyle(color: Colors.white),
                        );
                      }
                    });
                  }
                }),

            PopupMenuButton(
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Filter Search"),
                ),

                // PopupMenuItem<int>(
                //   value: 1,
                //   child: Text("Settings"),
                // ),
                // PopupMenuItem<int>(
                //   value: 1,
                //   child: Text("Settings"),
                // ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Logout"),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                showBottomSheet();
                // print("My account menu is selected.");
              }

              // else if (value == 1) {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => SettingsPage(),
              //       ));
              // }

              else if (value == 1) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false);
              }
            }),
            // IconButton(
            //     onPressed: () {

            //     }, icon: Icon(Icons.more_vert))
          ],
        ),
        body: StreamBuilder(
            stream: firestore
                .collection(uploadedLocationsCollectionName)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    locationSnapshot) {
              if (locationSnapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: locationSnapshot.data!.docs
                        .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      Location location = Location.fromFirebase(data);
                      // log(data.toString());
                      if (searchController.text == "") {
                        return singleLocationContainer(location: location);
                      }
                      if (location.title
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase())) {
                        return singleLocationContainer(location: location);
                      }
                      return Container();
                    }).toList(),
                  ),
                );
              }

              return Container();
            })

        //  ListView(
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.all(10.0),
        //       child: Column(
        //         children: [
        //           singleLocationContainer(),
        //           singleLocationContainer(),
        //           singleLocationContainer(),
        //           singleLocationContainer(),
        //           singleLocationContainer(),
        //           singleLocationContainer(),
        //         ],
        //       ),
        //     )
        //   ],
        // ),

        );
  }

  Widget singleLocationContainer({required Location location}) {
    // log(imageUrl);
    return CachedNetworkImage(
      imageUrl: location.imageUrl,
      imageBuilder: (context, imageProvider) => GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPage(locationId: location.id),
              ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              // height: 250,
              child: Column(
                children: [
                  ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: imageProvider
                              // AssetImage(
                              //   "assets/images/placeholder.jpg",
                              // )
                              )),
                      height: 250,
                      child: Align(
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Container(
                    // height: 50,
                    decoration: BoxDecoration(color: lightBlueGray),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                heading(title: location.title),
                                Text(
                                  "${location.category + ' - ' + location.location}",
                                  style: subHeading,
                                ),

                                Row(
                                  children: [
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      updateOnDrag: false,
                                      itemSize: 15,
                                      initialRating: location.ratingsAverage,
                                      // minRating: 1,
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
                                      " (${location.ratingsSize} reviews)",
                                      style: subHeading,
                                    ),
                                  ],
                                )

                                // // Text("Abuja")
                              ],
                            ),
                          ),
                          Wrap(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    // Share.share(
                                    //     'check out my website https://example.com',
                                    //     subject: 'Look what I made!');
                                  },
                                  icon: Icon(Icons.share)),
                              IconButton(
                                  onPressed: () {
                                    // Share.share(
                                    //     'check out my website https://example.com',
                                    //     subject: 'Look what I made!');
                                  },
                                  icon: Icon(Icons.favorite_border))
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),

      // Container(
      //   margin: EdgeInsets.only(bottom: 20),
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     border: Border.all(width: 0.25),
      //     borderRadius: BorderRadius.circular(10),
      //     image: DecorationImage(
      //       image: imageProvider,
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
      placeholder: (context, url) => SkeletonItem(
          child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          border: Border.all(width: 0.25),
          borderRadius: BorderRadius.circular(10),
          color: Colors.amber,
        ),

        height: 300,
        width: MediaQuery.of(context).size.width,
        // width: double.infinity,
      )),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
    // return GestureDetector(
    //   onTap: () {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => LocationPage(),
    //         ));
    //   },
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(15),
    //     child: Container(
    //         margin: EdgeInsets.only(bottom: 20),
    //         decoration: BoxDecoration(
    //           color: primaryColor,
    //         ),
    //         // height: 250,
    //         child: Column(
    //           children: [
    //             ClipRRect(
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     color: primaryColor,
    //                     image: DecorationImage(
    //                         fit: BoxFit.cover,
    //                         image: AssetImage(
    //                           "assets/images/placeholder.jpg",
    //                         ))),
    //                 height: 250,
    //                 child: Align(
    //                   alignment: Alignment.bottomRight,

    //                   // GestureDetector(
    //                   //   onTap: () => Navigator.push(
    //                   //       context,
    //                   //       MaterialPageRoute(
    //                   //         builder: (context) => ReviewsPage(),
    //                   //       )),
    //                   //   child: ClipRRect(
    //                   //     child: Container(
    //                   //         decoration: BoxDecoration(
    //                   //             color: secondaryColor,
    //                   //             borderRadius: BorderRadius.only(
    //                   //                 topLeft: Radius.circular(15))),
    //                   //         padding: EdgeInsets.all(7),
    //                   //         child: heading(title: "Leave Review")),
    //                   //   ),
    //                   // ),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               // height: 50,
    //               decoration: BoxDecoration(color: lightBlueGray),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: Row(
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.stretch,
    //                         children: [
    //                           heading(title: "This is the title"),
    //                           Text(
    //                             "Restaurant - Abuja",
    //                             style: subHeading,
    //                           ),

    //                           Row(
    //                             children: [
    //                               RatingBar.builder(
    //                                 itemSize: 15,
    //                                 initialRating: 3,
    //                                 minRating: 1,
    //                                 direction: Axis.horizontal,
    //                                 allowHalfRating: true,
    //                                 itemCount: 5,
    //                                 // itemPadding:
    //                                 //     EdgeInsets.symmetric(horizontal: 4.0),
    //                                 itemBuilder: (context, _) => Icon(
    //                                   size: 1,
    //                                   Icons.star,
    //                                   color: Colors.amber,
    //                                 ),
    //                                 onRatingUpdate: (rating) {
    //                                   print(rating);
    //                                 },
    //                               ),
    //                               Text(
    //                                 " (3 reviews)",
    //                                 style: subHeading,
    //                               ),
    //                             ],
    //                           )

    //                           // // Text("Abuja")
    //                         ],
    //                       ),
    //                     ),
    //                     Wrap(
    //                       children: [
    //                         IconButton(
    //                             onPressed: () {
    //                               // Share.share(
    //                               //     'check out my website https://example.com',
    //                               //     subject: 'Look what I made!');
    //                             },
    //                             icon: Icon(Icons.share)),
    //                         IconButton(
    //                             onPressed: () {
    //                               // Share.share(
    //                               //     'check out my website https://example.com',
    //                               //     subject: 'Look what I made!');
    //                             },
    //                             icon: Icon(Icons.favorite_border))
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             )
    //           ],
    //         )),
    //   ),
    // );
  }

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
                color: Colors.transparent,
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      child: const Icon(
                        Icons.arrow_back,
                        // color: Constants.primaryColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    heading(title: "  Filter result")
                  ],
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
