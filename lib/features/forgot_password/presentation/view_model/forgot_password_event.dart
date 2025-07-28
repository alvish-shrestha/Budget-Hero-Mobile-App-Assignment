abstract class ForgotPasswordEvent {}

class SendOtpEvent extends ForgotPasswordEvent {
  final String email;
  SendOtpEvent(this.email);
}

class VerifyOtpEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  VerifyOtpEvent(this.email, this.otp);
}

class ResetPasswordEvent extends ForgotPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;
  ResetPasswordEvent(this.email, this.otp, this.newPassword);
}
