import 'package:budgethero/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entity/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions();
  Future<Either<Failure, void>> deleteTransaction(String transactionId);
  Future<Either<Failure, void>> updateTransaction(TransactionEntity transaction);
}
