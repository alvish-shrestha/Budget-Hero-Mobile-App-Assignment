import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class GoalEvent {}

class LoadGoalsEvent extends GoalEvent {}

class AddGoalEvent extends GoalEvent {
  final GoalEntity goal;

  AddGoalEvent(this.goal);
}

class UpdateGoalEvent extends GoalEvent {
  final GoalEntity goal;

  UpdateGoalEvent(this.goal);
}

class DeleteGoalEvent extends GoalEvent {
  final String id;

  DeleteGoalEvent(this.id);
}

class ContributeToGoalEvent extends GoalEvent {
  final String id;
  final double amount;

  ContributeToGoalEvent({
    required this.id,
    required this.amount,
  });
}
