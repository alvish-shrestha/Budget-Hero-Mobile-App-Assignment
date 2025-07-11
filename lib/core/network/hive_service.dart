import 'package:budgethero/app/constant/hive/hive_table_constant.dart';
import 'package:budgethero/features/auth/data/model/user_hive_model.dart';
import 'package:budgethero/features/transaction/data/model/transaction_hive_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HiveService {
  Future<void> init() async {
    await Hive.close();
    await Hive.initFlutter();

    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(UserHiveModelAdapter());
      }
    } catch (e) {
      debugPrint('User adapter already registered: $e');
    }

    try {
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(TransactionHiveModelAdapter());
      }
    } catch (e) {
      debugPrint('Transaction adapter already registered: $e');
    }
    // Hive.registerAdapter(UserHiveModelAdapter());
    // Hive.registerAdapter(TransactionHiveModelAdapter());
  }

  // ===================== User Query =====================
  Future<void> registerUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.userId, user);
  }

  Future<UserHiveModel?> loginUser(String email, String password) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    var user = box.values.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    return user;
  }

  // ===================== Transaction =====================
  Future<void> addTransaction(TransactionHiveModel transaction) async {
    final box = await Hive.openBox<TransactionHiveModel>(
      HiveTableConstant.transactionBox,
    );
    await box.add(transaction);
  }

  Future<List<TransactionHiveModel>> getAllTransactions() async {
    final box = await Hive.openBox<TransactionHiveModel>(
      HiveTableConstant.transactionBox,
    );

    await box.flush();
    return box.values.toList();
  }
}
