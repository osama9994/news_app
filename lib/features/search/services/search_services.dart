import 'package:dio/dio.dart';
import 'package:news_app/core/models/new_api_response.dart';
import 'package:news_app/core/utils/app_constants.dart';
import 'package:news_app/features/search/models/search_body.dart';

class SearchServices {
  final aDio = Dio();
  Future<NewApiResponse> search(SearchBody body) async {
    try {
      aDio.options.baseUrl = AppConstants.baseUrl;
      final headers = {"Authorization": "Bearer ${AppConstants.apiKey}"};
      final response = await aDio.get(
        AppConstants.everything,
        queryParameters: body.toJson(),
        options: Options(headers: headers),
      );
      if (response.statusCode == 200) {
        return NewApiResponse.fromJson(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      rethrow;
    }
  }
}
