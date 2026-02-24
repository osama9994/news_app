import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/features/profile/views/widgets/email_widget.dart';
import 'package:news_app/features/profile/views/widgets/profile_action_button.dart';
import 'package:news_app/features/profile/views/widgets/profile_picture_widget.dart';
import 'package:news_app/features/profile/views/widgets/username_widget.dart';
import 'change_password_page.dart';



class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  String _username = "";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "";
    _username = email.length >= 5 ? email.substring(0, 5) : email;
  }

  void _showEditUsernameDialog() {
    final controller = TextEditingController(text: _username);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Username"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new username"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                setState(() => _username = newName);
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "No email";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: user == null
          ? const Center(child: Text("No user logged in"))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  ProfilePictureWidget(
                    imageFile: _imageFile,
                    onImagePicked: (file) => setState(() => _imageFile = file),
                  ),
                  const SizedBox(height: 15),
                  UsernameWidget(username: _username, onEdit: _showEditUsernameDialog),
                  const SizedBox(height: 5),
                  EmailWidget(email: email),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ProfileActionButton(
                          icon: Icons.lock,
                          text: "Change Password",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: authCubit,
                                  child: const ChangePasswordPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        ProfileActionButton(
                          icon: Icons.logout,
                          text: "Log Out",
                          onTap: () => authCubit.logout(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}