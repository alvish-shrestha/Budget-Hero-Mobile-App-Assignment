import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/transaction/data/data_source/local_datasource/transaction_local_datasource.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class TransactionLocalRepository implements TransactionRepository {
  final TransactionLocalDatasource _localDatasource;

  TransactionLocalRepository({
    required TransactionLocalDatasource localDatasource,
  }) : _localDatasource = localDatasource;

  @override
  Future<Either<Failure, void>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      await _localDatasource.addTransaction(transaction);
      return const Right(null);
    } catch (e) {
      return Left(
        LocalDataBaseFailure(message: 'Failed to add transaction: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
    try {
      final transactions = await _localDatasource.getAllTransactions();
      return Right(transactions);
    } catch (e) {
      return Left(
        LocalDataBaseFailure(message: 'Failed to fetch transactions: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String transactionId) async {
    try {
      await _localDatasource.deleteTransaction(transactionId);
      return const Right(null);
    } catch (e) {
      return Left(
        LocalDataBaseFailure(message: "Failed to delete transaction"),
      );
    }
  }
  
  @override
  Future<Either<Failure, void>> updateTransaction(TransactionEntity transaction) async {
    try {
      await _localDatasource.updateTransaction(transaction);
      return const Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to update transaction"));
    }
  }
}
