import 'package:budgethero/features/splash_screen/presentation/view/splash_screen.dart';
import 'package:flutter/material.dart';

class BudgetHero extends StatelessWidget {
  const BudgetHero({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), 
      debugShowCheckedModeBanner: false
    );
  }
}