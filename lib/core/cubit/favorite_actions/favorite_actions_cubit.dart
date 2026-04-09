// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:news_app/core/models/article_model.dart';
// import 'package:news_app/core/utils/app_constants.dart';
// import 'package:news_app/features/favorites/services/favorites_services.dart';
// import 'favorite_actions_state.dart';

// class FavoriteActionsCubit extends Cubit<FavoriteActionsState> {
//   FavoriteActionsCubit._internal() : super(FavoriteActionsInitial());
//   static final FavoriteActionsCubit _instance = FavoriteActionsCubit._internal();
//   factory FavoriteActionsCubit() => _instance;

//   final FavoritesServices favoritesServices = FavoritesServices();
//   List<Article> _favorites = [];

//   // Expose a copy of the current favorites list (read-only for consumers)
//   List<Article> get favorites => List<Article>.from(_favorites);

//   bool _initialized = false;

//   String _articleKey(Article a) {
//     final title = a.title;
//     if (title != null && title.isNotEmpty) return 'title:$title';
//     final url = a.url;
//     if (url != null && url.isNotEmpty) return 'url:$url';
//     return 'fallback:${a.hashCode}';
//   }

//   List<Article> _mergeFavorites(List<Article> a, List<Article> b) {
//     final map = <String, Article>{};
//     for (final item in [...a, ...b]) {
//       map[_articleKey(item)] = item;
//     }
//     return map.values.toList();
//   }

//   Future<void> initFavorites() async {
//     // Ensure initialization logic runs only once
//     if (_initialized) return;
//     _initialized = true;

//     final hiveFavorites = await favoritesServices.getFavoriteHive();
//     _favorites = List<Article>.from(hiveFavorites);
//     emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));

//     try {
//       final firebaseFavorites = await favoritesServices.getFavoritesFromFirebase();

//       // Avoid wiping local Hive favorites with an empty Firebase result
//       // (common when Firebase/auth isn't ready during hot reload).
//       if (firebaseFavorites.isNotEmpty) {
//         _favorites = _mergeFavorites(hiveFavorites, firebaseFavorites);
//         await favoritesServices.localDatabaseHive.saveData(
//           'favorites',
//           _favorites,
//         );
//         emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));
//       }
//     } catch (_) {
      
//     }
//   }

//   // Future<void> setFavorite(Article article) async {
//   //   emit(DoingFavoriteLoading(article.title ?? ""));
//   //   try {
//   //     final index = _favorites.indexWhere((e) => e.title == article.title);
//   //     if (index != -1) {
//   //       _favorites.removeAt(index);
//   //       await favoritesServices.localDatabaseHive.saveData('favorites', _favorites);
//   //       await favoritesServices.removeFavoriteFromFirebase(article);
//   //     } else {
//   //       _favorites.add(article);
//   //       await favoritesServices.localDatabaseHive.saveData('favorites', _favorites);
//   //       await favoritesServices.addFavoriteToFirebase(article);
//   //     }
//   //     emit(FavoriteActionsUpdated(List<Article>.from(_favorites)));
//   //   } catch (e) {
//   //     emit(DoingFavoriteError(e.toString(), article.title ?? ""));
//   //   }
//   // }

// Future<void> setFavorite(Article article) async {
//   try {
//     final hasInternet =
//         await InternetConnectionChecker.instance.hasConnection;

//     final index = _favorites.indexWhere((e) => e.title == article.title);

//     // 🔥 1. حدث UI فورًا
//     if (index != -1) {
//       _favorites.removeAt(index);
//     } else {
//       _favorites.add(article);
//     }

//     emit(FavoriteActionsUpdated(List.from(_favorites)));

//     // 🔥 2. نفذ العمليات في الخلفية
//     await favoritesServices.localDatabaseHive.saveData(
//       AppConstants.favoritesKey,
//       _favorites,
//     );

//     if (hasInternet) {
//       if (index != -1) {
//         await favoritesServices.removeFavoriteFromFirebase(article);
//       } else {
//         await favoritesServices.addFavoriteToFirebase(article);
//       }
//     }

//   } catch (e) {
//     emit(DoingFavoriteError(e.toString(), article.title ?? ""));
//   }
// }

// Future<void> syncFavorites() async {
//   try {
//     final hasInternet = await InternetConnectionChecker.instance.hasConnection;
//     if (!hasInternet) return;

//     final firebaseFavorites =
//         await favoritesServices.getFavoritesFromFirebase();

//     _favorites = _mergeFavorites(_favorites, firebaseFavorites);

