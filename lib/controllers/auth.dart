import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/models/UserModel.dart';

Future<Map> createUser(
    {required UserModel user, required String password}) async {
  bool result = false;
  try {
    await authentication
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .then((value) {
      user.userId = value.user!.uid;
      user.createdAt = FieldValue.serverTimestamp();
      firestore
          .collection(userCollectionName)
          .doc(value.user?.uid)
          .set(user.toMap());
      result = true;
      return {"result": result, "message": "Account created successfully"};
    });
  } on FirebaseAuthException catch (e) {
    return {"result": result, "message": e.message.toString()};
  }

  return {"result": result, "message": "Something went wrong"};
}

Future<Map> signInUser(
    {required String email, required String password}) async {
  bool result = false;
  try {
    await authentication
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      firestore
          .collection(userCollectionName)
          .doc(value.user?.uid)
          .get()
          .then((value) {
            log(value.data(). toString());
          });
      // user.userId = value.user!.uid;
      // user.createdAt = FieldValue.serverTimestamp();
      // cloudFirestoreInstance
      //     .collection(userCollectionName)
      //     .doc(value.user?.uid)
      //     .set(user.toMap());
      result = true;
      return {"result": result, "message": "Success"};
    });
  } on FirebaseAuthException catch (e) {
    return {"result": result, "message": e.message.toString()};
  }

  return {"result": result, "message": "Something went wrong"};
}
