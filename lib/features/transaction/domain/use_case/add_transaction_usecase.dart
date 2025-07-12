import 'package:budgethero/app/use_case/use_case.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class AddTransactionParams extends Equatable {
  final TransactionEntity transaction;

  const AddTransactionParams({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class AddTransactionUsecase
    implements UseCaseWithParams<void, AddTransactionParams> {
  final ITransactionRepository _repository;

  AddTransactionUsecase({required ITransactionRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(AddTransactionParams params) async {
    try {
      await _repository.addTransaction(params.transaction);
      return const Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: e.toString()));
    }
  }
}
