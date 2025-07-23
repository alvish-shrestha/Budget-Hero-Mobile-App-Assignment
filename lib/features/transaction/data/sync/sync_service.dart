import 'package:budgethero/core/network/hive_service.dart';
import 'package:budgethero/features/transaction/data/data_source/remote_datasource/transaction_remote_datasource.dart';
import 'package:flutter/foundation.dart';

class SyncService {
  final HiveService hiveService;
  final TransactionRemoteDatasource remoteDatasource;

  SyncService({required this.hiveService, required this.remoteDatasource});

  Future<void> syncPendingTransactions() async {
    try {
      final unsyncedTransactions = await hiveService.getUnsyncedTransactions();

      for (final tx in unsyncedTransactions) {
        try {
          await remoteDatasource.addTransaction(tx.toEntity());
          await hiveService.markTransactionAsSynced(tx.id);
          debugPrint('Synced transaction: ${tx.id}');
        } catch (e) {
          debugPrint('Failed to sync transaction ${tx.id}: $e');
        }
      }
    } catch (e) {
      debugPrint('Error during sync process: $e');
    }
  }
}
