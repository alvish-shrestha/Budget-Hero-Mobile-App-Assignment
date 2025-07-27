class ApiEndpoints {
  ApiEndpoints._();

  // Timeouts
  static const connectionTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 10);

  // For Android Emulator
  static const String serverAddress = "http://10.0.2.2:5050";
  // For iOS Simulator
  // static const String serverAddress = "http://localhost:5000";

  // For iPhone (uncomment if needed)
  static const String baseUrl = "$serverAddress/api/";

  // Auth
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String updateUsername = "auth/update-username";
  static const String updateEmail = "auth/update-email";
  static const String updatePassword = "auth/update-password";

  // Transaction
  static const String addTransaction = "transaction/add";
  static const String getTransaction = "transaction/get";
  static const String deleteTransaction = "transaction/delete";
  static const String updateTransaction = "transaction/update";

  // Stats
  static const String getStats = "stats";

  // Goal
  static const String getGoals = "goal/get";
  static const String addGoal = "goal/add";
  static const String updateGoal = "goal/update";
  static const String deleteGoal = "goal/delete";
  static const String contributeGoal = "goal/contribute";
}
