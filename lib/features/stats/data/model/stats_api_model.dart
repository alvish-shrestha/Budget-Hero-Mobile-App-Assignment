import 'package:json_annotation/json_annotation.dart';
import 'package:budgethero/features/stats/domain/entity/stats_entity.dart';

part 'stats_api_model.g.dart';

@JsonSerializable()
class StatsApiModel {
  final Map<String, double> categoryExpenses;
  final double totalIncome;
  final double totalExpense;
  final List<TrendPointModel> expenseTrend;

  StatsApiModel({
    required this.categoryExpenses,
    required this.totalIncome,
    required this.totalExpense,
    required this.expenseTrend,
  });

  factory StatsApiModel.fromJson(Map<String, dynamic> json) =>
      _$StatsApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatsApiModelToJson(this);

  StatsEntity toEntity() => StatsEntity(
        categoryExpenses: categoryExpenses,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        expenseTrend: expenseTrend
            .map((e) => TrendPoint(date: e.date, amount: e.amount))
            .toList(),
      );
}

@JsonSerializable()
class TrendPointModel {
  final String date;
  final double amount;

  TrendPointModel({required this.date, required this.amount});

  factory TrendPointModel.fromJson(Map<String, dynamic> json) =>
      _$TrendPointModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrendPointModelToJson(this);
}
