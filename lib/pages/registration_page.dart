import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:review_app/constants.dart';
import 'package:review_app/controllers/auth.dart';
import 'package:review_app/models/UserModel.dart';
import 'package:review_app/pages/bottom_navigation_page.dart';
import 'package:review_app/pages/login_page.dart';
import 'package:review_app/widgets/form_components.dart';
import 'package:review_app/widgets/ui_components.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool buttonLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Padding(
              // padding: const EdgeInsets.only(top: 20, bottom: 10),
              // child:
              heading(title: "Register Account", fontSize: 30),
              // ),
              customTextField(
                context: context,
                iconData: Icons.person,
                controller: username,
                hint: "Enter Username",
                label: "Username",
              ),
              Row(
                children: [
                  Expanded(
                      child: customTextField(
                    context: context,
                    iconData: Icons.person,
                    controller: firstName,
                    hint: "Enter Firstname",
                    label: "Firstname",
                  )),
                  Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                  Expanded(
                      child: customTextField(
                    context: context,
                    iconData: Icons.person,
                    controller: lastName,
                    hint: "Enter Lastname",
                    label: "Lastname",
                  )),
                ],
              ),
              customTextField(
                context: context,
                iconData: Icons.email,
                controller: email,
                hint: "Enter Email",
                label: "Email",
              ),
              customTextField(
                context: context,
                iconData: Icons.password,
                controller: password,
                obscureText: true,
                hint: "Enter Password",
                label: "Password",
              ),

              customTextField(
                context: context,
                iconData: Icons.password,
                controller: confirmPassword,
                obscureText: true,
                hint: "Confirm Password",
                label: "Confirm Password",
              ),
              customButton(
                isLoading: buttonLoading,
                text: "Register",
                context: context,
                onTap: () {
                  setState(() {
                    buttonLoading = true;
                  });
                  UserModel user = UserModel(
                      accountStatus: "inactive",
                      appVersion: "1.0",
                      createdAt: "",
                      deviceToken: "",
                      email: email.text,
                      firstName: firstName.text,
                      gender: "",
                      middleName: "",
                      onlineStatus: false,
                      phoneNumber: "",
                      profilePhoto: "",
                      userId: "",
                      surname: lastName.text);
                  createUser(user: user, password: password.text).then((value) {
                    setState(() {
                      buttonLoading = false;
                    });
                    if (value['result']) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                        (route) => false,
                      );
                      customAlert(
                          context: context,
                          type: "success",
                          title: "Registered",
                          desc: "Account created");
                    } else {
                      customAlert(
                          context: context,
                          type: "error",
                          title: "Error",
                          desc: (value['message']));
                    }
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                    "By continuing, you agree to our terms of service and Privacy Policy",
                    textAlign: TextAlign.center),
              )
            ],
          )),
        ),
      ),
    );
  }
}
