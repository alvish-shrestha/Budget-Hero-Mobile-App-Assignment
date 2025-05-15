import 'package:budgethero/view/login_view.dart';
import 'package:flutter/material.dart';

class BudgetHero extends StatelessWidget {
  const BudgetHero({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LoginView(), debugShowCheckedModeBanner: false);
  }
}
