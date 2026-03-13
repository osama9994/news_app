// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/models/article_model.dart';
// import 'package:news_app/core/services/local_database_hive.dart';
// import 'package:news_app/core/utils/app_constants.dart';

// import 'package:news_app/features/home/services/home_services.dart';
// part 'home_state.dart';

// class HomeCubit extends Cubit<HomeState> {
//   HomeCubit() : super(HomeInitial());
//   final homeServices = HomeServices();
//    //final localDatabaseServices=LocalDatabaseServices();
//     final localDatabaseHive = LocalDatabaseHive();
//  Future<void> getTopHeadLines() async {
//   emit(TopHeadlinesLoading());

//   try {
//     final result = await homeServices.getEverything(
//       page: 1,
//       pageSize: 7,
//     );

//     emit(TopHeadlinesLoaded(result.articles));
//   } catch (e) {
//     emit(TopHeadlinesError(e.toString()));
//   }
// }
// Future<void> getRecommendationItems() async {
//   emit(RecommendedNewsLoading());

//   try {
//     final result = await homeServices.getEverything(
//       page: 1,
//       pageSize: 15,
//     );

//     final articles = result.articles ?? [];
//     final favArticles = await _getFavorites();

//     for (int i = 0; i < articles.length; i++) {
//       var article = articles[i];

//       final isFound =
//           favArticles.any((element) => element.title == article.title);

//       if (isFound) {
//         article = article.copyWith(isFavorite: true);
//         articles[i] = article;
//       }
//     }

//     emit(RecommendedNewsLoaded(articles));
//   } catch (e) {
//     emit(RecommendedNewsError(e.toString()));
//   }
// }



// Future<List<Article>>_getFavorites()async{
  
//     final favorites =  await localDatabaseHive.getData<List<dynamic>?>(
//   AppConstants.favoritesKey
//  );
//  if(favorites==null){
//   return[];
//  }

// // final List<Article>favArticles=[];
// // if(favorites!=null){
// //   for (var favArticleString in favorites) {
// //     final favArticle = Article.fromJson(favArticleString);
// //     favArticles.add(favArticle);
// //   }

// // }
// return favorites.map((e) => e as Article).toList();
// }

// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/local_database_hive.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final homeServices = HomeServices();
  final localDatabaseHive = LocalDatabaseHive();

  /// تحميل الأخبار مرة واحدة وتقسيمها
  Future<void> getHomeNews() async {
    emit(HomeLoading());

    try {
      final result = await homeServices.getNews(page: 1, pageSize: 25);
      final articles = result.articles ?? [];

      final breakingNews = articles.take(7)
    .map((a) => a.copyWith(isBreaking: true))
    .toList();
final recommendationNews = articles.skip(7).take(15)
    .map((a) => a.copyWith(isBreaking: false))
    .toList();

      // إضافة حالة المفضلة للمقالات الموصى بها
      final favArticles = await _getFavorites();
      for (int i = 0; i < recommendationNews.length; i++) {
        var article = recommendationNews[i];
        final isFound =
            favArticles.any((element) => element.title == article.title);
        if (isFound) {
          article = article.copyWith(isFavorite: true);
          recommendationNews[i] = article;
        }
      }

      emit(HomeLoaded(
        breakingNews: breakingNews,
        recommendationNews: recommendationNews,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// استرجاع المفضلة من local database
  Future<List<Article>> _getFavorites() async {
    final favorites =
        await localDatabaseHive.getData<List<dynamic>?>(AppConstants.favoritesKey);
    if (favorites == null) return [];
    return favorites.map((e) => e as Article).toList();
  }
}