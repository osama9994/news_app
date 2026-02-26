import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/features/login/views/widgets/label_with_textField.dart';
import 'package:news_app/features/login/views/widgets/main_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LabelWithTextField(
                label: "Email",
                controller: emailController,
                prefixIcon: Icons.email,
                hintText: "Enter your email",
              ),
              const SizedBox(height: 24),
              MainButton(
                text: "Send Reset Link",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await cubit.resetPassword(
                      email: emailController.text.trim(),
                    );

                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Reset link sent to your email"),
                      ),
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}