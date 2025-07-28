import '../../data/dto/otp_request_dto.dart';
import '../../data/dto/otp_verify_dto.dart';
import '../../data/dto/reset_password_dto.dart';
import '../../data/model/otp_response_model.dart';

abstract class IForgotPasswordRepository {
  Future<OtpResponseModel> sendOtp(OtpRequestDto dto);
  Future<OtpResponseModel> verifyOtp(OtpVerifyDto dto);
  Future<OtpResponseModel> resetPassword(ResetPasswordDto dto);
}
