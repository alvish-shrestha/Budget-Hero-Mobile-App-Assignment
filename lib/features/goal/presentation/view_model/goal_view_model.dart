import 'package:budgethero/features/goal/domain/use_case/add_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/contribute_to_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/delete_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/get_all_goals_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/update_goal_usecase.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_event.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoalViewModel extends Bloc<GoalEvent, GoalState> {
  final GetAllGoalsUsecase _getAllGoals;
  final AddGoalUsecase _addGoal;
  final UpdateGoalUsecase _updateGoal;
  final DeleteGoalUsecase _deleteGoal;
  final ContributeToGoalUsecase _contributeGoal;

  GoalViewModel({
    required GetAllGoalsUsecase getAllGoals,
    required AddGoalUsecase addGoal,
    required UpdateGoalUsecase updateGoal,
    required DeleteGoalUsecase deleteGoal,
    required ContributeToGoalUsecase contributeGoal,
  }) : _getAllGoals = getAllGoals,
       _addGoal = addGoal,
       _updateGoal = updateGoal,
       _deleteGoal = deleteGoal,
       _contributeGoal = contributeGoal,
       super(GoalState.initial()) {
    on<LoadGoalsEvent>(_onLoadGoals);
    on<AddGoalEvent>(_onAddGoal);
    on<UpdateGoalEvent>(_onUpdateGoal);
    on<DeleteGoalEvent>(_onDeleteGoal);
    on<ContributeToGoalEvent>(_onContributeGoal);
  }

  Future<void> _onLoadGoals(
    LoadGoalsEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _getAllGoals();
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (goals) => emit(state.copyWith(isLoading: false, goals: goals)),
    );
  }

  Future<void> _onAddGoal(AddGoalEvent event, Emitter<GoalState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await _addGoal(AddGoalParams(goal: event.goal));
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => add(LoadGoalsEvent()),
    );
  }

  Future<void> _onUpdateGoal(
    UpdateGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _updateGoal(UpdateGoalParams(goal: event.goal));
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => add(LoadGoalsEvent()),
    );
  }

  Future<void> _onDeleteGoal(
    DeleteGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _deleteGoal(DeleteGoalParams(id: event.id));
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => add(LoadGoalsEvent()),
    );
  }

  Future<void> _onContributeGoal(
    ContributeToGoalEvent event,
    Emitter<GoalState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _contributeGoal(
      ContributeToGoalParams(id: event.id, amount: event.amount),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => add(LoadGoalsEvent()),
    );
  }
}
