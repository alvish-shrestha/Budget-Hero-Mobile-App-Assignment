import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/forgot_password_view_model.dart';
import '../view_model/forgot_password_event.dart';
import '../view_model/forgot_password_state.dart';

void showForgotPasswordDialog(BuildContext context) {
  final emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: context.read<ForgotPasswordViewModel>(),
        child: AlertDialog(
          title: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.black),
          ),
          content: BlocBuilder<ForgotPasswordViewModel, ForgotPasswordState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter your email to receive reset link'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        color: Colors.black,
                      ), // unfocused
                      floatingLabelStyle: const TextStyle(
                        color: Colors.black,
                      ), // focused
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  if (state is ForgotPasswordFailure) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  if (state is ForgotPasswordSuccess) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Reset link sent to your email.',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
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
                return ElevatedButton(
                  onPressed:
                      state is ForgotPasswordLoading
                          ? null
                          : () {
                            final email = emailController.text.trim();
                            if (email.isNotEmpty) {
                              context.read<ForgotPasswordViewModel>().add(
                                SubmitForgotPasswordEvent(email),
                              );
                            }
                          },
                  child:
                      state is ForgotPasswordLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Send Reset Link'),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
