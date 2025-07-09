import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardViewModel extends Cubit<DashboardState> {
  final LoginViewModel loginViewModel;
  final GetAllTransactionsUsecase getAllTransactionsUsecase;

  DashboardViewModel({
    required this.loginViewModel,
    required this.getAllTransactionsUsecase,
  }) : super(DashboardState.initial());

  void onItemTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> loadTransactions() async {
    emit(state.copyWith(isLoading: true));

    final result = await getAllTransactionsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (transactions) {
        emit(state.copyWith(
          isLoading: false,
          transactions: transactions,
          errorMessage: null,
        ));
      },
    );
  }
}
