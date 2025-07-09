import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final int selectedIndex;
  final List<Widget> screens;
  final List<TransactionEntity> transactions;
  final bool isLoading;
  final String? errorMessage;

  const DashboardState({
    required this.selectedIndex,
    required this.screens,
    required this.transactions,
    required this.isLoading,
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
      errorMessage: null,
    );
  }

  DashboardState copyWith({
    int? selectedIndex,
    List<Widget>? screens,
    List<TransactionEntity>? transactions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DashboardState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      screens: screens ?? this.screens,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, screens, transactions, isLoading, errorMessage];
}
