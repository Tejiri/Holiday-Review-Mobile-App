import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/widgets/ui_components.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  bool showReview = true;
  @override
  Widget build(BuildContext context) {
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
              ? singleReview(context: context, showNumberOfComments: false)
              : Container(),
          Expanded(
              child: ListView(
            children: [
              comment(myMessage: true),
              comment(myMessage: true),
              comment(myMessage: false),
              comment(myMessage: true),
              comment(myMessage: false),
              comment(myMessage: false),
              comment(myMessage: true),
            ],
          )),
          Container(
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
                      decoration: InputDecoration(
                          hintText: "Type your comment here",
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none),
                    ),
                  ),
                ),
                CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.send,
                      color: lightBlueGray,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget comment({required bool myMessage}) {
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
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: myMessage ? primaryColor : Colors.green,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Hi Tj,how are you?",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                "2 days ago",
              )
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
