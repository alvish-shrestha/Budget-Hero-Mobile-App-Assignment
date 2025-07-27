import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/more/domain/repository/account_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdatePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  const UpdatePasswordParams({required this.oldPassword, required this.newPassword});

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class UpdatePasswordUsecase implements UseCaseWithParams<void, UpdatePasswordParams> {
  final IAccountRepository repository;

  UpdatePasswordUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdatePasswordParams params) {
    return repository.updatePassword(params.oldPassword, params.newPassword);
  }
}