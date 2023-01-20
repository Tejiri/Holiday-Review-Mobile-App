import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:review_app/utils/constants.dart';
import 'package:review_app/pages/regular_user_pages/location_page.dart';
import 'package:review_app/custom_widgets/ui_components.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Container(),
        backgroundColor: primaryColor,
        title: Text("Favorites"),
      ),
      body: ListView(
        children: [
          singleFavorites(),
          singleFavorites(),
          singleFavorites(),
          singleFavorites(),
          singleFavorites(),
          singleFavorites(),
          singleFavorites(),
          singleFavorites()
        ],
      ),
    );
  }

  Widget singleFavorites() {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => LocationPage(locationId: ""),
        //     ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: 0.4))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(right: 12),
              // child: ,
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                  image: DecorationImage(
                      image: AssetImage("assets/images/placeholder.jpg"),
                      fit: BoxFit.cover)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heading(title: "Title ", fontSize: 15),
                Text("Restaurant"),
                Text("Abuja - Nigeria"),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "3 days ago",
                //       style: TextStyle(color: Color.fromARGB(255, 118, 115, 115)),
                //     ),

                //   ],
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
