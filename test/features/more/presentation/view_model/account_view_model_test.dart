import 'package:bloc_test/bloc_test.dart';
import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/more/domain/use_case/logout_usecase.dart';
import 'package:budgethero/features/more/domain/use_case/update_email_usecase.dart';
import 'package:budgethero/features/more/domain/use_case/update_password_usecase.dart';
import 'package:budgethero/features/more/domain/use_case/update_username_usecase.dart';
import 'package:budgethero/features/more/presentation/view_model/account_view_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Fake Params for fallback
class FakeUpdateUsernameParams extends Fake implements UpdateUsernameParams {}
class FakeUpdateEmailParams extends Fake implements UpdateEmailParams {}
class FakeUpdatePasswordParams extends Fake implements UpdatePasswordParams {}

// Mock UseCases
class MockUpdateUsernameUsecase extends Mock implements UpdateUsernameUsecase {}
class MockUpdateEmailUsecase extends Mock implements UpdateEmailUsecase {}
class MockUpdatePasswordUsecase extends Mock implements UpdatePasswordUsecase {}
class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late AccountViewModel viewModel;
  late MockUpdateUsernameUsecase mockUpdateUsername;
  late MockUpdateEmailUsecase mockUpdateEmail;
  late MockUpdatePasswordUsecase mockUpdatePassword;
  late MockLogoutUsecase mockLogout;

  setUpAll(() {
    registerFallbackValue(FakeUpdateUsernameParams());
    registerFallbackValue(FakeUpdateEmailParams());
    registerFallbackValue(FakeUpdatePasswordParams());
  });

  setUp(() {
    mockUpdateUsername = MockUpdateUsernameUsecase();
    mockUpdateEmail = MockUpdateEmailUsecase();
    mockUpdatePassword = MockUpdatePasswordUsecase();
    mockLogout = MockLogoutUsecase();

    viewModel = AccountViewModel(
      updateUsername: mockUpdateUsername,
      updateEmail: mockUpdateEmail,
      updatePassword: mockUpdatePassword,
      logout: mockLogout,
    );
  });

  group('AccountViewModel Tests', () {
    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, AccountSuccess] on successful UpdateUsernameEvent',
      build: () {
        when(() => mockUpdateUsername(any())).thenAnswer((_) async => const Right(null));
        return viewModel;
      },
      act: (bloc) => bloc.add(UpdateUsernameEvent('newUser')),
      expect: () => [
        isA<AccountLoading>(),
        isA<AccountSuccess>().having((s) => s.message, 'message', "Username updated successfully"),
      ],
    );

    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, AccountError] on failed UpdateUsernameEvent',
      build: () {
        when(() => mockUpdateUsername(any()))
            .thenAnswer((_) async => Left(ApiFailure(message: 'Username error')));
        return viewModel;
      },
      act: (bloc) => bloc.add(UpdateUsernameEvent('failUser')),
      expect: () => [
        isA<AccountLoading>(),
        isA<AccountError>().having((e) => e.message, 'message', "Username error"),
      ],
    );

    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, AccountSuccess] on successful UpdateEmailEvent',
      build: () {
        when(() => mockUpdateEmail(any())).thenAnswer((_) async => const Right(null));
        return viewModel;
      },
      act: (bloc) => bloc.add(UpdateEmailEvent('new@email.com')),
      expect: () => [
        isA<AccountLoading>(),
        isA<AccountSuccess>().having((s) => s.message, 'message', "Email updated successfully"),
      ],
    );

    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, AccountError] on failed UpdateEmailEvent',
      build: () {
        when(() => mockUpdateEmail(any()))
            .thenAnswer((_) async => Left(ApiFailure(message: 'Email error')));
        return viewModel;
      },
      act: (bloc) => bloc.add(UpdateEmailEvent('bad@email.com')),
      expect: () => [
        isA<AccountLoading>(),
        isA<AccountError>().having((e) => e.message, 'message', "Email error"),
      ],
    );

    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, AccountSuccess] on successful UpdatePasswordEvent',
      build: () {
        when(() => mockUpdatePassword(any())).thenAnswer((_) async => const Right(null));
        return viewModel;
      },
      act: (bloc) => bloc.add(UpdatePasswordEvent('oldPass123', 'newPass456')),
      expect: () => [
        isA<AccountLoading>(),
        isA<AccountSuccess>().having((s) => s.message, 'message', "Password updated successfully"),
      ],
    );

    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, AccountError] on failed UpdatePasswordEvent',
      build: () {
        when(() => mockUpdatePassword(any()))
            .thenAnswer((_) async => Left(ApiFailure(message: 'Password error')));
        return viewModel;
      },
      act: (bloc) => bloc.add(UpdatePasswordEvent('wrongOld', 'newOne')),
      expect: () => [
        isA<AccountLoading>(),
        isA<AccountError>().having((e) => e.message, 'message', "Password error"),
      ],
    );

    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, LogoutSuccess] on successful LogoutEvent',
      build: () {
        when(() => mockLogout()).thenAnswer((_) async => {});
        return viewModel;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        isA<AccountLoading>(),
        isA<LogoutSuccess>(),
      ],
    );

    blocTest<AccountViewModel, AccountState>(
      'emits [AccountLoading, AccountError] on failed LogoutEvent',
      build: () {
        when(() => mockLogout()).thenThrow(Exception('Logout failed'));
        return viewModel;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        isA<AccountLoading>(),
        isA<AccountError>().having((e) => e.message, 'message', contains('Logout failed')),
      ],
    );
  });
}
