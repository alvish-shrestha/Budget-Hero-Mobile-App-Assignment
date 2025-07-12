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

  /// From JSON
  factory TransactionApiModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionApiModelFromJson(json);

  /// To JSON
  Map<String, dynamic> toJson() => _$TransactionApiModelToJson(this);

  /// From Domain Entity
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

  /// To Domain Entity
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
