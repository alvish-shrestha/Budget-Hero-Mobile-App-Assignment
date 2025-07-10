import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DashboardState extends Equatable {
  final int selectedIndex;
  final List<Widget> screens;
  final List<TransactionEntity> transactions;
  final bool isLoading;
  final String? errorMessage;
  final DateTime selectedMonth;

  const DashboardState({
    required this.selectedIndex,
    required this.screens,
    required this.transactions,
    required this.isLoading,
    required this.selectedMonth,
    this.errorMessage,
  });

  factory DashboardState.initial() {
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
      transactions: const [],
      isLoading: false,
      selectedMonth: DateTime.now(),
      errorMessage: null,
    );
  }

  DashboardState copyWith({
    int? selectedIndex,
    List<Widget>? screens,
    List<TransactionEntity>? transactions,
    bool? isLoading,
    DateTime? selectedMonth,
    String? errorMessage,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      screens: screens ?? this.screens,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    screens,
    transactions,
    isLoading,
    selectedMonth,
    errorMessage,
  ];
}
