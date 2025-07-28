import 'package:budgethero/features/forgot_password/data/data_source/remote_datasource/forgot_password_remote_datasource.dart';
import 'package:budgethero/features/forgot_password/domain/repository/forgot_password_repository.dart';
import '../../dto/otp_request_dto.dart';
import '../../dto/otp_verify_dto.dart';
import '../../dto/reset_password_dto.dart';
import '../../model/otp_response_model.dart';

class ForgotPasswordRemoteRepository implements IForgotPasswordRepository {
  final IForgotPasswordRemoteDatasource remoteDatasource;

  ForgotPasswordRemoteRepository({required this.remoteDatasource});

  @override
  Future<OtpResponseModel> sendOtp(OtpRequestDto dto) {
    return remoteDatasource.sendOtp(dto);
  }

  @override
  Future<OtpResponseModel> verifyOtp(OtpVerifyDto dto) {
    return remoteDatasource.verifyOtp(dto);
  }

  @override
  Future<OtpResponseModel> resetPassword(ResetPasswordDto dto) {
    return remoteDatasource.resetPassword(dto);
  }
}
