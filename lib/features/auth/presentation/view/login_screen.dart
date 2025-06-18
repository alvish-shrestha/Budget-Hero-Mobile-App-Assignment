import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:budgethero/features/auth/presentation/view/signup_screen.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    var isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    var inputWidth = isLandscape ? 400.0 : 305.0;
    var headingFont = isLandscape ? 50.0 : 40.0;
    var subheadingFont = isLandscape ? 22.0 : 18.0;
    var paddingTop = isLandscape ? 60.0 : 150.0;
    const double buttonSize = 50;

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: paddingTop),
                  Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Jaro",
                      fontSize: headingFont,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Please Sign in with your account",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Jaro",
                      fontSize: subheadingFont,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: inputWidth,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          fontFamily: "Jaro",
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 3,
                          ),
                        ),
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: inputWidth,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: obscurePassword,
                      builder: (context, isObscure, child) {
                        return TextFormField(
                          obscureText: isObscure,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(
                              fontFamily: "Jaro",
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                obscurePassword.value = !isObscure;
                              },
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 60, top: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Jaro",
                          fontSize: isLandscape ? 17 : 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: inputWidth,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginViewModel>().add(
                            LoginWithEmailAndPasswordEvent(
                              context: context,
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                          // final email = emailController.text.trim();
                          // final password = passwordController.text.trim();

                          // if (email == "admin@gmail.com" &&
                          //     password == "admin123") {
                          //   showMySnackbar(
                          //     context: context,
                          //     content: "Logged in Successfully",
                          //     color: Color(0xFFF55345),
                          //   );
                          //   Navigator.pushAndRemoveUntil(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => const DashboardScreen(),
                          //     ),
                          //     (route) => false,
                          //   );
                          // } else {
                          //   showMySnackbar(
                          //     context: context,
                          //     content: "Invalid email or password",
                          //     color: Colors.red,
                          //   );
                          // }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "SIGN IN",
                          style: TextStyle(
                            fontFamily: "Jaro",
                            fontSize: 28,
                            color: Colors.white,
                          ),
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
                          "or sign in with",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialButton('assets/images/google.png', buttonSize),
                      const SizedBox(width: 20),
                      _socialButton('assets/images/facebook.png', buttonSize),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider<RegisterViewModel>(
                                create:
                                    (_) => serviceLocator<RegisterViewModel>(),
                                child: Builder(builder: (context) => Signup()),
                              ),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: "Jaro",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: "Don't have an account?  "),
                          TextSpan(
                            text: "Sign up",
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

  Widget _socialButton(String assetPath, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Image.asset(assetPath, height: 28),
      ),
    );
  }
}
