import 'package:budgethero/core/network/hive_service.dart';
import 'package:budgethero/features/auth/data/data_source/user_data_source.dart';
import 'package:budgethero/features/auth/data/model/user_hive_model.dart';
import 'package:budgethero/features/auth/domain/entity/user_entity.dart';

class UserLocalDatasource implements IUserDataSource {
  final HiveService _hiveService;

  UserLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<UserEntity> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null && user.password == password) {
        return "Login successful";
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      // Handle exceptions and return a failure
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userModel = UserHiveModel.fromEntity(user);
      await _hiveService.registerUser(userModel);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
