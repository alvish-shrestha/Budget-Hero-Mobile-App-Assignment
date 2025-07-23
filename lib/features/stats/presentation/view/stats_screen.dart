import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Stats Coming Soon!',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Jaro',
            backgroundColor: Colors.white,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
