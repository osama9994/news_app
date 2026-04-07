import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/localization/language_storage.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/services/article_translation_service.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final Dio dio = Dio();
  List<Article> _rawArticles = [];

  Future<void> getCategoryNews(String category) async {
    try {
      emit(CategoryLoading());

      dio.options.baseUrl = AppConstants.baseUrl;

      final response = await dio.get(
        AppConstants.everything,
        queryParameters: {
          'q': AppLanguage.english.apiCategoryQuery(category),
          'language': 'en',
          'sortBy': 'publishedAt',
          'pageSize': 20,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppConstants.apiKey}',
          },
        ),
      );

      final parsed = NewsApiResponse.fromJson(response.data);
      _rawArticles = parsed.articles ?? [];
      await applyCurrentLanguage();
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> applyCurrentLanguage() async {
    try {
      final language = await LanguageStorage.loadLanguage();
      final translatedArticles = await ArticleTranslationService.instance
          .translateArticlesIfNeeded(_rawArticles, language);
      emit(CategoryLoaded(translatedArticles));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
