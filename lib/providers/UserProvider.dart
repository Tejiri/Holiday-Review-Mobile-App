

import 'package:flutter/material.dart';
import 'package:review_app/models/user_model.dart';

class UserProvider extends  ChangeNotifier{
 UserModel? userModel;
  // Profile? profile;
  // User user = null;
  // String? firstName = '';
  // String? lastName = '';
  // String? email = '';
  // String? phoneNumber = '';
  // String? gender = '';

  void updateUserProvider(UserModel userModel) {
    // log(user.toString());
    this.userModel = userModel;
    notifyListeners();
  }
}