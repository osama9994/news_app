import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:news_app/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:news_app/core/cubit/favorite actions/favorite_actions_cubit.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/core/utils/route/app_router.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   LocalDatabaseHive.initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<FavoriteActionsCubit>(
          create: (context) => FavoriteActionsCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: AppTheme.mainTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRoutes.loginRoute,
      ),
    );
  }
}