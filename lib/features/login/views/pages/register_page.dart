import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/login/views/widgets/label_with_textField.dart';
import 'package:news_app/features/login/views/widgets/main_button.dart';
import 'package:news_app/features/login/views/widgets/social_media_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit cubit = context.read<AuthCubit>();
    final tr = context.tr;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    tr.text('createAccount'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr.text('createAccountPrompt'),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  LabelWithTextField(
                    label: tr.text('email'),
                    prefixIcon: Icons.email,
                    hintText: tr.text('enterYourEmail'),
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),
                  LabelWithTextField(
                    label: tr.text('password'),
                    prefixIcon: Icons.lock,
                    hintText: tr.text('enterYourPassword'),
                    controller: passwordController,
                    obsecureText: true,
                  ),
                  const SizedBox(height: 32),
                  BlocConsumer<AuthCubit, AuthState>(
                    listenWhen: (previous, current) =>
                        current is AuthDone || current is AuthError,
                    listener: (context, state) {
                      if (state is AuthDone) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.onboarding,
                          (route) => false,
                        );
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AuthLoading ||
                        current is AuthDone ||
                        current is AuthError,
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return MainButton(isLoading: true);
                      }
                      return MainButton(
                        text: tr.text('createAccount'),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.registerWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        tr.text('alreadyHaveAccount'),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr.text('orSignUpUsing'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<AuthCubit, AuthState>(
                    listenWhen: (p, c) =>
                        c is GoogleAuthDone || c is GoogleAuthError,
                    listener: (context, state) {
                      if (state is GoogleAuthDone) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
                          (route) => false,
                        );
                      } else if (state is GoogleAuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    buildWhen: (p, c) =>
                        c is GoogleAuthenticating ||
                        c is GoogleAuthDone ||
                        c is GoogleAuthError,
                    builder: (context, state) {
                      if (state is GoogleAuthenticating) {
                        return SocialMediaBotton(
                          isLoading: true,
                          text: tr.text('signUpWithGoogle'),
                          icon: Icons.g_mobiledata,
                          ontap: null,
                        );
                      }
                      return SocialMediaBotton(
                        text: tr.text('signUpWithGoogle'),
                        icon: Icons.g_mobiledata,
                        ontap: () async {
                          await cubit.signInWithGoogle();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
