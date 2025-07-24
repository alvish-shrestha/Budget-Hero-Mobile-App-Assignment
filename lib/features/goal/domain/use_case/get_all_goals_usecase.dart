import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:budgethero/features/goal/domain/repository/goal_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';

class GetAllGoalsUsecase implements UseCaseWithoutParams<List<GoalEntity>> {
  final IGoalRepository repository;

  GetAllGoalsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<GoalEntity>>> call() {
    return repository.getGoals();
  }
}
