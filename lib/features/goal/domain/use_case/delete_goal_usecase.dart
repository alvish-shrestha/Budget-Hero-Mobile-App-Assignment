import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/domain/repository/goal_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DeleteGoalParams extends Equatable {
  final String id;

  const DeleteGoalParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteGoalUsecase implements UseCaseWithParams<void, DeleteGoalParams> {
  final IGoalRepository repository;

  DeleteGoalUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteGoalParams params) {
    return repository.deleteGoal(params.id);
  }
}
