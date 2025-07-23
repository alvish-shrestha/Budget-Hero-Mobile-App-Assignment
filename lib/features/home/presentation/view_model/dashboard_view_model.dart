import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_event.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';
import 'package:budgethero/features/transaction/domain/use_case/delete_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/update_transaction_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardViewModel extends Bloc<DashboardEvent, DashboardState> {
  final LoginViewModel loginViewModel;
  final GetAllTransactionsUsecase getAllTransactionsUsecase;
  final DeleteTransactionUsecase deleteTransactionUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;

  DashboardViewModel({
    required this.loginViewModel,
    required this.getAllTransactionsUsecase,
    required this.deleteTransactionUsecase,
    required this.updateTransactionUsecase,
  }) : super(DashboardState.initial()) {
    on<ChangeTabEvent>(_onTabChanged);
    on<LoadAllTransactionsEvent>(_onLoadAllTransactions);
    on<LoadSelectedMonthTransactionsEvent>(_onLoadSelectedMonthTransactions);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<GoToNextMonthEvent>(_onNextMonth);
    on<GoToPreviousMonthEvent>(_onPreviousMonth);
  }

  void _onTabChanged(ChangeTabEvent event, Emitter<DashboardState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  Future<void> _onLoadAllTransactions(
    LoadAllTransactionsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllTransactionsUsecase();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (transactions) =>
          emit(state.copyWith(isLoading: false, transactions: transactions)),
    );
  }

  Future<void> _onLoadSelectedMonthTransactions(
    LoadSelectedMonthTransactionsEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getAllTransactionsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (transactions) {
        final filtered =
            transactions.where((tx) {
              try {
                final txDate = DateTime.tryParse(tx.date);
                if (txDate == null) return false;
                return txDate.year == state.selectedMonth.year &&
                    txDate.month == state.selectedMonth.month;
              } catch (_) {
                return false;
              }
            }).toList();

        emit(
          state.copyWith(
            isLoading: false,
            transactions: filtered,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final deleteResult = await deleteTransactionUsecase(event.transactionId);

    deleteResult.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => add(LoadSelectedMonthTransactionsEvent()),
    );
  }

  void _onNextMonth(GoToNextMonthEvent event, Emitter<DashboardState> emit) {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month + 1,
    );
    emit(state.copyWith(selectedMonth: newMonth));
    add(LoadSelectedMonthTransactionsEvent());
  }

  void _onPreviousMonth(
    GoToPreviousMonthEvent event,
    Emitter<DashboardState> emit,
  ) {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month - 1,
    );
    emit(state.copyWith(selectedMonth: newMonth));
    add(LoadSelectedMonthTransactionsEvent());
  }
}
