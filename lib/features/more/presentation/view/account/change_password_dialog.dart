import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/features/more/presentation/view_model/account_view_model.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool showOldPassword = false;
  bool showNewPassword = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value, {bool isNew = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (isNew && value.trim().length < 6) {
      return 'New password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountViewModel, AccountState>(
      listener: (context, state) {
        if (state is AccountSuccess) {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
          showSuccessCheckmarkDialog(context);
          showMySnackbar(context: context, content: state.message);
          oldPasswordController.clear();
          newPasswordController.clear();
        } else if (state is AccountError) {
          showMySnackbar(
            context: context,
            content: state.message,
            color: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Change Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFFF55345),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter your current and new password below.",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: !showOldPassword,
                  validator: (val) => _validatePassword(val),
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    labelStyle: const TextStyle(color: Colors.black),
                    floatingLabelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showOldPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed:
                          () => setState(
                            () => showOldPassword = !showOldPassword,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: !showNewPassword,
                  validator: (val) => _validatePassword(val, isNew: true),
                  decoration: InputDecoration(
                    labelText: "New Password",
                    labelStyle: const TextStyle(color: Colors.black),
                    floatingLabelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black,
                      ),
                      onPressed:
                          () => setState(
                            () => showNewPassword = !showNewPassword,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF55345),
              ),
              onPressed:
                  state is AccountLoading
                      ? null
                      : () {
                        if (_formKey.currentState!.validate()) {
                          final oldPass = oldPasswordController.text.trim();
                          final newPass = newPasswordController.text.trim();
                          context.read<AccountViewModel>().add(
                            UpdatePasswordEvent(oldPass, newPass),
                          );
                        }
                      },
              child:
                  state is AccountLoading
                      ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                      : const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}

void showSuccessCheckmarkDialog(BuildContext outerContext) {
  showGeneralDialog(
    context: outerContext,
    barrierDismissible: false,
    barrierLabel: "Success",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (dialogContext, anim1, anim2) {
      Future.delayed(const Duration(seconds: 1), () {
        if (dialogContext.mounted) {
          Navigator.of(dialogContext, rootNavigator: true).pop();
        }
      });

      return Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: const Center(
            child: Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 60),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
        child: child,
      );
    },
  );
}