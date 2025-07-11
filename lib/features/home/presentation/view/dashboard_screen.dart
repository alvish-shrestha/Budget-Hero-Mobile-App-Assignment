import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
import 'package:budgethero/features/transaction/presentation/view/transaction_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color primaryRed = Color(0xFFF55345);

  @override
  Widget build(BuildContext context) {
    // Dispatch loadTransactions after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadTransactionsForSelectedMonth();
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
          body: _buildDashboardContent(context, state, income, expense, total),
          floatingActionButton: FloatingActionButton(
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
              ).then(
                (_) =>
                    // ignore: use_build_context_synchronously
                    context
                        .read<DashboardViewModel>()
                        .loadTransactionsForSelectedMonth(),
              );
            },
            backgroundColor: primaryRed,
            child: const Icon(Icons.add),
          ),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            child: SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(state.screens.length, (index) {
                  final icons = [
                    Icons.receipt_long,
                    Icons.bar_chart,
                    Icons.account_balance_wallet,
                    Icons.more_horiz,
                  ];
                  return IconButton(
                    icon: Icon(
                      icons[index],
                      color:
                          state.selectedIndex == index
                              ? primaryRed
                              : Colors.black54,
                    ),
                    onPressed:
                        () => context.read<DashboardViewModel>().onItemTapped(
                          index,
                        ),
                  );
                }),
              ),
            ),
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

    // Group transactions by date
    final groupedTransactions = <String, List<_TransactionItem>>{};
    for (var tx in state.transactions) {
      final item = _TransactionItem(
        date: tx.date,
        category: tx.category,
        title: tx.note,
        amount: 'Rs ${tx.amount.toStringAsFixed(2)}',
        isExpense: tx.type == 'expense',
        account: tx.account,
      );

      groupedTransactions.putIfAbsent(tx.date, () => []).add(item);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            context,
            income,
            expense,
            total,
            context.read<DashboardViewModel>().state.selectedMonth,
          ),
          const SizedBox(height: 12),
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (state.transactions.isEmpty)
            const Center(child: Text('No transactions yet'))
          else
            ...groupedTransactions.entries.map((entry) {
              final date = entry.key;
              final items = entry.value;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // All transactions under that date
                    ...items,
                  ],
                ),
              );
            }),
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
                  context.read<DashboardViewModel>().previousMonth();
                },
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('MMMM yyyy').format(
                  context.read<DashboardViewModel>().state.selectedMonth,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.arrow_right, color: Colors.white),
                onPressed: () {
                  context.read<DashboardViewModel>().nextMonth();
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
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String date;
  final String category;
  final String title;
  final String amount;
  final String account;
  final bool isExpense;

  const _TransactionItem({
    required this.date,
    required this.category,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    IconData getCategoryIcon(String category) {
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

    final iconColor = isExpense ? Colors.red : Colors.blue;

    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(
        //         date,
        //         style: const TextStyle(
        //           color: Colors.black,
        //           // fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(getCategoryIcon(category), color: iconColor, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      account,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                isExpense ? ' $amount' : amount,
                style: TextStyle(color: iconColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
