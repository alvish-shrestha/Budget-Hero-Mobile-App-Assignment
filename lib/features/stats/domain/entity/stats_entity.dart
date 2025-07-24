class StatsEntity {
  final Map<String, double> categoryExpenses;
  final double totalIncome;
  final double totalExpense;
  final List<TrendPoint> expenseTrend;

  const StatsEntity({
    required this.categoryExpenses,
    required this.totalIncome,
    required this.totalExpense,
    required this.expenseTrend,
  });
}

class TrendPoint {
  final String date;
  final double amount;

  const TrendPoint({required this.date, required this.amount});
}
