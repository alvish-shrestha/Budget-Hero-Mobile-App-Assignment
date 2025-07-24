import 'package:json_annotation/json_annotation.dart';
import 'package:budgethero/features/stats/data/model/stats_api_model.dart';

part 'get_stats_dto.g.dart';

@JsonSerializable()
class GetStatsDto {
  final bool success;
  final StatsApiModel data;

  const GetStatsDto({
    required this.success,
    required this.data,
  });

  factory GetStatsDto.fromJson(Map<String, dynamic> json) =>
      _$GetStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetStatsDtoToJson(this);
}
