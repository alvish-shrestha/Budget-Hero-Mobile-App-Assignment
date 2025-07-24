import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:equatable/equatable.dart';

class GoalState extends Equatable {
  final bool isLoading;
  final List<GoalEntity> goals;
  final String? errorMessage;

  const GoalState({
    required this.isLoading,
    required this.goals,
    this.errorMessage,
  });

  factory GoalState.initial() => const GoalState(
        isLoading: false,
        goals: [],
      );

  GoalState copyWith({
    bool? isLoading,
    List<GoalEntity>? goals,
    String? errorMessage,
  }) {
    return GoalState(
      isLoading: isLoading ?? this.isLoading,
      goals: goals ?? this.goals,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, goals, errorMessage];
}
