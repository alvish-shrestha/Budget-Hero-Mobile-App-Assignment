import 'package:budgethero/app/use_case/use_case.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateTransactionParams extends Equatable {
  final TransactionEntity transaction;

  const UpdateTransactionParams({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransactionUsecase
    implements UseCaseWithParams<void, UpdateTransactionParams> {
  final TransactionRepository _repository;

  UpdateTransactionUsecase({required TransactionRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(UpdateTransactionParams params) {
    return _repository.updateTransaction(params.transaction);
  }
}
