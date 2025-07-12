import 'package:dio/dio.dart';

class AuthTokenInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  AuthTokenInterceptor({required this.getToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }
}
