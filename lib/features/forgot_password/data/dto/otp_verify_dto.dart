import 'package:json_annotation/json_annotation.dart';

part 'otp_verify_dto.g.dart';

@JsonSerializable()
class OtpVerifyDto {
  final String email;
  final String otp;

  OtpVerifyDto({required this.email, required this.otp});

  factory OtpVerifyDto.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyDtoToJson(this);
}
