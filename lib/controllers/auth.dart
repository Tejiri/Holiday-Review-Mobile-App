import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/utils/constants.dart';
import 'package:review_app/models/user_model.dart';
import 'package:review_app/providers/UserProvider.dart';

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
    {required String email,
    required String password,
    required BuildContext context}) async {
  bool result = false;
  String userRole = "";
  String message = "";
  try {
    await authentication
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userValue) async {
      if (userValue.user!.emailVerified) {
        await firestore
            .collection(userCollectionName)
            .doc(userValue.user?.uid)
            .get()
            .then((value) {
          UserModel userModel = UserModel.fromFirebase(value.data() as Map);

          Provider.of<UserProvider>(context, listen: false)
              .updateUserProvider(userModel);
          result = true;
          message = "Success";
          userRole = userModel.role;
        });
      } else {
        await authentication.currentUser?.sendEmailVerification().then((value) {
          message = "Email not verified";
          return {"result": result, "message": "Email not verified"};
        });
      }
    });
  } on FirebaseAuthException catch (e) {
    return {"result": result, "message": e.message.toString()};
  }

  return {"result": result, "message": message, "userRole": userRole};
}

signOutUser({required BuildContext context}) {
  authentication.signOut().then((value) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false);
  });
}
