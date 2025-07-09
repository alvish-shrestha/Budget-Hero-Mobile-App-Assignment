class TransactionEntity {
  final String type;
  final String date;
  final double amount;
  final String category;
  final String account;
  final String note;
  final String description;

  TransactionEntity({
    required this.type,
    required this.date,
    required this.amount,
    required this.category,
    required this.account,
    required this.note,
    required this.description,
  });
}
