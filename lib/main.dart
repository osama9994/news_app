import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/cubit/favorite_actions/favorite_actions_cubit.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/localization/language_cubit/language_state.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/services/notification_service.dart';
import 'package:news_app/core/utils/route/app_router.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_theme.dart';
import 'package:news_app/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:news_app/core/utils/theme/theme_cubit/theme_state.dart';
import 'package:news_app/features/home/home_cubit/home_cubit.dart';
import 'package:news_app/features/notifications/notification_cubit/notification_cubit.dart';
import 'package:news_app/features/notifications/services/firebase_notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalDatabaseHive.initHive();

await NotificationService.initNotification();
await NotificationService.scheduleEvery6HoursNotification();

  final currentUser = FirebaseAuth.instance.currentUser;
  final isLoggedIn = currentUser != null && currentUser.emailVerified;
  final needsVerification = currentUser != null && !currentUser.emailVerified;

  runApp(MyApp(isLoggedIn: isLoggedIn, needsVerification: needsVerification));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.needsVerification,
  });

  final bool isLoggedIn;
  final bool needsVerification;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),
        BlocProvider<FavoriteActionsCubit>(
          create: (_) => FavoriteActionsCubit()..initFavorites(),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => NotificationCubit()..loadNotifications(),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(),
        ),
      ],
      child: _AppBootstrap(
        isLoggedIn: isLoggedIn,
        needsVerification: needsVerification,
      ),
    );
  }
}

class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap({
    required this.isLoggedIn,
    required this.needsVerification,
  });

  final bool isLoggedIn;
  final bool needsVerification;

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  final _notificationService = FirebaseNotificationService();
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;

  @override
  void initState() {
    super.initState();

    _notificationService.init(context.read<NotificationCubit>());

    _connectionSubscription = InternetConnectionChecker.instance
        .onStatusChange
        .listen((status) {
      if (status == InternetConnectionStatus.connected) {
        // ignore: use_build_context_synchronously
        context.read<FavoriteActionsCubit>().syncFavorites();
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (_, themeState) {
        return BlocBuilder<LanguageCubit, LanguageState>(
          builder: (_, languageState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppStrings(languageState.language).text('appName'),
              themeMode: themeState.themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              locale: languageState.language.locale,
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: widget.needsVerification
                  ? AppRoutes.verifyEmail
                  : (widget.isLoggedIn ? AppRoutes.home : AppRoutes.loginRoute),
            );
          },
        );
      },
    );
  }
}