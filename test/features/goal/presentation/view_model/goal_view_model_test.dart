import 'package:bloc_test/bloc_test.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/goal/domain/entity/goal_entity.dart';
import 'package:budgethero/features/goal/domain/use_case/add_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/contribute_to_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/delete_goal_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/get_all_goals_usecase.dart';
import 'package:budgethero/features/goal/domain/use_case/update_goal_usecase.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_event.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_state.dart';
import 'package:budgethero/features/goal/presentation/view_model/goal_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeAddGoalParams extends Fake implements AddGoalParams {}

class FakeUpdateGoalParams extends Fake implements UpdateGoalParams {}

class FakeDeleteGoalParams extends Fake implements DeleteGoalParams {}

class FakeContributeToGoalParams extends Fake
    implements ContributeToGoalParams {}

class MockAddGoalUsecase extends Mock implements AddGoalUsecase {}

class MockGetAllGoalsUsecase extends Mock implements GetAllGoalsUsecase {}

class MockDeleteGoalUsecase extends Mock implements DeleteGoalUsecase {}

class MockUpdateGoalUsecase extends Mock implements UpdateGoalUsecase {}

class MockContributeGoalUsecase extends Mock
    implements ContributeToGoalUsecase {}

void main() {
  late GoalViewModel viewModel;
  late MockAddGoalUsecase mockAddUsecase;
  late MockGetAllGoalsUsecase mockGetAllUsecase;
  late MockDeleteGoalUsecase mockDeleteUsecase;
  late MockUpdateGoalUsecase mockUpdateUsecase;
  late MockContributeGoalUsecase mockContributeUsecase;

  final testGoals = [
    GoalEntity(
      id: '1',
      title: 'Emergency Fund',
      targetAmount: 1000,
      savedAmount: 300,
      deadline: DateTime.parse('2025-12-31'),
    ),
    GoalEntity(
      id: '2',
      title: 'Vacation',
      targetAmount: 2000,
      savedAmount: 500,
      deadline: DateTime.parse('2026-06-01'),
    ),
  ];

  setUpAll(() {
    registerFallbackValue(FakeAddGoalParams());
    registerFallbackValue(FakeUpdateGoalParams());
    registerFallbackValue(FakeDeleteGoalParams());
    registerFallbackValue(FakeContributeToGoalParams());
  });

  setUp(() {
    mockAddUsecase = MockAddGoalUsecase();
    mockGetAllUsecase = MockGetAllGoalsUsecase();
    mockDeleteUsecase = MockDeleteGoalUsecase();
    mockUpdateUsecase = MockUpdateGoalUsecase();
    mockContributeUsecase = MockContributeGoalUsecase();

    viewModel = GoalViewModel(
      getAllGoals: mockGetAllUsecase,
      addGoal: mockAddUsecase,
      updateGoal: mockUpdateUsecase,
      deleteGoal: mockDeleteUsecase,
      contributeGoal: mockContributeUsecase,
    );
  });

  group('GoalViewModel Tests', () {
    blocTest<GoalViewModel, GoalState>(
      'emits loading and loaded state when LoadGoalsEvent is successful',
      build: () {
        when(
          () => mockGetAllUsecase(),
        ).thenAnswer((_) async => Right(testGoals));
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadGoalsEvent()),
      expect:
          () => [
            GoalState.initial().copyWith(isLoading: true, errorMessage: null),
            GoalState.initial().copyWith(isLoading: false, goals: testGoals),
          ],
    );

    blocTest<GoalViewModel, GoalState>(
      'emits loading and error state when LoadGoalsEvent fails',
      build: () {
        when(() => mockGetAllUsecase()).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Failed to fetch goals')),
        );
        return viewModel;
      },
      act: (bloc) => bloc.add(LoadGoalsEvent()),
      expect:
          () => [
            GoalState.initial().copyWith(isLoading: true, errorMessage: null),
            GoalState.initial().copyWith(
              isLoading: false,
              errorMessage: 'Failed to fetch goals',
            ),
          ],
    );

    blocTest<GoalViewModel, GoalState>(
      'emits loading and loaded state after AddGoalEvent success',
      build: () {
        when(
          () => mockAddUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllUsecase(),
        ).thenAnswer((_) async => Right(testGoals));
        return viewModel;
      },
      act: (bloc) => bloc.add(AddGoalEvent(testGoals[0])),
      expect:
          () => [
            GoalState.initial().copyWith(isLoading: true),
            GoalState.initial().copyWith(isLoading: false, goals: testGoals),
          ],
    );

    blocTest<GoalViewModel, GoalState>(
      'emits loading and loaded state after UpdateGoalEvent success',
      build: () {
        when(
          () => mockUpdateUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllUsecase(),
        ).thenAnswer((_) async => Right(testGoals));
        return viewModel;
      },
      act: (bloc) => bloc.add(UpdateGoalEvent(testGoals[0])),
      expect:
          () => [
            GoalState.initial().copyWith(isLoading: true),
            GoalState.initial().copyWith(isLoading: false, goals: testGoals),
          ],
    );

    blocTest<GoalViewModel, GoalState>(
      'emits loading and loaded state after DeleteGoalEvent success',
      build: () {
        when(
          () => mockDeleteUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllUsecase(),
        ).thenAnswer((_) async => Right(testGoals));
        return viewModel;
      },
      act: (bloc) => bloc.add(DeleteGoalEvent('1')),
      expect:
          () => [
            GoalState.initial().copyWith(isLoading: true),
            GoalState.initial().copyWith(isLoading: false, goals: testGoals),
          ],
    );

    blocTest<GoalViewModel, GoalState>(
      'emits loading and loaded state after ContributeToGoalEvent success',
      build: () {
        when(
          () => mockContributeUsecase(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetAllUsecase(),
        ).thenAnswer((_) async => Right(testGoals));
        return viewModel;
      },
      act: (bloc) => bloc.add(ContributeToGoalEvent(id: '1', amount: 200)),
      expect:
          () => [
            GoalState.initial().copyWith(isLoading: true),
            GoalState.initial().copyWith(isLoading: false, goals: testGoals),
          ],
    );
  });
}
