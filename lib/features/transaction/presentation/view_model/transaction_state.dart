import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:equatable/equatable.dart';

class TransactionState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final List<TransactionEntity> transactions;
  final String? errorMessage;
  final bool navigateToAdd;

  const TransactionState({
    required this.isLoading,
    required this.isSuccess,
    required this.transactions,
    this.errorMessage,
    this.navigateToAdd = false, 
  });

  const TransactionState.initial()
    : isLoading = false,
      isSuccess = false,
      transactions = const [],
      errorMessage = null,
      navigateToAdd = false;

  TransactionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<TransactionEntity>? transactions,
    String? errorMessage,
    bool? navigateToAdd, // <-- Add this
  }) {
    return TransactionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
      navigateToAdd: navigateToAdd ?? this.navigateToAdd, // <-- Copy flag
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    transactions,
    errorMessage,
    navigateToAdd, // <-- Include in props
  ];
}
