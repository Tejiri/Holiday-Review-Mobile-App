

import 'dart:math';

import 'package:review_app/constants.dart';

String generateRandomString(int len) {
  String uid = (authentication.currentUser?.uid).toString();
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  String rand =
      List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  return (rand + uid);
}