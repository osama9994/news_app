import 'package:dio/dio.dart';

import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/search/models/search_body.dart';

class SearchServices {
  SearchServices()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
          ),
        );

  final Dio _dio;

  Future<NewsApiResponse> search(SearchBody body) async {
    if (AppConstants.apiKey.trim().isEmpty) {
      throw Exception(
        'Missing NEWS_API_KEY. Run with --dart-define=NEWS_API_KEY=your_key',
      );
    }

    final query = body.toJson();
    query['apiKey'] = AppConstants.apiKey;

    final response = await _dio.get(
      AppConstants.everything,
      queryParameters: query,
    );

    if (response.statusCode == 200) {
      return NewsApiResponse.fromJson(response.data);
    }

    throw Exception(response.statusMessage ?? 'Failed to fetch search results');
  }
}
