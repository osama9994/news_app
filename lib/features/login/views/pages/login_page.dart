import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/features/login/views/pages/forgot_passowrd_page.dart';
import 'package:news_app/features/login/views/widgets/label_with_textField.dart';
import 'package:news_app/features/login/views/widgets/main_button.dart';
import 'package:news_app/features/login/views/widgets/social_media_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    final tr = context.tr;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text(
                    tr.text('loginAccount'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tr.text('loginPrompt'),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  LabelWithTextField(
                    label: tr.text('email'),
                    controller: emailController,
                    prefixIcon: Icons.email,
                    hintText: tr.text('enterYourEmail'),
                  ),
                  const SizedBox(height: 24),
                  LabelWithTextField(
                    label: tr.text('password'),
                    controller: passwordController,
                    prefixIcon: Icons.password,
                    hintText: tr.text('enterYourPassword'),
                    obsecureText: true,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(tr.text('forgotPassword')),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: cubit,
                    listenWhen: (previous, current) =>
                        current is AuthDone || current is AuthError,
                    listener: (context, state) {
                      if (state is AuthDone) {
                        Navigator.of(context).pushNamed(AppRoutes.home);
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AuthLoading ||
                        current is AuthError ||
                        current is AuthDone,
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return MainButton(isLoading: true);
                      }
                      return MainButton(
                        text: tr.text('login'),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.loginWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.registerRoute);
                          },
                          child: Text(tr.text('noAccountRegister')),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tr.text('otherMethod'),
                          style:
                              Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        BlocConsumer<AuthCubit, AuthState>(
                          bloc: cubit,
                          listenWhen: (previous, current) =>
                              current is GoogleAuthDone ||
                              current is GoogleAuthError,
                          listener: (context, state) {
                            if (state is GoogleAuthDone) {
                              Navigator.of(context).pushNamed(AppRoutes.home);
                            } else if (state is GoogleAuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          buildWhen: (previous, current) =>
                              current is GoogleAuthenticating ||
                              current is GoogleAuthError ||
                              current is GoogleAuthDone,
                          builder: (context, state) {
                            if (state is GoogleAuthenticating) {
                              return SocialMediaBotton(isLoading: true);
                            }
                            return SocialMediaBotton(
                              text: tr.text('loginWithGoogle'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
