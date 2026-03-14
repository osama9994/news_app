// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';
// import 'package:news_app/features/notifications/services/firebase_notification_service.dart';
// import 'firebase_options.dart';
// import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
// import 'package:news_app/core/cubit/favorite actions/favorite_actions_cubit.dart';
// import 'package:news_app/core/services/local_database_hive.dart';
// import 'package:news_app/core/utils/app_constants.dart';
// import 'package:news_app/core/utils/route/app_router.dart';
// import 'package:news_app/core/utils/route/app_routes.dart';
// import 'package:news_app/core/utils/theme/app_theme.dart';
// import 'package:news_app/features/home/home_cubit/home_cubit.dart';
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   await LocalDatabaseHive.initHive();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [

//         BlocProvider<AuthCubit>(
//           create: (context) => AuthCubit(),
//         ),

//         BlocProvider<FavoriteActionsCubit>(
//           create: (context) => FavoriteActionsCubit()..initFavorites(),
//         ),

//         /// NEW
//         BlocProvider<NotificationCubit>(
//           create: (context) => NotificationCubit()..loadNotifications(),
//         ),
// BlocProvider<HomeCubit>(
//   create: (context) => HomeCubit(),
// ),
//       ],
//       child: Builder(
//         builder: (context) {

//           /// تشغيل Firebase Notification Service
//           final notificationCubit = context.read<NotificationCubit>();

//           FirebaseNotificationService().init(notificationCubit);

//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: AppConstants.appName,
//             theme: AppTheme.mainTheme,
//             onGenerateRoute: AppRouter.onGenerateRoute,
//             initialRoute: AppRoutes.loginRoute,
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
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

  // ✅ تحقق إذا كان المستخدم مسجلاً دخوله مسبقاً
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
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<FavoriteActionsCubit>(
          create: (context) => FavoriteActionsCubit()..initFavorites(),
        ),
        BlocProvider<NotificationCubit>(
          create: (context) => NotificationCubit()..loadNotifications(),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final notificationCubit = context.read<NotificationCubit>();
          FirebaseNotificationService().init(notificationCubit);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.mainTheme,
            onGenerateRoute: AppRouter.onGenerateRoute,
            // ✅ إذا مسجل دخوله → Home، إذا لا → Login
            initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.loginRoute,
          );
        },
      ),
    );
  }
}