//     await favoritesServices.localDatabaseHive.saveData(
//       AppConstants.favoritesKey,
//       _favorites,
//     );

//     emit(FavoriteActionsUpdated(List.from(_favorites)));

//   } catch (_) {}
// }

//   bool isFavorite(Article article) => _favorites.any((e) => e.title == article.title);
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/favorites/services/favorites_services.dart';
import 'favorite_actions_state.dart';

class FavoriteActionsCubit extends Cubit<FavoriteActionsState> {
  FavoriteActionsCubit._internal() : super(FavoriteActionsInitial());
  static final FavoriteActionsCubit _instance = FavoriteActionsCubit._internal();
  factory FavoriteActionsCubit() => _instance;

  final FavoritesServices favoritesServices = FavoritesServices();
  List<Article> _favorites = [];
  bool _initialized = false;

  List<Article> get favorites => List<Article>.from(_favorites);

  String _articleKey(Article a) {
    final title = a.title;
    if (title != null && title.isNotEmpty) return 'title:$title';
    final url = a.url;
    if (url != null && url.isNotEmpty) return 'url:$url';
    return 'fallback:${a.hashCode}';
  }

  List<Article> _mergeFavorites(List<Article> a, List<Article> b) {
    final map = <String, Article>{};
    for (final item in [...a, ...b]) {
      map[_articleKey(item)] = item;
    }
    return map.values.toList();
  }

  Future<void> initFavorites() async {
    if (_initialized) return;
    _initialized = true;

    // جلب المفضلة من Hive أولًا
    final hiveFavorites = await favoritesServices.getFavoriteHive();
    _favorites = List<Article>.from(hiveFavorites);
    emit(FavoriteActionsUpdated(List.from(_favorites)));

    // جلب Firebase لاحقًا ومزج البيانات
    try {
      final firebaseFavorites = await favoritesServices.getFavoritesFromFirebase();
      if (firebaseFavorites.isNotEmpty) {
        _favorites = _mergeFavorites(hiveFavorites, firebaseFavorites);
        await favoritesServices.localDatabaseHive.saveData(AppConstants.favoritesKey, _favorites);
        emit(FavoriteActionsUpdated(List.from(_favorites)));
      }
    } catch (_) {}
  }

  /// إضافة/حذف مفضلة مع Optimistic UI
  Future<void> setFavorite(Article article) async {
    try {
      final index = _favorites.indexWhere((e) => e.title == article.title);
      final bool isRemoving = index != -1;

      // 🔥 1. تحديث UI فورًا
      if (isRemoving) {
        _favorites.removeAt(index);
      } else {
        // إضافة تاريخ الإضافة لفرز الأحدث أول
        final newArticle = article.copyWith();
        _favorites.add(newArticle);
      }
      emit(FavoriteActionsUpdated(List.from(_favorites)));

      // 🔥 2. تنفيذ العمليات في الخلفية (Hive + Firebase)
      _saveFavoritesBackground(article, isRemoving);

    } catch (e) {
      emit(DoingFavoriteError(e.toString(), article.title ?? ""));
    }
  }

  /// تنفيذ الحفظ في الخلفية
  void _saveFavoritesBackground(Article article, bool isRemoving) async {
    try {
      // حفظ محلي
      await favoritesServices.localDatabaseHive.saveData(AppConstants.favoritesKey, _favorites);

      // التحقق من الإنترنت قبل المزامنة مع Firebase
      final hasInternet = await InternetConnectionChecker.instance.hasConnection;
      if (!hasInternet) return;

      if (isRemoving) {
        await favoritesServices.removeFavoriteFromFirebase(article);
      } else {
        await favoritesServices.addFavoriteToFirebase(article);
      }
    } catch (_) {
      // يمكن إضافة rollback إذا أردت، حاليًا نتجاهل الفشل في Firebase
    }
  }

  /// مزامنة Firebase عند رجوع الإنترنت
  Future<void> syncFavorites() async {
    try {
      final hasInternet = await InternetConnectionChecker.instance.hasConnection;
      if (!hasInternet) return;

      final firebaseFavorites = await favoritesServices.getFavoritesFromFirebase();
      _favorites = _mergeFavorites(_favorites, firebaseFavorites);

      await favoritesServices.localDatabaseHive.saveData(AppConstants.favoritesKey, _favorites);
      emit(FavoriteActionsUpdated(List.from(_favorites)));
    } catch (_) {}
  }

  bool isFavorite(Article article) => _favorites.any((e) => e.title == article.title);
}
