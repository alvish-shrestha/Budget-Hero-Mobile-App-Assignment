import 'package:budgethero/app/constant/hive/hive_table_constant.dart';
import 'package:budgethero/features/auth/domain/entity/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String confirmPassword;

  const UserHiveModel({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  const UserHiveModel.initial()
    : userId = null,
      username = '',
      email = '',
      password = '',
      confirmPassword = '';

  // To entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  // From entity
  factory UserHiveModel.fromEntity(UserEntity user) {
    return UserHiveModel(
      userId: user.userId,
      username: user.username,
      email: user.email,
      password: user.password,
      confirmPassword: user.confirmPassword,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    password,
    confirmPassword,
  ];
}
