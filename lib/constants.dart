import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';


final authentication = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;


const userCollectionName = "USERS";
const categoriesCollectionName = "CATEGORIES";
const locationsCollectionName = "LOCATIONS";
const uploadedLocationsCollectionName = "UPLOADED_LOCATIONS";
const commentsCollectionName = "COMMENTS";
const reviewsCollectionName = "REVIEWS";
// const userCollectionName = "USERS";

const headingStyle = "";
const subHeadingStyle = "";

const primaryColor = Color(0xFF385E72);
const secondaryColor = Color(0xFF6AABD2);
const darkBlueGray = Color(0xFFB7CFDC);
const lightBlueGray = Color(0xFFD9E4EC);
const Gradient secondaryColorGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    secondaryColor,
    darkBlueGray,
  ],
);
