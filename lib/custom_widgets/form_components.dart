import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/utils/constants.dart';

Widget customTextField({
  required BuildContext context,
  required IconData iconData,
  required TextEditingController controller,
  required String hint,
  required String label,
  bool? obscureText,
  double? width,
}) {
  return Container(
    // height: 40,

    margin: EdgeInsets.only(top: 20),
    padding: EdgeInsets.only(left: 15, right: 15),
    width: width ?? MediaQuery.of(context).size.width / 1.3,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: secondaryColorGradient),
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

customButton({
  required BuildContext context,
  Function()? onTap,
  required String text,
  bool? isLoading,
  double? width,
  Color? color,
   Color? textColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      margin: EdgeInsets.only(top: 20),
      width: width ?? MediaQuery.of(context).size.width / 1.3,
      decoration: BoxDecoration(
          color: color ?? lightBlueGray,
          // gradient: darkBlueGray,
          borderRadius: BorderRadius.circular(12)),
      child: Center(
          child: isLoading ?? false
              ? Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
              : Text(
                  text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: textColor?? Colors.black),
                )),
    ),
  );
}
