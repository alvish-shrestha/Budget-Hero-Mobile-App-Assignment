import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:dartz/dartz.dart';

abstract class IGoalRepository {
  Future<Either<Failure, List<GoalEntity>>> getGoals();
  Future<Either<Failure, void>> addGoal(GoalEntity goal);
  Future<Either<Failure, void>> updateGoal(GoalEntity goal);
  Future<Either<Failure, void>> deleteGoal(String id);
  Future<Either<Failure, void>> contributeToGoal(String id, double amount);
}
