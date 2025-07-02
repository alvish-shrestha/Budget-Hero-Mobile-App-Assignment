import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_user_event.dart';
import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var inputWidth = isLandscape ? 400.0 : 305.0;
    var headingFont = isLandscape ? 50.0 : 40.0;
    var subheadingFont = isLandscape ? 22.0 : 18.0;
    var paddingTop = isLandscape ? 60.0 : 150.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF55345),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: paddingTop),
                  Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Jaro",
                      fontSize: headingFont,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Create an account",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Jaro",
                      fontSize: subheadingFont,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildTextField(
                    label: "Username",
                    controller: _usernameController,
                    inputWidth: inputWidth,
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Please enter a username' : null,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: "Email",
                    controller: _emailController,
                    inputWidth: inputWidth,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) return 'Please enter an email';
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  ValueListenableBuilder(
                    valueListenable: _obscurePassword,
                    builder:
                        (_, obscure, __) => _buildTextField(
                          label: "Password",
                          controller: _passwordController,
                          inputWidth: inputWidth,
                          obscureText: obscure,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed:
                                () =>
                                    _obscurePassword.value =
                                        !_obscurePassword.value,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                  ),
                  const SizedBox(height: 15),
                  ValueListenableBuilder(
                    valueListenable: _obscureConfirmPassword,
                    builder:
                        (_, obscure, __) => _buildTextField(
                          label: "Confirm Password",
                          controller: _confirmPasswordController,
                          inputWidth: inputWidth,
                          obscureText: obscure,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscure ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed:
                                () =>
                                    _obscureConfirmPassword.value =
                                        !_obscureConfirmPassword.value,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: inputWidth,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<RegisterViewModel>().add(
                            RegisterUserEvent(
                              context: context,
                              username: _usernameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              confirmPassword:
                                  _confirmPasswordController.text.trim(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontFamily: "Jaro",
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Divider(color: Colors.white, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "x x x",
                          style: TextStyle(
                            fontFamily: "Jaro",
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Colors.white, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: "Jaro",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: "Already have an account?  "),
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(color: Color(0xFF000CF9)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required double inputWidth,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
      width: inputWidth,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: "Jaro", color: Colors.white),
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
