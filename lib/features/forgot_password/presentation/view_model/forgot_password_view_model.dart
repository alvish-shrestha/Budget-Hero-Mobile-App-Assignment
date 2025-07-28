import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/features/forgot_password/domain/use_case/forgot_password_usecase.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_event.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_state.dart';
import '../../data/dto/otp_request_dto.dart';
import '../../data/dto/otp_verify_dto.dart';
import '../../data/dto/reset_password_dto.dart';

class ForgotPasswordViewModel extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUsecase usecase;

  ForgotPasswordViewModel({required this.usecase}) : super(ForgotPasswordInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(ForgotPasswordLoading());

      final result = await usecase.sendOtp(OtpRequestDto(email: event.email));

      result.fold(
        (failure) => emit(ForgotPasswordFailure(failure.message)),
        (response) => emit(ForgotPasswordOtpSent(response.message)),
      );
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(ForgotPasswordLoading());

      final result = await usecase.verifyOtp(OtpVerifyDto(
        email: event.email,
        otp: event.otp,
      ));

      result.fold(
        (failure) => emit(ForgotPasswordFailure(failure.message)),
        (response) => emit(ForgotPasswordOtpVerified(response.message)),
      );
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoading());

      final result = await usecase.resetPassword(ResetPasswordDto(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
      ));

      result.fold(
        (failure) => emit(ForgotPasswordFailure(failure.message)),
        (response) => emit(ForgotPasswordSuccess(response.message)),
      );
    });
  }
}
