import 'package:budgethero/core/error/failure.dart';
import 'package:budgethero/features/more/domain/repository/account_repository.dart';
import 'package:budgethero/app/use_case/use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateUsernameParams extends Equatable {
  final String username;
  const UpdateUsernameParams(this.username);

  @override
  List<Object?> get props => [username];
}

class UpdateUsernameUsecase implements UseCaseWithParams<void, UpdateUsernameParams> {
  final IAccountRepository repository;

  UpdateUsernameUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateUsernameParams params) {
    return repository.updateUsername(params.username);
  }
}