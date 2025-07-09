import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/features/auth/domain/use_case/login_usecase.dart';
import 'package:budgethero/features/auth/presentation/view/signup_screen.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:budgethero/features/home/presentation/view/dashboard_screen.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,

        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocator<RegisterViewModel>(),
                child: Signup(),
              ),
        ),
      );
    }
  }

  void _onNavigateToHomeView(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: serviceLocator<DashboardViewModel>(),
                  ),
                  BlocProvider.value(
                    value: serviceLocator<TransactionViewModel>(),
                  ),
                ],
                child: const DashboardScreen(),
              ),
        ),
      );
    }
  }

  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginUsecaseParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackbar(
          context: event.context,
          content: "Failed to login: ${failure.message}",
          color: Colors.red,
        );
      },
      (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackbar(
          context: event.context,
          content: 'Login successful!',
          color: Colors.green,
        );

        // DEFER navigation to avoid _debugLocked error
        Future.microtask(() {
          // ignore: use_build_context_synchronously
          add(NavigateToHomeViewEvent(context: event.context));
        });
      },
    );
  }
}
