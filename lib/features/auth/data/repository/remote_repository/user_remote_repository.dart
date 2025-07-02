import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:budgethero/features/auth/domain/entity/user_entity.dart';
import 'package:budgethero/features/auth/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository({required UserRemoteDatasource userRemoteDatasource})
    : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final result = await _userRemoteDatasource.loginUser(email, password);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) async {
    try {
      final result = await _userRemoteDatasource.registerUser(user);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
