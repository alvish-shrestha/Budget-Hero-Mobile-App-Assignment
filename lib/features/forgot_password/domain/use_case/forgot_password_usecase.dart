import 'package:budgethero/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../data/dto/otp_request_dto.dart';
import '../../data/dto/otp_verify_dto.dart';
import '../../data/dto/reset_password_dto.dart';
import '../../data/model/otp_response_model.dart';
import '../repository/forgot_password_repository.dart';

class ForgotPasswordUsecase {
  final IForgotPasswordRepository repository;

  ForgotPasswordUsecase(this.repository);

  Future<Either<Failure, OtpResponseModel>> sendOtp(OtpRequestDto dto) async {
    try {
      final result = await repository.sendOtp(dto);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, OtpResponseModel>> verifyOtp(OtpVerifyDto dto) async {
    try {
      final result = await repository.verifyOtp(dto);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, OtpResponseModel>> resetPassword(ResetPasswordDto dto) async {
    try {
      final result = await repository.resetPassword(dto);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
