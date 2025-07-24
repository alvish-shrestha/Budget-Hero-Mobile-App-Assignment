import 'package:budgethero/features/stats/domain/entity/stats_entity.dart';
import 'package:equatable/equatable.dart';

class StatsState extends Equatable {
  final bool isLoading;
  final StatsEntity? stats;
  final String? errorMessage;

  const StatsState({
    required this.isLoading,
    this.stats,
    this.errorMessage,
  });

  factory StatsState.initial() => const StatsState(isLoading: false);

  StatsState copyWith({
    bool? isLoading,
    StatsEntity? stats,
    String? errorMessage,
  }) {
    return StatsState(
      isLoading: isLoading ?? this.isLoading,
      stats: stats ?? this.stats,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, stats, errorMessage];
}
