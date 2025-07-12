import 'package:budgethero/core/network/hive_service.dart';
import 'package:budgethero/features/transaction/data/model/transaction_hive_model.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';

abstract class ITransactionLocalDatasource {
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getAllTransactions();
  Future<void> deleteTransaction(String transactionId);
  Future<void> updateTransaction(TransactionEntity transaction);
}

class TransactionLocalDatasource implements ITransactionLocalDatasource {
  final HiveService _hiveService;

  TransactionLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      final model = TransactionHiveModel.fromEntity(transaction);
      await _hiveService.addTransaction(model);
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  @override
  Future<List<TransactionEntity>> getAllTransactions() async {
    try {
      final transactionModels = await _hiveService.getAllTransactions();
      return transactionModels.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _hiveService.deleteTransactionById(transactionId);
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      final model = TransactionHiveModel.fromEntity(transaction);
      await _hiveService.updateTransaction(model);
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }
}
