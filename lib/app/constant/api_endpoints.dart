class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 10);

  // For Android Emulator
  static const String serverAddress = "http://10.0.2.2:5000";
  // For iOS Simulator
  // static const String serverAddress = "http://localhost:5000";

  // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/";

  // Auth
  static const String login = "auth/login";
  static const String register = "auth/register";
}
