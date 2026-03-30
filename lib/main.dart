
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:news_app/core/utils/theme/theme_cubit/theme_state.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';
import 'package:news_app/features/notifications/services/firebase_notification_service.dart';
import 'firebase_options.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/cubit/favorite actions/favorite_actions_cubit.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/utils/route/app_router.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_theme.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalDatabaseHive.initHive();

  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});
@override
Widget build(BuildContext context) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
      BlocProvider<FavoriteActionsCubit>(create: (context) => FavoriteActionsCubit()..initFavorites()),
      BlocProvider<NotificationCubit>(create: (context) => NotificationCubit()..loadNotifications()),
      BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      BlocProvider<FavoriteActionsCubit>(
  create: (context) => FavoriteActionsCubit()..initFavorites(),
)
    ],
    // ✅ استبدال Builder بـ BlocBuilder للاستماع لتغييرات الثيم
    child: BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        // تهيئة خدمة الإشعارات
        final notificationCubit = context.read<NotificationCubit>();
        final favoriteCubit = context.read<FavoriteActionsCubit>();
        FirebaseNotificationService().init(notificationCubit);
        InternetConnectionChecker.instance.onStatusChange.listen((status) {
  if (status == InternetConnectionStatus.connected) {
    favoriteCubit.syncFavorites();
  }
});
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          
          // ✅ التعديل الأهم: ربط themeMode بحالة الـ Cubit الحالية
          themeMode: state.themeMode, 
          
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.loginRoute,
        );
      },
    ),
  );
}
}