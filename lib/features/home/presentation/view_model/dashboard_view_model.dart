import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardViewModel extends Cubit<DashboardState> {
  DashboardViewModel({
    required this.loginViewModel,
  }) : super(DashboardState.initial());

  final LoginViewModel loginViewModel;

  void onItemTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}