import 'package:budgethero/app/constant/api_endpoints.dart';
import 'package:budgethero/core/network/api_service.dart';
import 'package:budgethero/core/network/secure_storage.dart';
import 'package:budgethero/features/auth/data/data_source/user_data_source.dart';
import 'package:budgethero/features/auth/data/model/user_api_model.dart';
import 'package:budgethero/features/auth/domain/entity/user_entity.dart';
import 'package:dio/dio.dart';

class UserRemoteDatasource implements IUserDataSource {
  final ApiService _apiService;

  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<UserEntity> getCurrentUser() {
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        final token = response.data["token"];
        await SecureStorage.saveToken(token);
        return token;
      } else {
        throw Exception("Failed to login: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to login: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      final userApiModel = UserApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );

      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception("Failed to register user: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to register user: ${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
