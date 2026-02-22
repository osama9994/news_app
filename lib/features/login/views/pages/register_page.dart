
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit cubit = context.read<AuthCubit>();

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

                  /// Title
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    "Start shopping by creating your account",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 24),

                  /// Username
                  LabelWithTextField(
                    label: "Username",
                    prefixIcon: Icons.person,
                    hintText: "Enter your username",
                    controller: usernameController,
                  ),
                  const SizedBox(height: 16),

                  /// Email
                  LabelWithTextField(
                    label: "Email",
                    prefixIcon: Icons.email,
                    hintText: "Enter your email",
                    controller: emailController,
                  ),
                  const SizedBox(height: 16),

                  /// Password
                  LabelWithTextField(
                    label: "Password",
                    prefixIcon: Icons.lock,
                    hintText: "Enter your password",
                    
                    controller: passwordController,
                  ),
                  const SizedBox(height: 32),

                  /// Register Button
                  BlocConsumer<AuthCubit, AuthState>(
                    listenWhen: (previous, current) =>
                        current is AuthDone || current is AuthError,
                    listener: (context, state) {
                      if (state is AuthDone) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.home,
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
                        return  MainButton(isLoading: true);
                      }

                      return MainButton(
                        text: "Create Account",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.registerWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              username: usernameController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  /// Go to Login
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Already have an account? Login",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Divider Text
                  Text(
                    "Or sign up using",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: AppColors.grey),
                  ),
                  const SizedBox(height: 16),

                  /// Google Sign Up
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
                        return  SocialMediaBotton(
                          isLoading: true,
                          text: "Sign up with Google",
                          icon: Icons.g_mobiledata,
                          ontap: null,
                        );
                      }

                      return SocialMediaBotton(
                        text: "Sign up with Google",
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
