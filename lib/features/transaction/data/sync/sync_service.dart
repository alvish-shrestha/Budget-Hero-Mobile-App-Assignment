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


// import 'package:budgethero/app/service_locator/service_locator.dart';
// import 'package:budgethero/core/network/hive_service.dart';
// import 'package:budgethero/features/home/presentation/view_model/dashboard_event.dart';
// import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
// import 'package:budgethero/features/transaction/data/data_source/remote_datasource/transaction_remote_datasource.dart';
// import 'package:flutter/material.dart';

// class SyncService {
//   final HiveService hiveService;
//   final TransactionRemoteDatasource remoteDatasource;

//   SyncService({required this.hiveService, required this.remoteDatasource});

//   Future<void> syncPendingTransactions() async {
//     try {
//       final unsyncedTxs = await hiveService.getUnsyncedTransactions();

//       for (final tx in unsyncedTxs) {
//         try {
//           final entity = tx.toEntity();
//           await remoteDatasource.addTransaction(entity);
//           await hiveService.markTransactionAsSynced(tx.id);
//         } catch (e) {
//           debugPrint('Failed to sync transaction ${tx.id}: $e');
//         }
//       }

//       serviceLocator<DashboardViewModel>().add(
//         LoadSelectedMonthTransactionsEvent(),
//       );

//       debugPrint("Sync completed: ${unsyncedTxs.length} transactions");
//     } catch (e) {
//       debugPrint("Sync failed: $e");
//     }
//   }
// }