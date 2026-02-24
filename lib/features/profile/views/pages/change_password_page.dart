import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';


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

    return Scaffold(
      appBar: AppBar(title: const Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Current Password"),
                validator: (value) =>
                    value!.isEmpty ? "Enter current password" : null,
              ),
              const SizedBox(height: 24,),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
                validator: (value) =>
                    value!.isEmpty ? "Enter new password" : null,
              ),
              const SizedBox(height: 24,),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Confirm Password"),
                validator: (value) {
                  if (value!.isEmpty) return "Confirm new password";
                  if (value != _newPasswordController.text) return "Passwords do not match";
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
                    child: const Text("Change Password"),
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