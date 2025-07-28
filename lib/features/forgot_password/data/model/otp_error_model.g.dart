// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpErrorModel _$OtpErrorModelFromJson(Map<String, dynamic> json) =>
    OtpErrorModel(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$OtpErrorModelToJson(OtpErrorModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
    };
