import 'package:json_annotation/json_annotation.dart';

part 'otp_response_model.g.dart';

@JsonSerializable()
class OtpResponseModel {
  final bool success;
  final String message;

  OtpResponseModel({
    required this.success,
    required this.message,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OtpResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$OtpResponseModelToJson(this);
}
