import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';
import 'package:budgethero/features/transaction/domain/use_case/delete_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardViewModel extends Cubit<DashboardState> {
  final LoginViewModel loginViewModel;
  final GetAllTransactionsUsecase getAllTransactionsUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;

  DashboardViewModel({
    required this.loginViewModel,
    required this.getAllTransactionsUsecase,
    required this.deleteTransactionUsecase,
  }) : super(DashboardState.initial());

  void onItemTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void nextMonth() {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month + 1,
    );
    emit(state.copyWith(selectedMonth: newMonth));
    loadTransactionsForSelectedMonth();
  }

  void previousMonth() {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month - 1,
    );
    emit(state.copyWith(selectedMonth: newMonth));
    loadTransactionsForSelectedMonth();
  }

  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true));

    final result = await getAllTransactionsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (transactions) {
        emit(
          state.copyWith(
            isLoading: false,
            transactions: transactions,
            errorMessage: null,
          ),
        );
      },
    );
  }

  void loadTransactionsForSelectedMonth() async {
    emit(state.copyWith(isLoading: true));

    final result = await getAllTransactionsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (transactions) {
        final selectedMonth = state.selectedMonth;

        final filteredTransactions =
            transactions.where((tx) {
              try {
                final txDate = DateTime.parse(tx.date);
                return txDate.month == selectedMonth.month &&
                    txDate.year == selectedMonth.year;
              } catch (_) {
                return false;
              }
            }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            transactions: filteredTransactions,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> deleteTransactionAndRefresh(String transactionId) async {
    emit(state.copyWith(isLoading: true));

    final deleteResult = await deleteTransactionUsecase(transactionId);

    deleteResult.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (_) async {
        // Re-fetch and filter for the selected month
        final result = await getAllTransactionsUsecase();

        result.fold(
          (failure) {
            emit(
              state.copyWith(isLoading: false, errorMessage: failure.message),
            );
          },
          (transactions) {
            final selectedMonth = state.selectedMonth;
            final filteredTransactions =
                transactions.where((tx) {
                  try {
                    final txDate = DateTime.parse(tx.date);
                    return txDate.month == selectedMonth.month &&
                        txDate.year == selectedMonth.year;
                  } catch (_) {
                    return false;
                  }
                }).toList();

            emit(
              state.copyWith(
                isLoading: false,
                transactions: filteredTransactions,
                errorMessage: null,
              ),
            );
          },
        );
      },
    );
  }
}
