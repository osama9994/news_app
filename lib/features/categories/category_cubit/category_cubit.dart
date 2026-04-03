import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/language_storage.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final Dio dio = Dio();

  Future<void> getCategoryNews(String category) async {
    try {
      emit(CategoryLoading());

      final language = await LanguageStorage.loadLanguage();
      dio.options.baseUrl = AppConstants.baseUrl;

      final response = await dio.get(
        AppConstants.everything,
        queryParameters: {
          'q': language.apiCategoryQuery(category),
          'language': language.newsApiLanguage,
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
      emit(CategoryLoaded(parsed.articles ?? []));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
