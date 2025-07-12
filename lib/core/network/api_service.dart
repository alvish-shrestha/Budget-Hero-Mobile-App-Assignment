import 'package:budgethero/app/constant/api_endpoints.dart';
import 'package:budgethero/core/network/auth_token_interceptor.dart';
import 'package:budgethero/core/network/dio_error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  final Dio _dio;
  final Future<String?> Function() getToken;

  Dio get dio => _dio;

  ApiService(this._dio, {required this.getToken}) {
    _dio
      ..options.baseUrl = ApiEndpoints.baseUrl
      ..options.connectTimeout = ApiEndpoints.connectionTimeout
      ..options.receiveTimeout = ApiEndpoints.receiveTimeout
      ..interceptors.add(DioErrorInterceptor())
      ..interceptors.add(AuthTokenInterceptor(getToken: getToken))
      ..interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      )
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
  }
}