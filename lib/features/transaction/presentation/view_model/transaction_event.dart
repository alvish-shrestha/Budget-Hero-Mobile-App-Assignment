import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';

@immutable
sealed class TransactionEvent {}

// Add new transaction (income/expense)
class AddTransactionEvent extends TransactionEvent {
  final BuildContext context;
  final TransactionEntity transaction;

  AddTransactionEvent({
    required this.context, 
    required this.transaction,
  });
}

// Fetch all transactions from local storage (Hive)
class GetAllTransactionsEvent extends TransactionEvent {}

// Navigate to Add Transaction Page
class NavigateToAddTransactionViewEvent extends TransactionEvent {
  final BuildContext context;

  NavigateToAddTransactionViewEvent({required this.context});
}

// Reset navigation flag after navigating to AddTransaction screen
class TransactionNavigationHandled extends TransactionEvent {}

class DeleteTransactionEvent extends TransactionEvent {
  final String transactionId;

  DeleteTransactionEvent(this.transactionId);
}

