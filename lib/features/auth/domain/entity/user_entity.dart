import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
