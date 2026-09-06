import 'package:dio/dio.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';

class HomeServices {
  HomeServices()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
          ),
        );

  final Dio _dio;

  Future<NewsApiResponse> getNews({
    required int page,
    required int pageSize,
  }) async {
    if (AppConstants.apiKey.trim().isEmpty) {
      throw Exception(
        'Missing NEWS_API_KEY. Run with --dart-define=NEWS_API_KEY=your_key',
      );
    }

    final response = await _dio.get(
      AppConstants.everything,
      queryParameters: {
        'apiKey': AppConstants.apiKey,
        'q': AppLanguage.english.homeQuery,
        'language': AppLanguage.english.newsApiLanguage,
        'sortBy': 'publishedAt',
        'page': page,
        'pageSize': pageSize,
      },
    );

    if (response.statusCode == 200) {
      return NewsApiResponse.fromJson(response.data);
    }

    throw Exception(response.statusMessage ?? 'Failed to fetch home news');
  }
}
