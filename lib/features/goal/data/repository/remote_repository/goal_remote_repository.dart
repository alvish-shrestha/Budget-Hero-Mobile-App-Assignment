import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/data/data_source/remote_datasource/goal_remote_datasource.dart';
import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:budgethero/features/goal/domain/repository/goal_repository.dart';
import 'package:dartz/dartz.dart';

class GoalRemoteRepository implements IGoalRepository {
  final IGoalRemoteDatasource _remoteDatasource;

  GoalRemoteRepository({required IGoalRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<Either<Failure, List<GoalEntity>>> getGoals() async {
    try {
      final goals = await _remoteDatasource.getGoals();
      return Right(goals);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addGoal(GoalEntity goal) async {
    try {
      await _remoteDatasource.addGoal(goal);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateGoal(GoalEntity goal) async {
    try {
      await _remoteDatasource.updateGoal(goal);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String id) async {
    try {
      await _remoteDatasource.deleteGoal(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> contributeToGoal(String id, double amount) async {
    try {
      await _remoteDatasource.contributeToGoal(id, amount);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
