import 'package:budgethero/core/network/api_service.dart';

abstract class IAccountRemoteDatasource {
  Future<void> updateUsername(String username);
  Future<void> updateEmail(String email);
  Future<void> updatePassword(String oldPassword, String newPassword);
}

class AccountRemoteDatasource implements IAccountRemoteDatasource {
  final ApiService _apiService;

  AccountRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<void> updateUsername(String username) async {
    await _apiService.dio.put(
      'auth/update-username',
      data: {'username': username},
    );
  }

  @override
  Future<void> updateEmail(String email) async {
    await _apiService.dio.put('auth/update-email', data: {'email': email});
  }

  @override
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    await _apiService.dio.put(
      'auth/update-password',
      data: {'oldPassword': oldPassword, 'newPassword': newPassword},
    );
  }
}
