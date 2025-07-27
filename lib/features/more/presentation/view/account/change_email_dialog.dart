import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgethero/core/common/snackbar/snackbar.dart';
import 'package:budgethero/features/more/presentation/view_model/account_view_model.dart';

class ChangeEmailDialog extends StatefulWidget {
  final TextEditingController controller;

  const ChangeEmailDialog({super.key, required this.controller});

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email cannot be empty";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
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
          widget.controller.clear(); // ✅ clear field
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
            "Change Email",
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
                  "Enter your new email address below.",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: widget.controller,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: "New Email",
                    labelStyle: TextStyle(color: Colors.black),
                    floatingLabelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
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
                          final email = widget.controller.text.trim();
                          context.read<AccountViewModel>().add(
                            UpdateEmailEvent(email),
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