import 'package:dio/dio.dart';

import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/search/models/search_body.dart';

class SearchServices {
  SearchServices()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
            headers: {
              'Authorization': 'Bearer ${AppConstants.apiKey}',
            },
          ),
        );

  final Dio _dio;

  Future<NewsApiResponse> search(SearchBody body) async {
    final response = await _dio.get(
      AppConstants.everything,
      queryParameters: body.toJson(),
    );

    if (response.statusCode == 200) {
      return NewsApiResponse.fromJson(response.data);
    }

    throw Exception(response.statusMessage ?? 'Failed to fetch search results');
  }
}
