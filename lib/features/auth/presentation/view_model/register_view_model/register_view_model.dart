import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/features/auth/domain/use_case/register_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_user_event.dart';
import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_user_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterUserState> {
  final UserRegisterUsecase _registerUsecase;

  RegisterViewModel(
    this._registerUsecase,
  ) : super(RegisterUserState.initial()) {
    on<RegisterUserEvent>(_registerUserEvent);
  }

  Future<void> _registerUserEvent(
    RegisterUserEvent event,
    Emitter<RegisterUserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _registerUsecase(
      RegisterUsecaseParams(
        username: event.username,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackbar(
          context: event.context,
          content: "Failed to register user: ${failure.message}",
          color: Colors.red,
        );
      },
      (success) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackbar(
          context: event.context,
          content: 'Registration successful!',
        );
      },
    );
  }
}
