// import 'package:budgethero/core/error/failure.dart';
// import 'package:budgethero/features/transaction/data/data_source/local_datasource/transaction_local_datasource.dart';
// import 'package:budgethero/features/transaction/data/data_source/remote_datasource/transaction_remote_datasource.dart';
// import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
// import 'package:budgethero/features/transaction/domain/repository/transaction_repository.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dartz/dartz.dart';

// class UnifiedTransactionRepository implements ITransactionRepository {
//   final TransactionLocalDatasource local;
//   final TransactionRemoteDatasource remote;

//   UnifiedTransactionRepository({required this.local, required this.remote});

//   Future<bool> _isOnline() async {
//     final result = await Connectivity().checkConnectivity();
//     return !result.contains(ConnectivityResult.none);
//   }

//   @override
//   Future<Either<Failure, void>> addTransaction(TransactionEntity tx) async {
//     try {
//       await local.addTransaction(tx);
//       if (await _isOnline()) {
//         await remote.addTransaction(tx);
//         await local.markAsSynced(tx.id);
//       }
//       return const Right(null);
//     } catch (e) {
//       return Left(LocalDataBaseFailure(message: "Add failed: $e"));
//     }
//   }

//   @override
//   Future<Either<Failure, List<TransactionEntity>>> getAllTransactions() async {
//     try {
//       final localTx = await local.getAllTransactions();
//       return Right(localTx);
//     } catch (e) {
//       return Left(LocalDataBaseFailure(message: "Fetch failed: $e"));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteTransaction(String transactionId) async {
//     try {
//       await local.deleteTransaction(transactionId);
//       if (await _isOnline()) {
//         await remote.deleteTransaction(transactionId);
//       }
//       return const Right(null);
//     } catch (e) {
//       return Left(LocalDataBaseFailure(message: "Delete failed: $e"));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updateTransaction(TransactionEntity tx) async {
//     try {
//       await local.updateTransaction(tx);
//       if (await _isOnline()) {
//         await remote.updateTransaction(tx);
//         await local.markAsSynced(tx.id);
//       }
//       return const Right(null);
//     } catch (e) {
//       return Left(LocalDataBaseFailure(message: "Update failed: $e"));
//     }
//   }
// }
