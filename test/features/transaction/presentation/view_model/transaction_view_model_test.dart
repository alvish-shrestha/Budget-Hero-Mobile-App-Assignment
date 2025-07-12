import 'package:bloc_test/bloc_test.dart';
import 'package:budgethero/features/transaction/domain/entity/transaction_entity.dart';
import 'package:budgethero/features/transaction/domain/use_case/add_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/delete_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/get_all_transaction_usecase.dart';
import 'package:budgethero/features/transaction/domain/use_case/update_transaction_usecase.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_event.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_state.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

class MockAddTransactionUsecase extends Mock implements AddTransactionUsecase {}

class MockGetAllTransactionsUsecase extends Mock
    implements GetAllTransactionsUsecase {}

class MockDeleteTransactionUsecase extends Mock
    implements DeleteTransactionUsecase {}

class MockUpdateTransactionUsecase extends Mock
    implements UpdateTransactionUsecase {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockAddTransactionUsecase mockAddTransactionUsecase;
  late MockGetAllTransactionsUsecase mockGetAllTransactionsUsecase;
  late MockDeleteTransactionUsecase mockDeleteTransactionUsecase;
  late MockUpdateTransactionUsecase mockUpdateTransactionUsecase;
  late TransactionViewModel transactionViewModel;

  final dateStr = DateFormat("yyyy-MM-dd").format(DateTime(2025, 7, 10));
  final transaction = TransactionEntity(
    id: '1',
    amount: 100,
    category: 'Food',
    account: 'Cash',
    type: 'expense',
    date: dateStr,
    note: 'Lunch',
    description: '',
  );

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(AddTransactionParams(transaction: transaction));
  });

  setUp(() {
    mockAddTransactionUsecase = MockAddTransactionUsecase();
    mockGetAllTransactionsUsecase = MockGetAllTransactionsUsecase();
    mockDeleteTransactionUsecase = MockDeleteTransactionUsecase();
    mockUpdateTransactionUsecase = MockUpdateTransactionUsecase();

    transactionViewModel = TransactionViewModel(
      addTransactionUsecase: mockAddTransactionUsecase,
      getAllTransactionsUsecase: mockGetAllTransactionsUsecase,
      deleteTransactionUsecase: mockDeleteTransactionUsecase,
      updateTransactionUsecase: mockUpdateTransactionUsecase,
    );
  });

  blocTest<TransactionViewModel, TransactionState>(
    'emits [loading, loaded] when GetAllTransactionsEvent succeeds',
    build: () {
      when(
        () => mockGetAllTransactionsUsecase(),
      ).thenAnswer((_) async => Right([transaction]));
      return transactionViewModel;
    },
    act: (bloc) => bloc.add(GetAllTransactionsEvent()),
    expect:
        () => [
          const TransactionState.initial().copyWith(isLoading: true),
          const TransactionState.initial().copyWith(
            isLoading: false,
            isSuccess: true,
            transactions: [transaction],
          ),
        ],
    verify: (_) => verify(() => mockGetAllTransactionsUsecase()).called(1),
  );

  blocTest<TransactionViewModel, TransactionState>(
    'emits [navigateToAdd: true] when NavigateToAddTransactionViewEvent is added',
    build: () {
      return TransactionViewModel(
        addTransactionUsecase: mockAddTransactionUsecase,
        getAllTransactionsUsecase: mockGetAllTransactionsUsecase,
        deleteTransactionUsecase: mockDeleteTransactionUsecase,
        updateTransactionUsecase: mockUpdateTransactionUsecase,
      );
    },
    act: (bloc) => bloc.add(NavigateToAddTransactionViewEvent()),
    expect:
        () => [const TransactionState.initial().copyWith(navigateToAdd: true)],
  );
}
