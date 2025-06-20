import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_view_model.dart';
import 'package:budgethero/features/home/presentation/view_model/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onAddTransaction;

  const DashboardScreen({super.key, required this.onAddTransaction});

  static const Color primaryRed = Color(0xFFF55345);

  static final List<Widget> _widgetOptions = <Widget>[
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF55345),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 50,
              left: 16,
              right: 16,
              bottom: 16,
            ),
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
                  children: const [
                    Icon(Icons.arrow_left, color: Colors.white),
                    SizedBox(width: 8),
                    Text("May 2025", style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_right, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Summary tile stays white
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _SummaryTile(
                        label: 'Income',
                        value: '8700.00',
                        color: Colors.blue,
                      ),
                      _SummaryTile(
                        label: 'Exp',
                        value: '8700.00',
                        color: Colors.red,
                      ),
                      _SummaryTile(
                        label: 'Total',
                        value: '8700.00',
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Transaction Items on white background
          _TransactionItem(
            date: '02 Fri',
            categoryIcon: Icons.fastfood,
            category: 'Food',
            title: 'Momo',
            amount: 'Rs 600.00',
            isExpense: true,
            account: 'Bank Account',
          ),
          _TransactionItem(
            date: '02 Fri',
            categoryIcon: Icons.phone_android,
            category: 'Balance',
            title: 'Phone',
            amount: 'Rs 100.00',
            isExpense: true,
            account: 'Bank Account',
          ),
          _TransactionItem(
            date: '',
            categoryIcon: Icons.attach_money,
            category: 'Salary',
            title: 'May Salary Rec...',
            amount: 'Rs 150235.00',
            isExpense: false,
            account: 'Bank Account',
          ),
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<DashboardViewModel>(),
      child: BlocBuilder<DashboardViewModel, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            body: _widgetOptions[state.selectedIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: onAddTransaction,
              backgroundColor: const Color(0xFFF55345),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.receipt_long,
                        color:
                            state.selectedIndex == 0
                                ? const Color(0xFFF55345)
                                : Colors.black54,
                      ),
                      onPressed:
                          () => context.read<DashboardViewModel>().onItemTapped(
                            0,
                          ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.bar_chart,
                        color:
                            state.selectedIndex == 1
                                ? const Color(0xFFF55345)
                                : Colors.black54,
                      ),
                      onPressed:
                          () => context.read<DashboardViewModel>().onItemTapped(
                            1,
                          ),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: Icon(
                        Icons.wifi_tethering,
                        color:
                            state.selectedIndex == 2
                                ? const Color(0xFFF55345)
                                : Colors.black54,
                      ),
                      onPressed:
                          () => context.read<DashboardViewModel>().onItemTapped(
                            2,
                          ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color:
                            state.selectedIndex == 3
                                ? const Color(0xFFF55345)
                                : Colors.black54,
                      ),
                      onPressed:
                          () => context.read<DashboardViewModel>().onItemTapped(
                            3,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
  final IconData categoryIcon;
  final String category;
  final String title;
  final String amount;
  final String account;
  final bool isExpense;

  const _TransactionItem({
    required this.date,
    required this.categoryIcon,
    required this.category,
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (date.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  amount,
                  style: TextStyle(
                    color: isExpense ? Colors.black54 : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(categoryIcon, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                isExpense ? '- $amount' : amount,
                style: TextStyle(
                  color: isExpense ? Colors.white70 : Colors.lightGreenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
