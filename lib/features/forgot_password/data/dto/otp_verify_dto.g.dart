// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerifyDto _$OtpVerifyDtoFromJson(Map<String, dynamic> json) => OtpVerifyDto(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$OtpVerifyDtoToJson(OtpVerifyDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
    };
