import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';

@immutable
sealed class TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final BuildContext context;
  final TransactionEntity transaction;

  AddTransactionEvent({required this.context, required this.transaction});
}

class GetAllTransactionsEvent extends TransactionEvent {}

class NavigateToAddTransactionViewEvent extends TransactionEvent {
  NavigateToAddTransactionViewEvent();
}

class TransactionNavigationHandled extends TransactionEvent {}

class DeleteTransactionEvent extends TransactionEvent {
  final String transactionId;

  DeleteTransactionEvent(this.transactionId);
}

class UpdateTransactionEvent extends TransactionEvent {
  final BuildContext context;
  final TransactionEntity transaction;

  UpdateTransactionEvent({required this.context, required this.transaction});
}
