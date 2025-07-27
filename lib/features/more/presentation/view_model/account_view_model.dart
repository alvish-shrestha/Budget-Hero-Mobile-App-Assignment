import 'package:budgethero/features/more/domain/use_case/logout_usecase.dart';
import 'package:budgethero/features/more/domain/use_case/update_email_usecase.dart';
import 'package:budgethero/features/more/domain/use_case/update_password_usecase.dart';
import 'package:budgethero/features/more/domain/use_case/update_username_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountViewModel extends Bloc<AccountEvent, AccountState> {
  final UpdateUsernameUsecase _updateUsername;
  final UpdateEmailUsecase _updateEmail;
  final UpdatePasswordUsecase _updatePassword;
  final LogoutUsecase _logout;

  AccountViewModel({
    required UpdateUsernameUsecase updateUsername,
    required UpdateEmailUsecase updateEmail,
    required UpdatePasswordUsecase updatePassword,
    required LogoutUsecase logout,
  }) : _updateUsername = updateUsername,
       _updateEmail = updateEmail,
       _updatePassword = updatePassword,
       _logout = logout,
       super(AccountInitial()) {
    on<UpdateUsernameEvent>(_onUpdateUsername);
    on<UpdateEmailEvent>(_onUpdateEmail);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await _updateUsername(UpdateUsernameParams(event.username));
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (_) => emit(AccountSuccess("Username updated successfully")),
    );
  }

  Future<void> _onUpdateEmail(
    UpdateEmailEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await _updateEmail(UpdateEmailParams(event.email));
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (_) => emit(AccountSuccess("Email updated successfully")),
    );
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await _updatePassword(
      UpdatePasswordParams(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      ),
    );
    result.fold(
      (failure) => emit(AccountError(failure.message)),
      (_) => emit(AccountSuccess("Password updated successfully")),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AccountState> emit) async {
    emit(AccountLoading());
    try {
      await _logout.call();
      emit(LogoutSuccess());
    } catch (e) {
      emit(AccountError("Logout failed: ${e.toString()}"));
    }
  }
}
