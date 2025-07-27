import 'package:budgethero/features/forgot_password/data/data_source/remote_datasource/forgot_password_remote_datasource.dart';
import 'package:budgethero/features/forgot_password/domain/repository/forgot_password_repository.dart';

class ForgotPasswordRemoteRepository implements IForgotPasswordRepository {
  final IForgotPasswordRemoteDatasource remoteDatasource;

  ForgotPasswordRemoteRepository({required this.remoteDatasource});

  @override
  Future<void> requestReset(String email) async {
    await remoteDatasource.requestReset(email);
  }
}
