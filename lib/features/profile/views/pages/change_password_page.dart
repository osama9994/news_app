import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(title: Text(tr.text('changePassword'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: tr.text('currentPassword'),
                ),
                validator: (value) => value!.isEmpty
                    ? tr.text('enterCurrentPassword')
                    : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: tr.text('newPassword'),
                ),
                validator: (value) =>
                    value!.isEmpty ? tr.text('enterNewPassword') : null,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: tr.text('confirmPassword'),
                ),
                validator: (value) {
                  if (value!.isEmpty) return tr.text('confirmNewPassword');
                  if (value != _newPasswordController.text) {
                    return tr.text('passwordsDoNotMatch');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                    Navigator.pop(context);
                  } else if (state is ChangePasswordError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  if (state is ChangePasswordLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        cubit.changePassword(
                          currentPassword: _currentPasswordController.text,
                          newPassword: _newPasswordController.text,
                        );
                      }
                    },
                    child: Text(tr.text('changePassword')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
