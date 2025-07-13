import 'package:bloc_test/bloc_test.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/domain/use_case/add_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/delete_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/update_transaction_usecase.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_event.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_state.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddTransactionUsecase extends Mock implements AddTransactionUsecase {}
class MockGetAllTransactionsUsecase extends Mock implements GetAllTransactionsUsecase {}
class MockDeleteTransactionUsecase extends Mock implements DeleteTransactionUsecase {}
class MockUpdateTransactionUsecase extends Mock implements UpdateTransactionUsecase {}

void main() {
  late TransactionViewModel viewModel;
  late MockAddTransactionUsecase mockAddUsecase;
  late MockGetAllTransactionsUsecase mockGetAllUsecase;
  late MockDeleteTransactionUsecase mockDeleteUsecase;
  late MockUpdateTransactionUsecase mockUpdateUsecase;

  setUp(() {
    mockAddUsecase = MockAddTransactionUsecase();
    mockGetAllUsecase = MockGetAllTransactionsUsecase();
    mockDeleteUsecase = MockDeleteTransactionUsecase();
    mockUpdateUsecase = MockUpdateTransactionUsecase();

    viewModel = TransactionViewModel(
      addTransactionUsecase: mockAddUsecase,
      getAllTransactionsUsecase: mockGetAllUsecase,
      deleteTransactionUsecase: mockDeleteUsecase,
      updateTransactionUsecase: mockUpdateUsecase,
    );
  });

  final testTransactions = [
    TransactionEntity(
      id: '1',
      amount: 100,
      type: 'expense',
      category: 'Food',
      account: 'Cash',
      description: 'Lunch',
      note: '',
      date: DateTime(2025, 7, 1).toIso8601String(),
    ),
    TransactionEntity(
      id: '2',
      amount: 50,
      type: 'income',
      category: 'Salary',
      account: 'Bank',
      description: 'Part-time',
      note: '',
      date: DateTime(2025, 7, 2).toIso8601String(),
    ),
  ];

  group('TransactionViewModel BLoC Tests', () {
    blocTest<TransactionViewModel, TransactionState>(
      'emits [isLoading: true, isSuccess: true, transactions] when GetAllTransactionsEvent succeeds',
      build: () {
        when(() => mockGetAllUsecase())
            .thenAnswer((_) async => Right(testTransactions));
        return viewModel;
      },
      act: (bloc) => bloc.add(GetAllTransactionsEvent()),
      expect: () => [
        TransactionState.initial().copyWith(isLoading: true),
        TransactionState.initial().copyWith(
          isLoading: false,
          isSuccess: true,
          transactions: testTransactions,
        ),
      ],
      verify: (_) {
        verify(() => mockGetAllUsecase()).called(1);
      },
    );

    blocTest<TransactionViewModel, TransactionState>(
      'emits [isLoading: false, errorMessage] when GetAllTransactionsEvent fails',
      build: () {
        when(() => mockGetAllUsecase()).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Server error')),
        );
        return viewModel;
      },
      act: (bloc) => bloc.add(GetAllTransactionsEvent()),
      expect: () => [
        TransactionState.initial().copyWith(isLoading: true),
        TransactionState.initial().copyWith(
          isLoading: false,
          errorMessage: 'Server error',
        ),
      ],
    );

    blocTest<TransactionViewModel, TransactionState>(
      'calls GetAllTransactionsEvent after successful DeleteTransactionEvent',
      build: () {
        when(() => mockDeleteUsecase('1')).thenAnswer((_) async => const Right(null));
        when(() => mockGetAllUsecase()).thenAnswer((_) async => Right(testTransactions));
        return viewModel;
      },
      act: (bloc) {
        bloc.add(DeleteTransactionEvent('1'));
      },
      expect: () => [
        // No state change directly from delete, but getAll is triggered after
        TransactionState.initial().copyWith(isLoading: true),
        TransactionState.initial().copyWith(
          isLoading: false,
          isSuccess: true,
          transactions: testTransactions,
        ),
      ],
      verify: (bloc) {
        verify(() => mockDeleteUsecase('1')).called(1);
        verify(() => mockGetAllUsecase()).called(1);
      },
    );
  });
}
