import 'package:dartz/dartz.dart';
import 'package:budgethero/core/error/failure.dart';
import '../repository/forgot_password_repository.dart';

class ForgotPasswordUsecase {
  final IForgotPasswordRepository repository;

  ForgotPasswordUsecase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    try {
      await repository.requestReset(email);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
