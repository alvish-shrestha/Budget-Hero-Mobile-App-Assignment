abstract class IForgotPasswordRepository {
  Future<void> requestReset(String email);
}
