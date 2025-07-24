import 'package:budgethero/app/constant/api_endpoints.dart';
import 'package:budgethero/core/network/api_service.dart';
import 'package:budgethero/features/goal/data/dto/get_goals_dto.dart';
import 'package:budgethero/features/goal/data/model/goal_api_model.dart';
import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:dio/dio.dart';

abstract class IGoalRemoteDatasource {
  Future<List<GoalEntity>> getGoals();
  Future<void> addGoal(GoalEntity goal);
  Future<void> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(String id);
  Future<void> contributeToGoal(String id, double amount);
}

class GoalRemoteDatasource implements IGoalRemoteDatasource {
  final ApiService _apiService;

  GoalRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<GoalEntity>> getGoals() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getGoals);
      if (response.statusCode == 200) {
        final dto = GetGoalsDto.fromJson(response.data);
        return dto.data.map((e) => e.toEntity()).toList();
      } else {
        throw Exception("Failed to fetch goals");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<void> addGoal(GoalEntity goal) async {
    try {
      await _apiService.dio.post(
        ApiEndpoints.addGoal,
        data: {
          'title': goal.title,
          'targetAmount': goal.targetAmount,
          'savedAmount': goal.savedAmount,
          'deadline': goal.deadline.toIso8601String(),
        },
      );
    } catch (e) {
      throw Exception("Failed to add goal: $e");
    }
  }

  @override
  Future<void> updateGoal(GoalEntity goal) async {
    try {
      final model = GoalApiModel.fromEntity(goal);
      await _apiService.dio.put(
        '${ApiEndpoints.updateGoal}/${goal.id}',
        data: model.toJson(),
      );
    } catch (e) {
      throw Exception("Failed to update goal: $e");
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    try {
      await _apiService.dio.delete('${ApiEndpoints.deleteGoal}/$id');
    } catch (e) {
      throw Exception("Failed to delete goal: $e");
    }
  }

  @override
  Future<void> contributeToGoal(String id, double amount) async {
    try {
      await _apiService.dio.patch(
        "${ApiEndpoints.baseUrl}${ApiEndpoints.contributeGoal}/$id",
        data: {'amount': amount},
      );
    } catch (e) {
      throw Exception("Failed to contribute to goal: $e");
    }
  }
}
