import 'package:budgethero/app/constant/api_endpoints.dart';
import 'package:budgethero/core/network/api_service.dart';
import 'package:budgethero/features/stats/data/dto/get_stats_dto.dart';
import 'package:budgethero/features/stats/domain/entity/stats_entity.dart';
import 'package:dio/dio.dart';

abstract class IStatsRemoteDatasource {
  Future<StatsEntity> getStats();
}

class StatsRemoteDatasource implements IStatsRemoteDatasource {
  final ApiService _apiService;

  StatsRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<StatsEntity> getStats() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getStats);

      if (response.statusCode == 200) {
        final dto = GetStatsDto.fromJson(response.data);
        return dto.data.toEntity();
      } else {
        throw Exception("Failed to fetch stats");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error fetching stats: $e");
    }
  }
}
