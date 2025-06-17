import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/auth/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, void>> registerUser(UserEntity user);
  Future<Either<Failure, String>> loginUser(String email, String password);

  Future<Either<Failure, UserEntity>> getCurrentUser();
}
