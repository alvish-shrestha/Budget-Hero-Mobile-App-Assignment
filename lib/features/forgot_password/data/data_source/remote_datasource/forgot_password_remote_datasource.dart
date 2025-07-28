import 'package:dio/dio.dart';
import '../../dto/otp_request_dto.dart';
import '../../dto/otp_verify_dto.dart';
import '../../dto/reset_password_dto.dart';
import '../../model/otp_response_model.dart';
import 'dart:convert';

abstract class IForgotPasswordRemoteDatasource {
  Future<OtpResponseModel> sendOtp(OtpRequestDto dto);
  Future<OtpResponseModel> verifyOtp(OtpVerifyDto dto);
  Future<OtpResponseModel> resetPassword(ResetPasswordDto dto);
}

class ForgotPasswordRemoteDatasource
    implements IForgotPasswordRemoteDatasource {
  final Dio dio;

  ForgotPasswordRemoteDatasource(this.dio);

  @override
  Future<OtpResponseModel> sendOtp(OtpRequestDto dto) async {
    final res = await dio.post("/auth/forgotPassword", data: dto.toJson());
    final jsonData = res.data is String ? jsonDecode(res.data) : res.data;
    return OtpResponseModel.fromJson(jsonData);
  }

  @override
  Future<OtpResponseModel> verifyOtp(OtpVerifyDto dto) async {
    final res = await dio.post("/auth/verify-otp", data: dto.toJson());
    final jsonData = res.data is String ? jsonDecode(res.data) : res.data;
    return OtpResponseModel.fromJson(jsonData);
  }

  @override
  Future<OtpResponseModel> resetPassword(ResetPasswordDto dto) async {
    final res = await dio.post("/auth/reset-password", data: dto.toJson());
    final jsonData = res.data is String ? jsonDecode(res.data) : res.data;
    return OtpResponseModel.fromJson(jsonData);
  }
}
