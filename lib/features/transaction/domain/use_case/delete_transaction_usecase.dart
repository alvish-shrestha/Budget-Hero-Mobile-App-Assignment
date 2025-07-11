import 'package:budgethero/app/use_case/use_case.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteTransactionUsecase implements UseCaseWithParams<void, String> {
  final TransactionRepository _repository;

  DeleteTransactionUsecase({required TransactionRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(String id) {
    return _repository.deleteTransaction(id);
  }
}
