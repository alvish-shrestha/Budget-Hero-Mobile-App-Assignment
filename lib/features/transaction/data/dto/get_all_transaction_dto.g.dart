// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_transaction_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllTransactionDto _$GetAllTransactionDtoFromJson(
        Map<String, dynamic> json) =>
    GetAllTransactionDto(
      success: json['success'] as bool,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => TransactionApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllTransactionDtoToJson(
        GetAllTransactionDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
