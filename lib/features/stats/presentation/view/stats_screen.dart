import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:budgethero/features/stats/domain/entity/stats_entity.dart';
import 'package:budgethero/features/stats/presentation/view_model/stats_event.dart';
import 'package:budgethero/features/stats/presentation/view_model/stats_state.dart';
import 'package:budgethero/features/stats/presentation/view_model/stats_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          "Transaction Stats",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFFFF5F3),
      body: BlocProvider(
        create: (_) => serviceLocator<StatsViewModel>()..add(LoadStatsEvent()),
        child: BlocBuilder<StatsViewModel, StatsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }

            final stats = state.stats;
            if (stats == null) {
              return const Center(child: Text('No data available.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatsSectionCard(
                    title: "📅 Expenses by Category",
                    child:
                        stats.categoryExpenses.isEmpty
                            ? const Text("No expense data available.")
                            : _buildPieChart(stats.categoryExpenses),
                  ),
                  _StatsSectionCard(
                    title: "📊 Monthly Income vs Expense",
                    child:
                        (stats.totalIncome == 0 && stats.totalExpense == 0)
                            ? const Text("No transaction data available.")
                            : _buildBarChart(
                              stats.totalIncome,
                              stats.totalExpense,
                            ),
                  ),
                  _StatsSectionCard(
                    title: "📈 Expense Trend Over Time",
                    child:
                        stats.expenseTrend.isEmpty
                            ? const Text(
                              "No expense data available for trends.",
                            )
                            : _buildLineChart(stats.expenseTrend),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatsSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _StatsSectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF0ED),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(height: 220, child: child),
          ],
        ),
      ),
    );
  }
}

Widget _buildPieChart(Map<String, double> categoryExpenses) {
  final total = categoryExpenses.values.fold(0.0, (a, b) => a + b);
  final colors = [
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.green,
    Colors.red,
  ];

  final sections =
      categoryExpenses.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value.key;
        final amount = entry.value.value;
        final percent = (amount / total * 100).toStringAsFixed(1);

        return PieChartSectionData(
          value: amount,
          color: colors[index % colors.length],
          title: '$label\n$percent%',
          radius: 60,
          titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        );
      }).toList();

  return PieChart(
    PieChartData(sections: sections, centerSpaceRadius: 40, sectionsSpace: 2),
  );
}

Widget _buildBarChart(double income, double expense) {
  return BarChart(
    BarChartData(
      alignment: BarChartAlignment.spaceAround,
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              switch (value.toInt()) {
                case 0:
                  return const Text(
                    'Income',
                    style: TextStyle(color: Colors.black),
                  );
                case 1:
                  return const Text(
                    'Expense',
                    style: TextStyle(color: Colors.black),
                  );
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ),

        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget:
                (value, meta) => Text(
                  "${value.toInt()}",
                  style: TextStyle(color: Colors.black),
                ),
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      barGroups: [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: income,
              width: 24,
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: expense,
              width: 24,
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildLineChart(List<TrendPoint> trendData) {
  final spots =
      trendData.map((e) {
        final date = DateTime.parse(e.date);
        return FlSpot(date.millisecondsSinceEpoch.toDouble(), e.amount);
      }).toList();

  if (spots.isEmpty) return const Text("No trend data.");

  return LineChart(
    LineChartData(
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.redAccent,
          barWidth: 2,
          dotData: FlDotData(show: true),
        ),
      ],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return Text(
                DateFormat('d').format(date), // Just day number
                style: const TextStyle(fontSize: 10, color: Colors.black),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget:
                (value, meta) => Text(
                  "${value.toInt()}",
                  style: TextStyle(color: Colors.black45),
                ),
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget:
                (value, meta) => Text(
                  "${value.toInt()}",
                  style: const TextStyle(color: Colors.black45),
                ),
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
    ),
  );
}
