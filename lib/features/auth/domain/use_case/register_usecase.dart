import 'package:budgethero/app/use_case/use_case.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/auth/domain/entity/user_entity.dart';
import 'package:budgethero/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class RegisterUsecaseParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  const RegisterUsecaseParams({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  const RegisterUsecaseParams.initial()
    : username = '',
      email = '',
      password = '',
      confirmPassword = '';

  @override
  List<Object?> get props => [username, email, password, confirmPassword];
}

class UserRegisterUsecase
    implements UseCaseWithParams<void, RegisterUsecaseParams> {
  final IUserRepository _userRepository;
  UserRegisterUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUsecaseParams params) {
    final user = UserEntity(
      username: params.username,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
    return _userRepository.registerUser(user);
  }
}
