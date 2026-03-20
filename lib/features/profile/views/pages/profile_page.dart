import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:news_app/features/profile/views/pages/edit_categories_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final themeCubit = context.read<ThemeCubit>(); // استدعاء الـ Cubit
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "No email";

    // التحقق إذا كان الوضع الحالي مظلم أم فاتح
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // جعل الخلفية تتغير تلقائياً حسب الثيم
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Profile"),
        // سيأخذ اللون تلقائياً من AppBarTheme في AppTheme
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
                  UsernameWidget(username: _username),
                  const SizedBox(height: 5),
                  EmailWidget(email: email),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ProfileActionButton(
                          icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          text: isDarkMode ? "Light Mode" : "Dark Mode",
                          onTap: () => themeCubit.toggleTheme(),
                        ),
                        const SizedBox(height: 10),

                        ProfileActionButton(
                          icon: Icons.category_rounded,
                          text: "Edit Interests",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: authCubit,
                                  child: const EditCategoriesPage(),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),

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
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}