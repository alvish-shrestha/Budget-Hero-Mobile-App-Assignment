// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionApiModel _$TransactionApiModelFromJson(Map<String, dynamic> json) =>
    TransactionApiModel(
      id: json['_id'] as String,
      type: json['type'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      account: json['account'] as String,
      note: json['note'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TransactionApiModelToJson(
        TransactionApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'type': instance.type,
      'date': instance.date,
      'amount': instance.amount,
      'category': instance.category,
      'account': instance.account,
      'note': instance.note,
      'description': instance.description,
    };
