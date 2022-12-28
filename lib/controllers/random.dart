import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/models/Report.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/models/review.dart';

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

String timeAgo(DateTime fatchedDate) {
  DateTime currentDate = DateTime.now();

  var different = currentDate.difference(fatchedDate);

  if (different.inDays > 365)
    return "${(different.inDays / 365).floor()} ${(different.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  if (different.inDays > 30)
    return "${(different.inDays / 30).floor()} ${(different.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  if (different.inDays > 7)
    return "${(different.inDays / 7).floor()} ${(different.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  if (different.inDays > 0)
    return "${different.inDays} ${different.inDays == 1 ? "day" : "days"} ago";
  if (different.inHours > 0)
    return "${different.inHours} ${different.inHours == 1 ? "hour" : "hours"} ago";
  if (different.inMinutes > 0)
    return "${different.inMinutes} ${different.inMinutes == 1 ? "minute" : "minutes"} ago";
  if (different.inMinutes == 0) return 'just now';

  return fatchedDate.toString();
}

double reviewsAverage(Location location) {
  double average = location.ratingsTotal / location.ratingsSize;
  return average.isNaN ? 0 : average;
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

sendReview(
    {required Location location,
    required bool newReview,
    reviewComment,
    String? reviewId,
    userRating,
    required previousRating}) {
  print(location.id.toString());
  print(newReview.toString());
  // Create a reference to the document the transaction will use
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection(uploadedLocationsCollectionName)
      .doc(location.id);

  return FirebaseFirestore.instance
      .runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          throw Exception("Location does not exist!");
        }

        // Update the follower count based on the current count
        // Note: this could be done without a transaction
        // by updating the population using FieldValue.increment()
        if (newReview) {
          double ratingsSize = snapshot.get("ratingsSize") + 1;
          double ratingsTotal = snapshot.get('ratingsTotal') + userRating;
          transaction.update(documentReference,
              {'ratingsSize': ratingsSize, 'ratingsTotal': ratingsTotal});

          firestore
              .collection(uploadedLocationsCollectionName)
              .doc(location.id)
              .collection(reviewsCollectionName)
              .add({
            "createdAt": FieldValue.serverTimestamp(),
            "message": reviewComment,
            "rating": userRating,
            "reviewBy": authentication.currentUser?.uid,
          }).then((value) {
            value.update({"id": value.id});
          });
        } else {
          double ratingsSize = snapshot.get("ratingsSize");

          double ratingsTotal =
              snapshot.get('ratingsTotal') - previousRating + userRating;
          transaction.update(documentReference,
              {'ratingsSize': ratingsSize, 'ratingsTotal': ratingsTotal});
          firestore
              .collection(uploadedLocationsCollectionName)
              .doc(location.id)
              .collection(reviewsCollectionName)
              .doc(reviewId)
              .update({
            "message": reviewComment,
            "rating": userRating,
          });
        }

        // Perform an update on the document

        // Return the new count
        return {'ratingsSize': snapshot.get("ratingsSize"), 'ratingsTotal': snapshot.get("ratingsTotal")};
      })
      .then((value) => print("Follower count updated to $value"))
      .catchError((error) => print("Failed to update user followers: $error"));
}

deleteReview({
  required Report report,
  required Review review,
}) {
  // Create a reference to the document the transaction will use
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection(uploadedLocationsCollectionName)
      .doc(report.locationId);

  return FirebaseFirestore.instance
      .runTransaction((transaction) async {
        double ratingsSize = 0;
        double ratingsTotal = 0;

        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          throw Exception("Location does not exist!");
        }
        ratingsSize = snapshot.get("ratingsSize") - 1;
        ratingsTotal = snapshot.get('ratingsTotal') - review.rating;

        transaction.update(documentReference,
            {'ratingsSize': ratingsSize, 'ratingsTotal': ratingsTotal});

        firestore
            .collection(uploadedLocationsCollectionName)
            .doc(report.locationId)
            .collection(reviewsCollectionName)
            .doc(report.reviewId)
            .delete();
        firestore.collection(reportsCollectionName).doc(report.id).delete();

        // Perform an update on the document

        // Return the new count
        return {'ratingsSize': ratingsSize, 'ratingsTotal': ratingsTotal};
      })
      .then((value) => print("Report Deleted"))
      .catchError((error) => print("Failed to delete report"));
}

Future<QuerySnapshot<Map<String, dynamic>>> getReviewsQuerySnapsot(
    {required Location location}) async {
  var finalValue;
  await firestore
      .collection(uploadedLocationsCollectionName)
      .doc(location.id)
      .collection(reviewsCollectionName)
      .orderBy("createdAt", descending: true)
      .limit(5)
      .get()
      .then((value) {
    finalValue = value;
    // return value;
  });

  return finalValue;
}
