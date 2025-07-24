import 'package:budgethero/features/goal/data/model/goal_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_goals_dto.g.dart';

@JsonSerializable()
class GetGoalsDto {
  final bool success;
  final List<GoalApiModel> data;

  const GetGoalsDto({
    required this.success,
    required this.data,
  });

  factory GetGoalsDto.fromJson(Map<String, dynamic> json) =>
      _$GetGoalsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetGoalsDtoToJson(this);
}
