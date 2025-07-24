import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:budgethero/features/goal/domain/repository/goal_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class AddGoalParams extends Equatable {
  final GoalEntity goal;

  const AddGoalParams({required this.goal});

  @override
  List<Object?> get props => [goal];
}

class AddGoalUsecase implements UseCaseWithParams<void, AddGoalParams> {
  final IGoalRepository repository;

  AddGoalUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddGoalParams params) {
    return repository.addGoal(params.goal);
  }
}
