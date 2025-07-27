import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/more/data/data_source/remote_datasource/account_remote_datasource.dart';
import 'package:budgethero/features/more/domain/repository/account_repository.dart';
import 'package:dartz/dartz.dart';

class AccountRemoteRepository implements IAccountRepository {
  final IAccountRemoteDatasource remoteDatasource;

  AccountRemoteRepository({required this.remoteDatasource});

  @override
  Future<Either<Failure, void>> updateUsername(String username) async {
    try {
      await remoteDatasource.updateUsername(username);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(String email) async {
    try {
      await remoteDatasource.updateEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String oldPassword, String newPassword) async {
    try {
      await remoteDatasource.updatePassword(oldPassword, newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}