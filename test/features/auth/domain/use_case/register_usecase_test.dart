import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/auth/domain/entity/user_entity.dart';
import 'package:budgethero/features/auth/domain/use_case/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late UserRegisterUsecase usecase;
  late AuthRepoMock repoMock;

  setUp(() {
    repoMock = AuthRepoMock();
    usecase = UserRegisterUsecase(userRepository: repoMock);
  });

  const registerParams = RegisterUsecaseParams(
    username: 'TestUser',
    email: 'test@example.com',
    password: 'password123',
    confirmPassword: 'password123',
  );

  final userEntity = UserEntity(
    username: 'TestUser',
    email: 'test@example.com',
    password: 'password123',
    confirmPassword: 'password123',
  );

  group('UserRegisterUsecase', () {
    test(
      'should return signup success when registration is successful',
      () async {
        when(
          () => repoMock.registerUser(userEntity),
        ).thenAnswer((_) async => const Right(null));

        final result = await usecase(registerParams);

        expect(result, const Right(null));
        verify(() => repoMock.registerUser(userEntity)).called(1);
      },
    );

    test('should return Failure when registration fails', () async {
      final failure = ApiFailure(message: "Email already exists");
      when(
        () => repoMock.registerUser(userEntity),
      ).thenAnswer((_) async => Left(failure));

      final result = await usecase(registerParams);

      expect(result, Left(failure));
      verify(() => repoMock.registerUser(userEntity)).called(1);
    });
  });
}
