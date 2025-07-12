import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/transaction/data/data_source/remote_datasource/transaction_remote_datasource.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class TransactionRemoteRepository implements TransactionRepository {
  final TransactionRemoteDatasource _remoteDatasource;

  TransactionRemoteRepository({
    required TransactionRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, void>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      await _remoteDatasource.addTransaction(transaction);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to add transaction: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
    try {
      final transactions = await _remoteDatasource.getAllTransactions();
      return Right(transactions);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to fetch transactions: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(
    String transactionId,
  ) async {
    try {
      await _remoteDatasource.deleteTransaction(transactionId);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to delete transaction ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      await _remoteDatasource.updateTransaction(transaction);
      return const Right(null);
    } catch (e) {
      return Left(
        ApiFailure(message: "Failed to update transaction ${e.toString()}"),
      );
    }
  }
}
