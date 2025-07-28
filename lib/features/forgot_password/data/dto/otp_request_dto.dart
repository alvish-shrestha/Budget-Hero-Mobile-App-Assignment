import 'package:json_annotation/json_annotation.dart';

part 'otp_request_dto.g.dart';

@JsonSerializable()
class OtpRequestDto {
  final String email;

  OtpRequestDto({required this.email});

  factory OtpRequestDto.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpRequestDtoToJson(this);
}
