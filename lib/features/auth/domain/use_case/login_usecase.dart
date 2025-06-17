import 'package:budgethero/app/use_case/use_case.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParams({required this.email, required this.password});

  const LoginUsecaseParams.initial() : email = '', password = '';

  @override
  List<Object?> get props => [email, password];
}


class UserLoginUsecase implements UseCaseWithParams<String, LoginUsecaseParams> {
  final IUserRepository _userRepository;

  UserLoginUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginUsecaseParams params) {
    return _userRepository.loginUser(params.email, params.password);
  }
}