// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatsApiModel _$StatsApiModelFromJson(Map<String, dynamic> json) =>
    StatsApiModel(
      categoryExpenses: (json['categoryExpenses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      expenseTrend: (json['expenseTrend'] as List<dynamic>)
          .map((e) => TrendPointModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatsApiModelToJson(StatsApiModel instance) =>
    <String, dynamic>{
      'categoryExpenses': instance.categoryExpenses,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'expenseTrend': instance.expenseTrend,
    };

TrendPointModel _$TrendPointModelFromJson(Map<String, dynamic> json) =>
    TrendPointModel(
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$TrendPointModelToJson(TrendPointModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
    };
