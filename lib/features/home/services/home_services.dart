import 'package:dio/dio.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/models/news_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';

class HomeServices {
  final Dio aDio = Dio();

  Future<NewsApiResponse> getNews({
    required int page,
    required int pageSize,
  }) async {
    try {
      aDio.options.baseUrl = AppConstants.baseUrl;

      final headers = {
        "Authorization": "Bearer ${AppConstants.apiKey}",
      };

      final response = await aDio.get(
        AppConstants.everything,
        queryParameters: {
          "q": AppLanguage.english.homeQuery,
          "language": AppLanguage.english.newsApiLanguage,
          "sortBy": "publishedAt",
          "page": page,
          "pageSize": pageSize,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        return NewsApiResponse.fromJson(response.data);
      }
      throw Exception(response.statusMessage);
    } catch (e) {
      rethrow;
    }
  }
}
