import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';
import 'package:news_app/features/profile/views/pages/edit_categories_page.dart';
import 'package:news_app/features/profile/views/pages/change_password_page.dart';
import 'package:news_app/features/profile/views/widgets/email_widget.dart';
import 'package:news_app/features/profile/views/widgets/profile_action_button.dart';
import 'package:news_app/features/profile/views/widgets/profile_picture_widget.dart';
import 'package:news_app/features/profile/views/widgets/username_widget.dart';

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
    final themeCubit = context.read<ThemeCubit>();
    final languageCubit = context.read<LanguageCubit>();
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "";
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final tr = context.tr;
    final currentLanguage = context.watch<LanguageCubit>().state.language;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(tr.text('profile')),
      ),
      body: user == null
          ? Center(child: Text(tr.text('noUserLoggedIn')))
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
                          text: isDarkMode
                              ? tr.text('lightMode')
                              : tr.text('darkMode'),
                          onTap: () => themeCubit.toggleTheme(),
                        ),
                        const SizedBox(height: 10),
                        ProfileActionButton(
                          icon: Icons.language,
                          text: tr
                              .text('editLanguage')
                              .replaceFirst(
                                '{language}',
                                tr.languageName(currentLanguage),
                              ),
                          onTap: () async {
                            await languageCubit.toggleLanguage();
                            if (context.mounted) {
                              await context.read<HomeCubit>().getHomeNews();
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        ProfileActionButton(
                          icon: Icons.category_rounded,
                          text: tr.text('editInterests'),
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
                          text: tr.text('changePassword'),
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
                          text: tr.text('logOut'),
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
