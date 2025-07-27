import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:budgethero/features/auth/presentation/view/login_screen.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/forgot_password/presentation/view_model/forgot_password_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreenViewModel extends Cubit<void> {
  SplashScreenViewModel() : super(null);

  // Open Login View after 2 seconds
  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => serviceLocator<LoginViewModel>(),
                    ),
                    BlocProvider(
                      create: (_) => serviceLocator<ForgotPasswordViewModel>(),
                    ),
                  ],
                  child: LoginScreen(),
                ),
          ),
        );
      }
    });
  }
}
