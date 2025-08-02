import 'dart:async';

import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'shake_detector.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';

class ShakeHandler {
  static final ShakeHandler _instance = ShakeHandler._internal();
  factory ShakeHandler() => _instance;
  Timer? _undoTimer;
  bool _undoCooldownActive = false;

  ShakeHandler._internal();

  late final ShakeDetector _detector;
  TransactionEntity? _lastDeleted;
  bool _isDialogShown = false;

  void init(BuildContext context) {
    // Prevent multiple listeners
    _detector = ShakeDetector(
      onPhoneShake: () {
        if (_undoCooldownActive && _lastDeleted != null && !_isDialogShown) {
          _showUndoDialog(context, _lastDeleted!);
        }
      },
    )..startListening();
  }

  void setLastDeleted(TransactionEntity tx) {
    _lastDeleted = tx;
    _undoCooldownActive = true;

    _undoTimer?.cancel();
    _undoTimer = Timer(const Duration(seconds: 10), () {
      _lastDeleted = null;
      _undoCooldownActive = false;
      _isDialogShown = false;
    });
  }

  void _showUndoDialog(BuildContext context, TransactionEntity tx) {
    _isDialogShown = true;
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Undo Delete?"),
            content: const Text(
              "Shake detected. Restore the last deleted transaction?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _isDialogShown = false;
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  context.read<TransactionViewModel>().add(
                    AddTransactionEvent(context: context, transaction: tx),
                  );
                  showMySnackbar(
                    context: context,
                    content: "Transaction restored!",
                    color: Colors.green,
                  );
                  _lastDeleted = null;
                  _undoCooldownActive = false;
                  _isDialogShown = false;
                  Navigator.pop(context);
                },
                child: const Text("Undo"),
              ),
            ],
          ),
    );
  }

  void dispose() {
    _detector.stopListening();
  }
}
