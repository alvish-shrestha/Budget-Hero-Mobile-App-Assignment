import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_api_model.g.dart';

@JsonSerializable()
class TransactionApiModel extends Equatable {
  @JsonKey(name: "_id")
  final String id;

  final String type;
  final String date;

  @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
  final double amount;

  final String category;
  final String account;
  final String note;
  final String description;

  const TransactionApiModel({
    required this.id,
    required this.type,
    required this.date,
    required this.amount,
    required this.category,
    required this.account,
    required this.note,
    required this.description,
  });

  factory TransactionApiModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionApiModelToJson(this);

  factory TransactionApiModel.fromEntity(TransactionEntity entity) {
    return TransactionApiModel(
      id: entity.id,
      type: entity.type,
      date: entity.date,
      amount: entity.amount,
      category: entity.category,
      account: entity.account,
      note: entity.note,
      description: entity.description,
    );
  }

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      type: type,
      date: date,
      amount: amount,
      category: category,
      account: account,
      note: note,
      description: description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        date,
        amount,
        category,
        account,
        note,
        description,
      ];
}

double _amountFromJson(dynamic value) {
  if (value == null) return 0.0;
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

num _amountToJson(double value) => value;
