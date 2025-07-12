import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budgethero/features/auth/presentation/view/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('renders email, password fields and SIGN IN button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginScreen())));

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
    });
    testWidgets('shows error if email is empty', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginScreen())));

      // Tap login without entering anything
      await tester.tap(find.text('SIGN IN'));
      await tester.pump();

      expect(find.text('Please enter an email'), findsOneWidget);
    });
    testWidgets('shows error if password is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: LoginScreen())));

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.tap(find.text('SIGN IN'));
      await tester.pump();

      expect(find.text('Please enter password'), findsOneWidget);
    });
  });
}
