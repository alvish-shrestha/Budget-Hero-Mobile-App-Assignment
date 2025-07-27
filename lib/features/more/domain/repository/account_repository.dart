import 'package:budgethero/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class IAccountRepository {
  Future<Either<Failure, void>> updateUsername(String username);
  Future<Either<Failure, void>> updateEmail(String email);
  Future<Either<Failure, void>> updatePassword(String oldPassword, String newPassword);
}