// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetStatsDto _$GetStatsDtoFromJson(Map<String, dynamic> json) => GetStatsDto(
      success: json['success'] as bool,
      data: StatsApiModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetStatsDtoToJson(GetStatsDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };
