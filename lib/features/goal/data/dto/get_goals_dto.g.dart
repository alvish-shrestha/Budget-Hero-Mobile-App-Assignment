// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_goals_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGoalsDto _$GetGoalsDtoFromJson(Map<String, dynamic> json) => GetGoalsDto(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => GoalApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetGoalsDtoToJson(GetGoalsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
