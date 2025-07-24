import 'package:equatable/equatable.dart';

class GoalEntity extends Equatable {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;

  const GoalEntity({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
  });

  @override
  List<Object?> get props => [id, title, targetAmount, savedAmount, deadline];
}
