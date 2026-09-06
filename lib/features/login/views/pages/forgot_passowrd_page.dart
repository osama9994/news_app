import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
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
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(tr.text('resetPassword'))),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LabelWithTextField(
                label: tr.text('email'),
                controller: emailController,
                prefixIcon: Icons.email,
                hintText: tr.text('enterYourEmail'),
              ),
              const SizedBox(height: 24),
              MainButton(
                text: tr.text('sendResetLink'),
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await cubit.resetPassword(
                      email: emailController.text.trim(),
                    );

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr.text('resetLinkSent')),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
