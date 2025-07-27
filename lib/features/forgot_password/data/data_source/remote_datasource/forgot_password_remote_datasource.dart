import 'package:dio/dio.dart';

abstract class IForgotPasswordRemoteDatasource {
  Future<void> requestReset(String email);
}

class ForgotPasswordRemoteDatasource implements IForgotPasswordRemoteDatasource {
  final Dio dio;

  ForgotPasswordRemoteDatasource(this.dio);

  @override
  Future<void> requestReset(String email) async {
    final response = await dio.post("/auth/forgot-password", data: {
      "email": email,
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to send reset email");
    }
  }
}
