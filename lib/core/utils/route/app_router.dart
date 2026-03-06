import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/features/categories/views/pages/category_selection_page.dart';
import 'package:news_app/features/categories/views/pages/category_news_page.dart';
import 'package:news_app/features/favorites/favorite_cubit/favorite_cubit.dart';
import 'package:news_app/features/favorites/views/pages/favorites_page.dart';
import 'package:news_app/features/home/views/pages/article_details_page.dart';
import 'package:news_app/features/home/views/pages/home_page.dart';
import 'package:news_app/features/login/views/pages/login_page.dart';
import 'package:news_app/features/login/views/pages/register_page.dart';
import 'package:news_app/features/profile/views/pages/profile_page.dart';
import 'package:news_app/features/search/search_cubit/search_cubit.dart';
import 'package:news_app/features/search/views/pages/search_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return CupertinoPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      case AppRoutes.profileRoute:
        return CupertinoPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );

      case AppRoutes.loginRoute:
        return CupertinoPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case AppRoutes.registerRoute:
        return CupertinoPageRoute(
          builder: (_) => const RegisterPage(),
          settings: settings,
        );

      case AppRoutes.category:
        return CupertinoPageRoute(
          builder: (_) => const CategorySelectionPage(),
          settings: settings,
        );

      case AppRoutes.categoryNews:
        final category = settings.arguments as String?;
        if (category == null) {
          return CupertinoPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text("no category data provided")),
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => CategoryNewsPage(category: category),
        );

      case AppRoutes.articleDetails:
        final article = settings.arguments as Article?;
        if (article == null) {
          return CupertinoPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text("no article data provided")),
            ),
            settings: settings,
          );
        }
        return CupertinoPageRoute(
          builder: (_) => ArticleDetailsPage(article: article),
          settings: settings,
        );

      case AppRoutes.search:
        return CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SearchCubit(),
            child: SearchPage(),
          ),
          settings: settings,
        );

   case AppRoutes.favorites:
  return CupertinoPageRoute(
    builder: (_) => BlocProvider(
      create: (context) => FavoriteCubit(
        context.read<FavoriteActionsCubit>(),
      ),
      child: const FavoritesPage(),
    ),
    settings: settings,
  );
      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
