import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_view_model.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_event.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_state.dart';

void showForgotPasswordDialog(BuildContext context) {
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> obscureConfirmPassword = ValueNotifier(true);

  final InputDecorationTheme customInputDecoration = InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.black),
    floatingLabelStyle: const TextStyle(color: Colors.black),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );

  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<ForgotPasswordViewModel>(),
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Reset Password via OTP",
                style: TextStyle(color: Colors.black),
              ),
              content:
                  BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                    builder: (context, state) {
                      Widget currentStep;

                      if (state is ForgotPasswordOtpSent) {
                        currentStep = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.message),
                            const SizedBox(height: 10),
                            TextField(
                              controller: otpController,
                              decoration: const InputDecoration(
                                labelText: 'Enter OTP',
                              ).applyDefaults(customInputDecoration),
                            ),
                          ],
                        );
                      } else if (state is ForgotPasswordOtpVerified) {
                        currentStep = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.message),
                            const SizedBox(height: 10),
                            ValueListenableBuilder<bool>(
                              valueListenable: obscureNewPassword,
                              builder: (_, obscure, __) {
                                return TextField(
                                  controller: newPasswordController,
                                  obscureText: obscure,
                                  decoration: InputDecoration(
                                    labelText: 'New Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        obscureNewPassword.value = !obscure;
                                      },
                                    ),
                                  ).applyDefaults(customInputDecoration),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            ValueListenableBuilder<bool>(
                              valueListenable: obscureConfirmPassword,
                              builder: (_, obscure, __) {
                                return TextField(
                                  controller: confirmPasswordController,
                                  obscureText: obscure,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        obscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        obscureConfirmPassword.value = !obscure;
                                      },
                                    ),
                                  ).applyDefaults(customInputDecoration),
                                );
                              },
                            ),
                          ],
                        );
                      } else if (state is ForgotPasswordSuccess) {
                        currentStep = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 48,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Password reset successful!",
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        );
                      } else {
                        // Initial, loading, or failure → Email Step
                        currentStep = Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Enter your email to receive OTP"),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ).applyDefaults(customInputDecoration),
                            ),
                          ],
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          currentStep,
                          const SizedBox(height: 10),
                          if (state is ForgotPasswordFailure)
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      );
                    },
                  ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
                  builder: (context, state) {
                    final vm = context.read<ForgotPasswordViewModel>();
                    final isLoading = state is ForgotPasswordLoading;

                    String buttonText = "Send OTP";
                    VoidCallback? onPressed;

                    if (state is ForgotPasswordInitial ||
                        state is ForgotPasswordFailure) {
                      buttonText = "Send OTP";
                      onPressed =
                          isLoading
                              ? null
                              : () {
                                final email = emailController.text.trim();
                                if (email.isNotEmpty) {
                                  vm.add(SendOtpEvent(email));
                                }
                              };
                    } else if (state is ForgotPasswordOtpSent) {
                      buttonText = "Verify OTP";
                      onPressed =
                          isLoading
                              ? null
                              : () {
                                final email = emailController.text.trim();
                                final otp = otpController.text.trim();
                                if (email.isNotEmpty && otp.isNotEmpty) {
                                  vm.add(VerifyOtpEvent(email, otp));
                                }
                              };
                    } else if (state is ForgotPasswordOtpVerified) {
                      buttonText = "Reset Password";
                      onPressed =
                          isLoading
                              ? null
                              : () {
                                final email = emailController.text.trim();
                                final otp = otpController.text.trim();
                                final newPassword =
                                    newPasswordController.text.trim();
                                final confirmPassword =
                                    confirmPasswordController.text.trim();

                                if (newPassword != confirmPassword) {
                                  showMySnackbar(
                                    context: context,
                                    content: "Passwords do not match",
                                    color: Colors.red,
                                  );
                                  return;
                                }

                                if (newPassword.isNotEmpty) {
                                  vm.add(
                                    ResetPasswordEvent(email, otp, newPassword),
                                  );
                                }
                              };
                    } else {
                      buttonText = "Done";
                      onPressed = () {
                        showMySnackbar(
                          context: context,
                          content: "Password reset successfully!",
                          color: Colors.green,
                        );
                        Navigator.of(context).pop();
                      };
                    }

                    return ElevatedButton(
                      onPressed: onPressed,
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(buttonText),
                    );
                  },
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
