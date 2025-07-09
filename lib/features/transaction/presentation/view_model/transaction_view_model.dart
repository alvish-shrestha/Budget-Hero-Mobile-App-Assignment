import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/features/transaction/domain/use_case/add_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_event.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionViewModel extends Bloc<TransactionEvent, TransactionState> {
  final AddTransactionUsecase _addTransactionUsecase;
  final GetAllTransactionsUsecase _getAllTransactionsUsecase;

  TransactionViewModel({
    required AddTransactionUsecase addTransactionUsecase,
    required GetAllTransactionsUsecase getAllTransactionsUsecase,
  }) : _addTransactionUsecase = addTransactionUsecase,
       _getAllTransactionsUsecase = getAllTransactionsUsecase,
       super(const TransactionState.initial()) {
    on<AddTransactionEvent>(_onAddTransaction);
    on<GetAllTransactionsEvent>(_onGetAllTransactions);
    on<NavigateToAddTransactionViewEvent>(_onNavigateToAddTransaction);
    on<TransactionNavigationHandled>(_onTransactionNavigationHandled);
  }

  void _onAddTransaction(
    AddTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _addTransactionUsecase(
      AddTransactionParams(transaction: event.transaction),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackbar(
          context: event.context,
          content: "Failed to add transaction: ${failure.message}",
          color: Colors.red,
        );
      },
      (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackbar(
          context: event.context,
          content: "Transaction added successfully!",
          color: Colors.green,
        );

        // ✅ Pop screen safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (event.context.mounted) {
            Navigator.pop(event.context);
          }
        });

        // 🔄 Refresh transaction list
        add(GetAllTransactionsEvent());
      },
    );
  }

  void _onGetAllTransactions(
    GetAllTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getAllTransactionsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (transactions) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            transactions: transactions,
          ),
        );
      },
    );
  }

  void _onNavigateToAddTransaction(
    NavigateToAddTransactionViewEvent event,
    Emitter<TransactionState> emit,
  ) {
    // ✅ Set flag so UI can navigate
    emit(state.copyWith(navigateToAdd: true));
  }

  void _onTransactionNavigationHandled(
    TransactionNavigationHandled event,
    Emitter<TransactionState> emit,
  ) {
    emit(state.copyWith(navigateToAdd: false));
  }
}
