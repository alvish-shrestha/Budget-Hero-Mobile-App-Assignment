import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'goal_api_model.g.dart';

@JsonSerializable()
class GoalApiModel {
  @JsonKey(name: "_id")
  final String? id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final String deadline;

  GoalApiModel({
    this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
  });

  factory GoalApiModel.fromJson(Map<String, dynamic> json) =>
      _$GoalApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$GoalApiModelToJson(this);

  GoalEntity toEntity() => GoalEntity(
    id: id ?? '',
    title: title,
    targetAmount: targetAmount,
    savedAmount: savedAmount,
    deadline: DateTime.parse(deadline),
  );

  factory GoalApiModel.fromEntity(GoalEntity entity) {
    return GoalApiModel(
      id: entity.id,
      title: entity.title,
      targetAmount: entity.targetAmount,
      savedAmount: entity.savedAmount,
      deadline: entity.deadline.toIso8601String(),
    );
  }
}
