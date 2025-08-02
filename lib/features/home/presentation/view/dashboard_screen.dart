import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/core/utils/shake_handler.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_event.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
import 'package:budgethero/features/navigation/widget/bottom_nav_bar.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/presentation/view/transaction_view.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color primaryRed = Color(0xFFF55345);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShakeHandler().init(context);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().add(
        LoadSelectedMonthTransactionsEvent(),
      );
    });

    return BlocBuilder<DashboardViewModel, DashboardState>(
      builder: (context, state) {
        double income = 0;
        double expense = 0;

        for (var tx in state.transactions) {
          if (tx.type == 'income') {
            income += tx.amount;
          } else {
            expense += tx.amount;
          }
        }

        double total = income - expense;

        return Scaffold(
          backgroundColor: Colors.white,
          body: _buildDashboardContent(context, state, income, expense, total),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryRed,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<TransactionViewModel>(),
                        child: TransactionView(),
                      ),
                ),
              ).then((_) {
                // ignore: use_build_context_synchronously
                context.read<DashboardViewModel>().add(
                  LoadSelectedMonthTransactionsEvent(),
                );
              });
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const MainBottomNavBar(
            activeColor: DashboardScreen.primaryRed,
          ),
        );
      },
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    DashboardState state,
    double income,
    double expense,
    double total,
  ) {
    if (state.selectedIndex != 0) {
      return state.screens[state.selectedIndex];
    }

    final grouped = <String, List<_TransactionItem>>{};
    for (var tx in state.transactions) {
      final txDate = DateTime.parse(tx.date);
      final formattedDate = DateFormat('yyyy-MM-dd').format(txDate);

      grouped
          .putIfAbsent(formattedDate, () => [])
          .insert(0, _TransactionItem(transaction: tx));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context, income, expense, total, state.selectedMonth),
          const SizedBox(height: 12),
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (state.transactions.isEmpty)
            const Center(child: Text("No transactions yet"))
          else
            ...grouped.entries.map(
              (entry) =>
                  _buildTransactionGroup(context, entry.key, entry.value),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionGroup(
    BuildContext context,
    String date,
    List<_TransactionItem> items,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ...items.map(
            (item) => Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text(
                          'Do you want to delete?',
                          style: TextStyle(color: Colors.red),
                        ),
                        content: const Text(
                          'Are you sure you want to delete this transaction?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
              },
              onDismissed: (_) {
                final deletedTx = item.transaction;
                context.read<DashboardViewModel>().add(
                  DeleteTransactionEvent(item.transaction.id),
                );

                ShakeHandler().setLastDeleted(deletedTx);

                showMySnackbar(
                  context: context,
                  content: "Transaction deleted (shake to undo)",
                  color: Colors.green,
                );
              },
              child: item,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    double income,
    double expense,
    double total,
    DateTime selectedMonth,
  ) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          const Text(
            "Trans.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left, color: Colors.white),
                onPressed: () {
                  context.read<DashboardViewModel>().add(
                    GoToPreviousMonthEvent(),
                  );
                },
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMMM yyyy').format(selectedMonth),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_right, color: Colors.white),
                onPressed: () {
                  context.read<DashboardViewModel>().add(GoToNextMonthEvent());
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _SummaryTile(
                  label: 'Income',
                  value: income.toStringAsFixed(2),
                  color: Colors.blue,
                ),
                _SummaryTile(
                  label: 'Expenses',
                  value: expense.toStringAsFixed(2),
                  color: Colors.red,
                ),
                _SummaryTile(
                  label: 'Total',
                  value: total.toStringAsFixed(2),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final TransactionEntity transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    IconData getIcon(String category) {
      switch (category.toLowerCase()) {
        case 'food':
          return Icons.fastfood;
        case 'transport':
          return Icons.directions_car;
        case 'bills':
          return Icons.receipt;
        case 'shopping':
          return Icons.shopping_bag;
        case 'salary':
          return Icons.attach_money;
        case 'gift':
          return Icons.card_giftcard;
        case 'bonus':
          return Icons.star;
        default:
          return Icons.category;
      }
    }

    final color = transaction.type == 'expense' ? Colors.red : Colors.blue;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: context.read<TransactionViewModel>(),
                  child: TransactionView(transactionToEdit: transaction),
                ),
          ),
        ).then((_) {
          // ignore: use_build_context_synchronously
          context.read<DashboardViewModel>().add(
            LoadSelectedMonthTransactionsEvent(),
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(getIcon(transaction.category), color: color, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.note,
                    style: TextStyle(color: color, fontSize: 16),
                  ),
                  Text(
                    transaction.account,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Text(
              'Rs ${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
