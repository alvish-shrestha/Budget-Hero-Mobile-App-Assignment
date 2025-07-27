import 'package:budgethero/app/service_locator/service_locator.dart';
import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/features/auth/presentation/view/login_screen.dart';
import 'package:budgethero/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:budgethero/features/more/presentation/view/account/change_email_dialog.dart';
import 'package:budgethero/features/more/presentation/view/account/change_password_dialog.dart';
import 'package:budgethero/features/more/presentation/view/account/change_username_dialog.dart';
import 'package:budgethero/features/more/presentation/view/account/logout_confirmation_dialog.dart';
import 'package:budgethero/features/more/presentation/view_model/account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("More")),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            context,
            title: "Change Username",
            icon: Icons.person,
            onTap:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<AccountViewModel>(),
                        child: ChangeUsernameDialog(
                          controller: usernameController,
                        ),
                      ),
                ),
          ),
          _buildCard(
            context,
            title: "Change Email",
            icon: Icons.email,
            onTap:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<AccountViewModel>(),
                        child: ChangeEmailDialog(controller: emailController),
                      ),
                ),
          ),
          _buildCard(
            context,
            title: "Change Password",
            icon: Icons.lock,
            onTap:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => BlocProvider.value(
                        value: context.read<AccountViewModel>(),
                        child: const ChangePasswordDialog(),
                      ),
                ),
          ),
          _buildCard(
            context,
            title: "Logout",
            icon: Icons.logout,
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (_) => const LogoutConfirmationDialog(),
              );

              if (shouldLogout == true) {
                // ignore: use_build_context_synchronously
                context.read<AccountViewModel>().add(LogoutEvent());

                // ignore: use_build_context_synchronously
                showMySnackbar(context: context, content: "Logout successful");

                // Navigate to login screen
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider.value(
                          value: serviceLocator<LoginViewModel>(),
                          child: LoginScreen(),
                        ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFF55345)),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF55345),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
