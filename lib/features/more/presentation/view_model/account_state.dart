part of 'account_view_model.dart';

abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountSuccess extends AccountState {
  final String message;
  AccountSuccess(this.message);
}

class AccountError extends AccountState {
  final String message;
  AccountError(this.message);
}

class LogoutSuccess extends AccountState {}