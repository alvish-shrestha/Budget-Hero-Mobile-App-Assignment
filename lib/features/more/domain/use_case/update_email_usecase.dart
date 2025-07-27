import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/more/domain/repository/account_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateEmailParams extends Equatable {
  final String email;
  const UpdateEmailParams(this.email);

  @override
  List<Object?> get props => [email];
}

class UpdateEmailUsecase implements UseCaseWithParams<void, UpdateEmailParams> {
  final IAccountRepository repository;

  UpdateEmailUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateEmailParams params) {
    return repository.updateEmail(params.email);
  }
}