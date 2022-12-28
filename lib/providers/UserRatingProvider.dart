import 'package:flutter/material.dart';

class userRatingProvider extends ChangeNotifier {
  double rating = 3.0;

  void updateUserRatingProvider(double rating) {
    // log(user.toString());
    this.rating = rating;
    notifyListeners();
  }
}
