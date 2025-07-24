import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:budgethero/features/goal/domain/repository/goal_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateGoalParams extends Equatable {
  final GoalEntity goal;

  const UpdateGoalParams({required this.goal});

  @override
  List<Object?> get props => [goal];
}

class UpdateGoalUsecase implements UseCaseWithParams<void, UpdateGoalParams> {
  final IGoalRepository repository;

  UpdateGoalUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateGoalParams params) {
    return repository.updateGoal(params.goal);
  }
}
