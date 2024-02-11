import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'colors.dart';


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String val)? onSubmit,
  Function(String val)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String? Function(String? val)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
  bool redOnly = false,
}) =>
    TextFormField(
      style: TextStyle(
        color: Colors.black, // لون النص
      ),
      readOnly: redOnly,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        // labelStyle: TextStyle(color: Colors.blue), // لون النص للعلامة
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue), // لون الحدود عند التركيز
        ),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: kPrimaryBlue,
            ),
            const SizedBox(
              height: 18.0,
            ),
            Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading..."),
            )
          ],
        ),
      );
    }),
  );
  showDialog(
    barrierDismissible:false ,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}

void showMessage(String message ,BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}


void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );
Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

// enum
enum ToastStates { SUCCESS, ERROR, WARNING }