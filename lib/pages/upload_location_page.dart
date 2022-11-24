import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/controllers/numbers.dart';
import 'package:review_app/controllers/random.dart';
import 'package:review_app/models/location.dart';
import 'package:review_app/widgets/form_components.dart';
import 'package:review_app/widgets/ui_components.dart';

class UploadLocationPage extends StatefulWidget {
  const UploadLocationPage({super.key});

  @override
  State<UploadLocationPage> createState() => _UploadLocationPageState();
}

class _UploadLocationPageState extends State<UploadLocationPage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  List<String> locations = [];
  List<String> categories = [];
  var locationSelected = "";
  var categorySelected = "";
  var selectedImage;
  bool buttonLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestore
        .collection(locationsCollectionName)
        .orderBy("name", descending: false)
        .get()
        .then((value) {
      // log(value.docs.toString());
      for (var i = 0; i < value.docs.length; i++) {
        if (i == 0) {
          locationSelected = value.docs[i].get("name");
          locations.add(value.docs[i].get("name"));
        } else {
          // dropDownSelectedItem = value.docs[i].get("name");
          locations.add(value.docs[i].get("name"));
        }
      }

      firestore
          .collection(categoriesCollectionName)
          .orderBy("name", descending: false)
          .get()
          .then((value) {
        // log(value.docs.toString());
        for (var i = 0; i < value.docs.length; i++) {
          if (i == 0) {
            categorySelected = value.docs[i].get("name");
            categories.add(value.docs[i].get("name"));
          } else {
            // dropDownSelectedItem = value.docs[i].get("name");
            categories.add(value.docs[i].get("name"));
          }
        }
        setState(() {});
        // setState(() {});
        // for (var element in value.docs) {
        //   log(element.toString());

        //   // log(element.id);
        // }
      });

      setState(() {});
      // for (var element in value.docs) {
      //   log(element.toString());

      //   // log(element.id);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                  color: darkBlueGray, borderRadius: BorderRadius.circular(15)),
              child: ListView(
                children: [
                  Column(
                    children: [
                      heading(title: "Upload Location"),
                      Text("dsds"),
                      GestureDetector(
                        onTap: () async {
                          try {
                            // final picker = ImagePicker();
                            // // PickedFile pickedFile =
                            // //     picker.pickImage(source: ImageSource.gallery);

                            // final XFile? image = await picker.pickImage(
                            //     source: ImageSource.gallery);
                            // selectedImage = image?.path;
                            await FilePicker.platform
                                .pickFiles(
                                    // onFileLoading: (p0) {},
                                    type: FileType.image)
                                .then((value) async {
                              if (value != null) {
                                await testCompressAndGetFile(
                                        File(value.files.first.path.toString()),
                                        "image.jpg")
                                    .then((compressedFile) {
                                  setState(() {
                                    selectedImage = compressedFile;
                                  });
                                  // log(selectedImage.toString());
                                });
                              }
                            });
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            decoration: BoxDecoration(
                                color: lightBlueGray,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all()),
                            child: selectedImage == null
                                ? Column(
                                    children: [
                                      Icon(Icons.upload_file, size: 50),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text("Choose file here"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Max file size: 50mb",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  )
                                : addImageView(file: selectedImage)),
                      ),
                      Container(
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: lightBlueGray,
                            borderRadius: BorderRadius.circular(10)),
                        child: locationSelected == ""
                            ? Center(child: CircularProgressIndicator())
                            : DropdownButton<String>(
                                hint: Text("Select Location"),

                                isExpanded: true,
                                // alignment: AlignmentDirectional.,
                                underline: Container(),
                                value: locationSelected,
                                items: locations.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  // log(value.toString());
                                  setState(() {
                                    locationSelected = value!;
                                  });
                                },
                              ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        height: 50,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: lightBlueGray,
                            borderRadius: BorderRadius.circular(10)),
                        child: categorySelected == ""
                            ? Center(child: CircularProgressIndicator())
                            : DropdownButton<String>(
                                hint: Text("Select Location"),

                                isExpanded: true,
                                // alignment: AlignmentDirectional.,
                                underline: Container(),
                                value: categorySelected,
                                items: categories.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  // log(value.toString());
                                  setState(() {
                                    categorySelected = value!;
                                  });
                                },
                              ),
                      ),

                      //  Container(
                      //     height: 50,
                      //     width: double.infinity,
                      //     margin: EdgeInsets.only(top: 20),
                      //     padding: EdgeInsets.only(left: 10, right: 10),
                      //     decoration: BoxDecoration(
                      //         color: lightBlueGray,
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: DropdownButton<String>(
                      //       isExpanded: true,
                      //       // alignment: AlignmentDirectional.,
                      //       underline: Container(),
                      //       value: dropDownSelectedItem,
                      //       items: <String>[
                      //         'Abbey',
                      //         'Basford',
                      //         'Pattingham',
                      //         'Stafford',
                      //         'Stoke-on-Trent',
                      //       ].map((String value) {
                      //         return DropdownMenuItem<String>(
                      //           value: value,
                      //           child: Text(value),
                      //         );
                      //       }).toList(),
                      //       onChanged: (value) {
                      //         log(value.toString());
                      //         setState(() {
                      //           dropDownSelectedItem = value!;
                      //         });
                      //       },
                      //     ),
                      //   ),

                      uploadLocationTextField(
                          iconData: Icons.title,
                          controller: title,
                          hint: "Title",
                          label: "Title",
                          width: double.infinity),
                      uploadLocationTextField(
                          iconData: Icons.title,
                          controller: description,
                          hint: "Description",
                          label: "Description",
                          width: double.infinity),
                    ],
                  )

                  // Text("Upload Location")
                ],
              ),
            )),
            customButton(
              isLoading: buttonLoading,
              width: double.infinity,
              context: context,
              text: "Upload Location",
              onTap: () async {
                setState(() {
                  buttonLoading = true;
                });
                await storage
                    .ref()
                    .child(
                        "/LOCATIONS/${authentication.currentUser?.uid}/${generateRandomString(10)}")
                    .putFile(selectedImage)
                    .then((value) async {
                  final imageUrl = await value.ref.getDownloadURL();
                  // DocumentReference documentReference =
                  //     firestore.collection(locationsCollectionName).doc();
                  //     String id = documentReference.id;
                  Location locationToUpload = Location(
                      category: categorySelected,
                      commentsSize: 0.0,
                      description: description.text,
                      createdAt: FieldValue.serverTimestamp(),
                      id: "",
                      imageUrl: imageUrl,
                      location: locationSelected,
                      ratingsAverage: 0.0,
                      ratingsSize: 0,
                      status: "pending",
                      title: title.text,
                      uploadedBy: authentication.currentUser!.uid);

                  // log(locationToUpload.toMap().toString());

                  firestore
                      .collection(uploadedLocationsCollectionName)
                      .add(locationToUpload.toMap())
                      .then((value) {
                    value.update({"id": value.id});
                    setState(() {
                      buttonLoading = false;
                    });
                  });
                  // log(imageUrl);
                });
              },
            )
          ],
        ),
      ),
    );
  }

  uploadLocationTextField(
      {required IconData iconData,
      required TextEditingController controller,
      required String hint,
      required String label,
      bool? obscureText,
      double? width}) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 15, right: 15),
      width: width ?? MediaQuery.of(context).size.width / 1.3,
      decoration: BoxDecoration(
        color: lightBlueGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(iconData),
          ),
          Expanded(
              child: TextField(
            obscureText: obscureText ?? false,
            controller: controller,
            decoration: InputDecoration(
                hintText: hint,
                labelText: label,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ))
        ],
      ),
    );
  }

  // selectedImage =  result.files.first.path.toString();

  Widget addImageView({required file}) {
    // File file = File(platformFile!.path.toString())/;
    return Center(
      child: Container(
        height: 180,
        width: 180,
        margin: EdgeInsets.only(right: 15),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                // decoration:
                // BoxDecoration(borderRadius: BorderRadius.circular(25)),
                height: 180,
                width: 180,
                // margin: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    file,
                    // width: 80,
                    // height: 80,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              // height: 200,
              // width: 200,
              margin: EdgeInsets.only(right: 5, top: 5),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    // selectedFiles.removeAt(index);
                    setState(() {
                      selectedImage = null;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        Color.fromARGB(255, 0, 80, 3).withOpacity(0.5),
                    radius: 15,
                    // minRadius: 10,

                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
