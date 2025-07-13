import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/auth/domain/use_case/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late UserLoginUsecase usecase;
  late AuthRepoMock repoMock;

  setUp(() {
    repoMock = AuthRepoMock();
    usecase = UserLoginUsecase(userRepository: repoMock);
  });

  group('UserLoginUsecase', () {
    test("should return success when login is successful", () async {
      const params = LoginUsecaseParams(
        email: "test@example.com",
        password: "password",
      );
      const userId = "user_abc123";
      when(
        () => repoMock.loginUser(params.email, params.password),
      ).thenAnswer((_) async => const Right(userId));

      final result = await usecase(params);

      expect(result, const Right(userId));
      verify(() => repoMock.loginUser(params.email, params.password)).called(1);
    });

    test("should return Failure when login fails", () async {
      const params = LoginUsecaseParams(
        email: "wrong@example.com",
        password: "wrongpassword",
      );
      final failure = ApiFailure(message: "Invalid credentials");

      when(
        () => repoMock.loginUser(params.email, params.password),
      ).thenAnswer((_) async => Left(failure));

      final result = await usecase(params);

      expect(result, Left(failure));
      verify(() => repoMock.loginUser(params.email, params.password)).called(1);
    });
  });
}
