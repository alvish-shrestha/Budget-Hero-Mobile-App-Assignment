// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoalApiModel _$GoalApiModelFromJson(Map<String, dynamic> json) => GoalApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      savedAmount: (json['savedAmount'] as num).toDouble(),
      deadline: json['deadline'] as String,
    );

Map<String, dynamic> _$GoalApiModelToJson(GoalApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'targetAmount': instance.targetAmount,
      'savedAmount': instance.savedAmount,
      'deadline': instance.deadline,
    };
