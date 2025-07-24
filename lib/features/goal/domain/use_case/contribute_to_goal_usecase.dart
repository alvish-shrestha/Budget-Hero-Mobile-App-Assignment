import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/domain/repository/goal_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ContributeToGoalParams extends Equatable {
  final String id;
  final double amount;

  const ContributeToGoalParams({required this.id, required this.amount});

  @override
  List<Object?> get props => [id, amount];
}

class ContributeToGoalUsecase
    implements UseCaseWithParams<void, ContributeToGoalParams> {
  final IGoalRepository repository;

  ContributeToGoalUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ContributeToGoalParams params) {
    return repository.contributeToGoal(params.id, params.amount);
  }
}
