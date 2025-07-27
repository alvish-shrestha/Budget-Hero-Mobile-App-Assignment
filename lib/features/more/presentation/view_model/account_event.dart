part of 'account_view_model.dart';

abstract class AccountEvent {}

class UpdateUsernameEvent extends AccountEvent {
  final String username;
  UpdateUsernameEvent(this.username);
}

class UpdateEmailEvent extends AccountEvent {
  final String email;
  UpdateEmailEvent(this.email);
}

class UpdatePasswordEvent extends AccountEvent {
  final String oldPassword;
  final String newPassword;
  UpdatePasswordEvent(this.oldPassword, this.newPassword);
}

class LogoutEvent extends AccountEvent {}