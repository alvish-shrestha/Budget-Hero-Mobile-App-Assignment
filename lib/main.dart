import 'package:budgethero/app/theme/theme_data.dart';
import 'package:budgethero/features/splash_screen/presentation/view/splash_screen.dart';
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
