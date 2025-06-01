import 'package:budgethero/theme/theme_data.dart';
import 'package:budgethero/view/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: myApplicationTheme(),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
