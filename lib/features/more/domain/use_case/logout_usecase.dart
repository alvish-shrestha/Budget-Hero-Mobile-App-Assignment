import 'package:budgethero/core/network/hive_service.dart';
import 'package:budgethero/core/network/secure_storage.dart';

class LogoutUsecase {
  final HiveService _hiveService;

  LogoutUsecase({required HiveService hiveService}) : _hiveService = hiveService;

  Future<void> call() async {
    await SecureStorage.deleteToken();
    await _hiveService.clearUser();
  }
}
