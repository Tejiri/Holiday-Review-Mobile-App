import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/pages/comments_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
    {required BuildContext context, required bool showNumberOfComments}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    heading(title: "Username", fontSize: 15),
                    RatingBar.builder(
                      // tapOnlyMode: false,
                      // updateOnDrag: true,
                      ignoreGestures: true,
                      itemSize: 13,
                      initialRating: 3,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        "didsidni dsodsj sdoo sd osdj oopds jopjojs odsjosd jpd dsijdsio ij disd jiosdjio djioi oi idsojsd ioido idsojo djiod osidio oiio jsdio sjdoij",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "3 days ago",
                          style: TextStyle(
                              color: Color.fromARGB(255, 118, 115, 115)),
                        ),
                        showNumberOfComments
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommentsPage(),
                                      ));
                                },
                                child: Text(
                                  "4 comments",
                                  style: TextStyle(color: primaryColor),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(Icons.reply),
                  ),
                  heading(title: "Business Owner response", fontSize: 14)
                ],
              ),
              Text(
                "didsidni dsodsj sdoo sd osdj oopds jopjojs odsjosd jpd dsijdsio ij disd jiosdjio djioi oi idsojsd ioido idsojo djiod osidio oiio jsdio sjdoij",
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

customAlert(
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
