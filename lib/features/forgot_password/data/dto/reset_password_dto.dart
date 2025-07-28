import 'package:json_annotation/json_annotation.dart';

part 'reset_password_dto.g.dart';

@JsonSerializable()
class ResetPasswordDto {
  final String email;
  final String otp;
  final String newPassword;

  ResetPasswordDto({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  factory ResetPasswordDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordDtoToJson(this);
}
