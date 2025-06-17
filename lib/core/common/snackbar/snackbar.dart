import 'package:flutter/material.dart';

showMySnackbar({
  required BuildContext context,
  required String content,
  Color? color,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: "Jaro",
        ),
      ),
      backgroundColor: color ?? Colors.green,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
