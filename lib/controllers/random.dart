import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:review_app/constants.dart';

// String generateRandomString(int len) {
//   String uid = (authentication.currentUser?.uid).toString();
//   var r = Random();
//   const _chars =
//       'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//   String rand =
//       List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
//   return (rand + uid);
// }

Future<File?> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    file.path + targetPath,
    quality: 60,
    // rotate: 180,

  );

  // print(file.lengthSync());
  // print(result.lengthSync());

  return result;
}


//  Future<Uint8List?> testCompressFile(File file) async {
//     var result = await FlutterImageCompress.compressWithFile(
//       file.absolute.path,
//       minWidth: 2300,
//       minHeight: 1500,
//       quality: 94,
//       rotate: 90,
//     );
//     // print(file.lengthSync());
//     // print(result.length);
//     return result;
//   }