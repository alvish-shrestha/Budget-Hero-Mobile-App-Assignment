import 'package:budgethero/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  final String username;
  final String email;
  final String? password;
  final String? confirmPassword;

  const UserApiModel({
    required this.username,
    required this.email,
    this.password,
    this.confirmPassword,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      username: entity.username,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      username: username,
      email: email,
      password: password ?? "",
      confirmPassword: "",
    );
  }

  @override
  List<Object?> get props => [username, email, password, confirmPassword];
}