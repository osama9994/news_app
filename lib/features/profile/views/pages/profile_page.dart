// // import 'dart:io';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
// // import 'package:news_app/core/localization/app_strings.dart';
// // import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
// // import 'package:news_app/core/utils/theme/theme_cubit/theme_cubit.dart';
// // import 'package:news_app/features/home/home_cubit/home_cubit.dart';
// // import 'package:news_app/features/profile/views/pages/change_password_page.dart';
// // import 'package:news_app/features/profile/views/pages/edit_categories_page.dart';
// // import 'package:news_app/features/profile/views/widgets/profile_action_button.dart';
// // import 'package:news_app/features/profile/views/widgets/profile_info_widget.dart';
// // import 'package:news_app/features/profile/views/widgets/profile_picture_widget.dart';

// // class ProfilePage extends StatefulWidget {
// //   const ProfilePage({super.key});

// //   @override
// //   State<ProfilePage> createState() => _ProfilePageState();
// // }

// // class _ProfilePageState extends State<ProfilePage> {
// //   File? _imageFile;

// //   User? get _user => FirebaseAuth.instance.currentUser;

// //   String get _username {
// //     final email = _user?.email ?? '';
// //     return email.length >= 5 ? email.substring(0, 5) : email;
// //   }

// //   void _navigateTo(BuildContext context, Widget page) {
// //     final authCubit = context.read<AuthCubit>();
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => BlocProvider.value(
// //           value: authCubit,
// //           child: page,
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Theme.of(context);
// //     final isDarkMode = theme.brightness == Brightness.dark;
// //     final authCubit = context.read<AuthCubit>();
// //     final themeCubit = context.read<ThemeCubit>();
// //     final languageCubit = context.read<LanguageCubit>();
// //     final currentLanguage = context.watch<LanguageCubit>().state.language;
// //     final tr = context.tr;

// //     if (_user == null) {
// //       return Scaffold(
// //         body: Center(child: Text(tr.text('noUserLoggedIn'))),
// //       );
// //     }

// //     return Scaffold(
// //       appBar: AppBar(title: Text(tr.text('profile'))),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           children: [
// //             const SizedBox(height: 30),
// //             ProfilePictureWidget(
// //               imageFile: _imageFile,
// //               onImagePicked: (file) => setState(() => _imageFile = file),
// //             ),
// //             const SizedBox(height: 15),
// //             ProfileInfoWidget(
// //               username: _username,
// //               email: _user!.email ?? '',
// //             ),
// //             const SizedBox(height: 30),
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 20),
// //               child: Column(
// //                 children: [
// //                   ProfileActionButton(
// //                     icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
// //                     text: isDarkMode
// //                         ? tr.text('lightMode')
// //                         : tr.text('darkMode'),
// //                     onTap: () => themeCubit.toggleTheme(),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ProfileActionButton(
// //                     icon: Icons.language,
// //                     text: tr.text('editLanguage').replaceFirst(
// //                           '{language}',
// //                           tr.languageName(currentLanguage),
// //                         ),
// //                     onTap: () async {
// //                       await languageCubit.toggleLanguage();
// //                       if (context.mounted) {
// //                         await context.read<HomeCubit>().getHomeNews();
// //                       }
// //                     },
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ProfileActionButton(
// //                     icon: Icons.category_rounded,
// //                     text: tr.text('editInterests'),
// //                     onTap: () => _navigateTo(context, const EditCategoriesPage()),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ProfileActionButton(
// //                     icon: Icons.lock,
// //                     text: tr.text('changePassword'),
// //                     onTap: () => _navigateTo(context, const ChangePasswordPage()),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   ProfileActionButton(
// //                     icon: Icons.logout,
// //                     text: tr.text('logOut'),
// //                     onTap: () => authCubit.logout(),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const SizedBox(height: 30),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }











// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
// import 'package:news_app/core/localization/app_strings.dart';
// import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
// import 'package:news_app/core/utils/theme/theme_cubit/theme_cubit.dart';
// import 'package:news_app/features/home/home_cubit/home_cubit.dart';
// import 'package:news_app/features/profile/services/profile_service.dart'; // ← أضف هذا
// import 'package:news_app/features/profile/views/pages/change_password_page.dart';
// import 'package:news_app/features/profile/views/pages/edit_categories_page.dart';
// import 'package:news_app/features/profile/views/widgets/profile_action_button.dart';
// import 'package:news_app/features/profile/views/widgets/profile_info_widget.dart';
// import 'package:news_app/features/profile/views/widgets/profile_picture_widget.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   File? _imageFile;
//   String? _networkImageUrl; // ← رابط الصورة من Firebase
//   bool _isUploading = false; // ← حالة الرفع
//   final ProfileService _profileService = ProfileService(); // ← أضف هذا

//   User? get _user => FirebaseAuth.instance.currentUser;

//   String get _username {
//     final email = _user?.email ?? '';
//     return email.length >= 5 ? email.substring(0, 5) : email;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _loadProfilePhoto(); // ← جلب الصورة عند فتح الصفحة
//   }

//   // جلب الصورة المحفوظة من Firebase
//   Future<void> _loadProfilePhoto() async {
//     final url = await _profileService.getProfilePhotoUrl();
//     if (mounted) {
//       setState(() => _networkImageUrl = url);
//     }
//   }

//   // رفع الصورة الجديدة إلى Firebase
//   Future<void> _onImagePicked(File file) async {
//     setState(() {
//       _imageFile = file;
//       _isUploading = true;
//     });

//     try {
//       final url = await _profileService.uploadProfilePhoto(file);
//       if (mounted) {
//         setState(() {
//           _networkImageUrl = url;
//           _isUploading = false;
//         });
//       }
//     } catch (e) {
//   if (mounted) {
//     setState(() => _isUploading = false);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $e')), // ← غيّر هذا مؤقتاً
//     );
//   }
//     }
//   } 
//   void _navigateTo(BuildContext context, Widget page) {
//     final authCubit = context.read<AuthCubit>();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => BlocProvider.value(
//           value: authCubit,
//           child: page,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//     final authCubit = context.read<AuthCubit>();
//     final themeCubit = context.read<ThemeCubit>();
//     final languageCubit = context.read<LanguageCubit>();
//     final currentLanguage = context.watch<LanguageCubit>().state.language;
//     final tr = context.tr;

//     if (_user == null) {
//       return Scaffold(
//         body: Center(child: Text(tr.text('noUserLoggedIn'))),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text(tr.text('profile'))),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 30),
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 ProfilePictureWidget(
//                   imageFile: _imageFile,
//                   networkImageUrl: _networkImageUrl, // ← أضف هذا
//                   onImagePicked: _onImagePicked, // ← غيّر هذا
//                 ),
//                 // مؤشر التحميل أثناء الرفع
//                 if (_isUploading)
//                   const CircularProgressIndicator(),
//               ],
//             ),
//             const SizedBox(height: 15),
//             ProfileInfoWidget(
//               username: _username,
//               email: _user!.email ?? '',
//             ),
//             const SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   ProfileActionButton(
//                     icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
//                     text: isDarkMode
//                         ? tr.text('lightMode')
//                         : tr.text('darkMode'),
//                     onTap: () => themeCubit.toggleTheme(),
//                   ),
//                   const SizedBox(height: 10),
//                   ProfileActionButton(
//                     icon: Icons.language,
//                     text: tr.text('editLanguage').replaceFirst(
//                           '{language}',
//                           tr.languageName(currentLanguage),
//                         ),
//                     onTap: () async {
//                       await languageCubit.toggleLanguage();
//                       if (context.mounted) {
//                         await context.read<HomeCubit>().getHomeNews();
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 10),
//                   ProfileActionButton(
//                     icon: Icons.category_rounded,
//                     text: tr.text('editInterests'),
//                     onTap: () => _navigateTo(context, const EditCategoriesPage()),
//                   ),
//                   const SizedBox(height: 10),
//                   ProfileActionButton(
//                     icon: Icons.lock,
//                     text: tr.text('changePassword'),
//                     onTap: () => _navigateTo(context, const ChangePasswordPage()),
//                   ),
//                   const SizedBox(height: 10),
//                   ProfileActionButton(
//                     icon: Icons.logout,
//                     text: tr.text('logOut'),
//                     onTap: () => authCubit.logout(),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';
import 'package:news_app/features/profile/services/profile_service.dart';
import 'package:news_app/features/profile/views/pages/change_password_page.dart';
import 'package:news_app/features/profile/views/pages/edit_categories_page.dart';
import 'package:news_app/features/profile/views/widgets/profile_action_button.dart';
import 'package:news_app/features/profile/views/widgets/profile_info_widget.dart';
import 'package:news_app/features/profile/views/widgets/profile_picture_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;       // صورة مؤقتة أثناء الرفع
  Object? _photoData;     // Uint8List من Hive أو String (URL)
  bool _isUploading = false;
  final ProfileService _profileService = ProfileService();

  User? get _user => FirebaseAuth.instance.currentUser;

  String get _username {
    final email = _user?.email ?? '';
    return email.length >= 5 ? email.substring(0, 5) : email;
  }

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  // ─── جلب الصورة: Hive أولاً، ثم Firebase ─────────────────────────
  Future<void> _loadProfilePhoto() async {
    final data = await _profileService.getProfilePhoto();
    if (mounted) setState(() => _photoData = data);
  }

  // ─── رفع الصورة الجديدة ───────────────────────────────────────────
  Future<void> _onImagePicked(File file) async {
    setState(() {
      _imageFile = file;      // عرض فوري من الملف المحلي
      _isUploading = true;
    });

    try {
      await _profileService.uploadProfilePhoto(file);
      // بعد الرفع، أعد التحميل من Hive (سيجد الـ bytes الجديدة فوراً)
      final data = await _profileService.getProfilePhoto();
      if (mounted) {
        setState(() {
          _imageFile = null;
          _photoData = data;
          _isUploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _imageFile = null;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل رفع الصورة: $e')),
        );
      }
    }
  }

  void _navigateTo(BuildContext context, Widget page) {
    final authCubit = context.read<AuthCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: authCubit,
          child: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authCubit = context.read<AuthCubit>();
    final themeCubit = context.read<ThemeCubit>();
    final languageCubit = context.read<LanguageCubit>();
    final currentLanguage = context.watch<LanguageCubit>().state.language;
    final tr = context.tr;

    if (_user == null) {
      return Scaffold(
        body: Center(child: Text(tr.text('noUserLoggedIn'))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(tr.text('profile'))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                ProfilePictureWidget(
                  imageFile: _imageFile,
                  photoData: _photoData,
                  onImagePicked: _onImagePicked,
                ),
                if (_isUploading) const CircularProgressIndicator(),
              ],
            ),
            const SizedBox(height: 15),
            ProfileInfoWidget(
              username: _username,
              email: _user!.email ?? '',
            ),
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
                    text: tr.text('editLanguage').replaceFirst(
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
                    onTap: () => _navigateTo(context, const EditCategoriesPage()),
                  ),
                  const SizedBox(height: 10),
                  ProfileActionButton(
                    icon: Icons.lock,
                    text: tr.text('changePassword'),
                    onTap: () => _navigateTo(context, const ChangePasswordPage()),
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