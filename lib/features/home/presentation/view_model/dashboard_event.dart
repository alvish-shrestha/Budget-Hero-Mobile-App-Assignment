import 'package:flutter/material.dart';

@immutable
sealed class DashboardEvent {}

class ChangeTabEvent extends DashboardEvent {
  final int index;

  ChangeTabEvent(this.index);
}

class LoadAllTransactionsEvent extends DashboardEvent {}

class LoadSelectedMonthTransactionsEvent extends DashboardEvent {}

class DeleteTransactionEvent extends DashboardEvent {
  final String transactionId;

  DeleteTransactionEvent(this.transactionId);
}

class GoToNextMonthEvent extends DashboardEvent {}

class GoToPreviousMonthEvent extends DashboardEvent {}
