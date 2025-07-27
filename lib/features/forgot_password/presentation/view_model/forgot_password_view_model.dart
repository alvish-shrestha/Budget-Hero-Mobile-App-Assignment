import 'package:budgethero/features/forgot_password/domain/use_case/forgot_password_usecase.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_event.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordViewModel
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUsecase usecase;

  ForgotPasswordViewModel({required this.usecase})
      : super(ForgotPasswordInitial()) {
    on<SubmitForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoading());

      final result = await usecase(event.email);

      result.fold(
        (failure) => emit(ForgotPasswordFailure(failure.message)),
        (_) => emit(ForgotPasswordSuccess()),
      );
    });
  }
}
