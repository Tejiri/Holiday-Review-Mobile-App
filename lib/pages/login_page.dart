import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:review_app/utils/constants.dart';
import 'package:review_app/controllers/auth.dart';
import 'package:review_app/pages/regular_user_pages/bottom_navigation_page.dart';
import 'package:review_app/pages/moderator_pages/moderator_home_page.dart';
import 'package:review_app/pages/registration_page.dart';
import 'package:review_app/custom_widgets/form_components.dart';
import 'package:review_app/custom_widgets/ui_components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool buttonLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    // height: 100,
                    child: LottieBuilder.asset(
                        "assets/lottie/review-animation.json")),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: heading(title: "Welcome Back", fontSize: 30),
                ),
                Text(
                  "Login to your account",
                  style: TextStyle(fontSize: 17),
                ),
                customTextField(
                    context: context,
                    iconData: Icons.email,
                    controller: email,
                    hint: "Enter Email",
                    label: "Email"),
                customTextField(
                    context: context,
                    iconData: Icons.lock,
                    obscureText: true,
                    controller: password,
                    hint: "Enter Password",
                    label: "Password"),
                customButton(
                  isLoading: buttonLoading,
                  text: "Login",
                  context: context,
                  onTap: () {
                    setState(() {
                      buttonLoading = true;
                    });
                    signInUser(
                            email: email.text,
                            password: password.text,
                            context: context)
                        .then((value) async {
                      setState(() {
                        buttonLoading = false;
                      });
                      if (value["result"]) {
                        log(value.toString());
                        final prefs = await SharedPreferences.getInstance();

                        if (value["userRole"] == "moderator") {
                          await prefs
                              .setBool('isModerator', true)
                              .then((value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModeratorHomePage(),
                              ),
                              (route) => false,
                            );
                          });
                        } else {
                          await prefs
                              .setBool('isModerator', false)
                              .then((value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavigationPage(),
                              ),
                              (route) => false,
                            );
                          });
                        }
                      } else {
                        middleAlert(
                            context: context,
                            type: "error",
                            title: "Error",
                            desc: (value['message']));
                      }
                    });

                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BottomNavigationPage(),
                    //   ),
                    //   (route) => false,
                    // );

                    //   setState(() {
                    //   buttonLoading = false;
                    // });
                    // if (value['result']) {
                    //   Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LoginPage(),
                    //     ),
                    //     (route) => false,
                    //   );
                    //   customAlert(
                    //       context: context,
                    //       type: AlertType.success,
                    //       title: "Registered",
                    //       desc: "Account created");
                    // } else {
                    //   customAlert(
                    //       context: context,
                    //       type: AlertType.error,
                    //       title: "Error",
                    //       desc: (value['message']));
                    // }
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: heading(title: "or continue with")),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      socialLogin(image: "assets/images/google.png"),
                      socialLogin(image: "assets/images/facebook (2).png"),
                      socialLogin(image: "assets/images/phone.png")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member? "),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrationPage(),
                                ));
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(color: lightBlueGray),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialLogin({required String image}) {
    return Container(
        height: 60,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: secondaryColor, width: 0.5)),
        child: Image.asset(image));
  }
}
