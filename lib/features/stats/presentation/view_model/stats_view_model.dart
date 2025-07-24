import 'package:budgethero/features/stats/domain/use_case/get_stats_usecase.dart';
import 'package:budgethero/features/stats/presentation/view_model/stats_event.dart';
import 'package:budgethero/features/stats/presentation/view_model/stats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsViewModel extends Bloc<StatsEvent, StatsState> {
  final GetStatsUsecase _getStatsUsecase;

  StatsViewModel({required GetStatsUsecase getStatsUsecase})
      : _getStatsUsecase = getStatsUsecase,
        super(StatsState.initial()) {
    on<LoadStatsEvent>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadStatsEvent event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getStatsUsecase();

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ));
      },
      (statsData) {
        emit(state.copyWith(
          isLoading: false,
          stats: statsData,
        ));
      },
    );
  }
}
