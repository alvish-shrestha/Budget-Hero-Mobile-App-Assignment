import 'package:budgethero/app/use_case/use_case.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllTransactionsUsecase
    implements UseCaseWithoutParams<List<TransactionEntity>> {
  final ITransactionRepository _repository;

  GetAllTransactionsUsecase({required ITransactionRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<TransactionEntity>>> call() {
    return _repository.getAllTransactions();
  }
}
