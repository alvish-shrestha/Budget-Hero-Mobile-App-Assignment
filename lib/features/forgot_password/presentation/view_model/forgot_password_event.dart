abstract class ForgotPasswordEvent {}

class SubmitForgotPasswordEvent extends ForgotPasswordEvent {
  final String email;

  SubmitForgotPasswordEvent(this.email);
}
