import 'package:flutter/material.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Goals Coming Soon!',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Jaro',
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
