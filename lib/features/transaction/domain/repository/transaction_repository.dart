import 'package:budgethero/core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../entity/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<Either<Failure, List<TransactionEntity>>> getAllTransactions();
}
