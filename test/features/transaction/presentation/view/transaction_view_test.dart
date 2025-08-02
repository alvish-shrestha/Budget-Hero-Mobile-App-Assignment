import 'package:budgethero/features/transaction/presentation/view/transaction_view.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_state.dart';
import 'package:budgethero/features/transaction/presentation/view_model/transaction_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:async';

class MockTransactionViewModel extends Mock implements TransactionViewModel {}

void main() {
  late TransactionViewModel mockBloc;

  setUp(() {
    mockBloc = MockTransactionViewModel();
    when(() => mockBloc.state).thenReturn(
      const TransactionState(
        isLoading: false,
        isSuccess: false,
        transactions: [],
      ),
    );

    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream<TransactionState>.empty());
  });

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<TransactionViewModel>.value(
          value: mockBloc,
          child: child,
        ),
      ),
    );
  }

  testWidgets('renders Add Transaction view correctly', (tester) async {
    when(() => mockBloc.state).thenReturn(const TransactionState.initial());

    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(buildTestableWidget(TransactionView()));

    await tester.pumpAndSettle();

    expect(find.text('Add Transaction'), findsOneWidget);
    expect(find.byKey(const Key('Amount')), findsOneWidget);
    expect(find.byKey(const Key('Note')), findsOneWidget);
    expect(find.byKey(const Key('Description')), findsOneWidget);
  });
}
