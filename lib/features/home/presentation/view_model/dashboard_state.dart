import 'package:flutter/material.dart';

class DashboardState {
  final int selectedIndex;
  final List<Widget> screens;

  const DashboardState({required this.selectedIndex, required this.screens});

  static DashboardState initial() {
    return DashboardState(
      selectedIndex: 0,
      screens: const [
        Center(
          child: Text(
            'Transactions',
            style: TextStyle(fontSize: 24, fontFamily: 'Jaro'),
          ),
        ),
        Center(
          child: Text(
            'Statistics',
            style: TextStyle(fontSize: 24, fontFamily: 'Jaro'),
          ),
        ),
        Center(
          child: Text(
            'Accounts',
            style: TextStyle(fontSize: 24, fontFamily: 'Jaro'),
          ),
        ),
        Center(
          child: Text(
            'More Options',
            style: TextStyle(fontSize: 24, fontFamily: 'Jaro'),
          ),
        ),
      ],
    );
  }

  DashboardState copyWith({int? selectedIndex, List<Widget>? screens}) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      screens: screens ?? this.screens,
    );
  }
}
