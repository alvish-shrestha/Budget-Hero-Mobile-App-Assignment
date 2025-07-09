import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part "transaction_hive_model.g.dart";

@HiveType(typeId: 1)
class TransactionHiveModel extends Equatable {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String account;

  @HiveField(5)
  final String note;

  @HiveField(6)
  final String description;

  const TransactionHiveModel({
    required this.type,
    required this.date,
    required this.amount,
    required this.category,
    required this.account,
    required this.note,
    required this.description,
  });

  // Convert to Entity
  TransactionEntity toEntity() {
    return TransactionEntity(
      type: type,
      date: date,
      amount: amount,
      category: category,
      account: account,
      note: note,
      description: description,
    );
  }

  // Create from Entity
  factory TransactionHiveModel.fromEntity(TransactionEntity entity) {
    return TransactionHiveModel(
      type: entity.type,
      date: entity.date,
      amount: entity.amount,
      category: entity.category,
      account: entity.account,
      note: entity.note,
      description: entity.description,
    );
  }

  @override
  List<Object?> get props => [
    type,
    date,
    amount,
    category,
    account,
    note,
    description,
  ];
}
