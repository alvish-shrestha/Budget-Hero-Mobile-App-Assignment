class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // For Android Emulator
  static const String serverAddress = "http://10.0.2.2:5000";
  // For iOS Simulator
  // static const String serverAddress = "http://localhost:5000";

  // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/auth/";

  // Auth
  static const String login = "login";
  static const String register = "register";
}
