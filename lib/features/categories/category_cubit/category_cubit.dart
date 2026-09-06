import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final Dio dio = Dio();
  List<Article> _rawArticles = [];

  void _emitSafe(CategoryState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> getCategoryNews(String category) async {
    try {
      if (AppConstants.apiKey.trim().isEmpty) {
        throw Exception(
          'Missing NEWS_API_KEY. Run with --dart-define=NEWS_API_KEY=your_key',
        );
      }

      _emitSafe(CategoryLoading());

      dio.options.baseUrl = AppConstants.baseUrl;

      final response = await dio.get(
        AppConstants.everything,
        queryParameters: {
          'apiKey': AppConstants.apiKey,
          'q': AppLanguage.english.apiCategoryQuery(category),
          'language': 'en',
          'sortBy': 'publishedAt',
          'pageSize': 20,
        },
      );

      final parsed = NewsApiResponse.fromJson(response.data);
      _rawArticles = parsed.articles ?? [];
      await applyCurrentLanguage();
    } catch (e) {
      _emitSafe(CategoryError(e.toString()));
    }
  }

  Future<void> applyCurrentLanguage() async {
    try {
      _emitSafe(CategoryLoaded(List<Article>.from(_rawArticles)));
    } catch (e) {
      _emitSafe(CategoryError(e.toString()));
    }
  }
}
