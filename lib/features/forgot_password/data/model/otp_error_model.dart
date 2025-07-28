import 'package:json_annotation/json_annotation.dart';

part 'otp_error_model.g.dart';

@JsonSerializable()
class OtpErrorModel {
  final bool success;
  final String message;

  OtpErrorModel({
    required this.success,
    required this.message,
  });

  factory OtpErrorModel.fromJson(Map<String, dynamic> json) =>
      _$OtpErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpErrorModelToJson(this);
}
