import 'package:dio/dio.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/models/article_model.dart';

class ArticleTranslationService {
  ArticleTranslationService._();

  static final ArticleTranslationService instance =
      ArticleTranslationService._();

  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://translate.googleapis.com'),
  );

  final Map<String, String> _cache = {};

  Future<String> translateText(
    String? text, {
    String from = 'auto',
    String to = 'ar',
  }) async {
    if (text == null || text.trim().isEmpty) return text ?? '';
    final value = text.trim();
    if (_shouldSkipTranslation(value)) return value;

    final cacheKey = '$from|$to|$value';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    try {
      final response = await _dio.get(
        '/translate_a/single',
        queryParameters: {
          'client': 'gtx',
          'sl': from,
          'tl': to,
          'dt': 't',
          'q': value,
        },
      );

      final translated = _extractTranslation(response.data);
      if (translated.isEmpty) return value;
      _cache[cacheKey] = translated;
      return translated;
    } catch (_) {
      return value;
    }
  }

  Future<String> translateQueryToEnglish(
    String query,
    AppLanguage language,
  ) async {
    if (language != AppLanguage.arabic) return query;
    return translateText(query, to: 'en');
  }

  Future<List<Article>> translateArticlesIfNeeded(
    List<Article> articles,
    AppLanguage language,
  ) async {
    if (language != AppLanguage.arabic) return articles;
    return Future.wait(articles.map(_translateArticleToArabic));
  }

  Future<Article> _translateArticleToArabic(Article article) async {
    final translatedTitle = await translateText(article.title, to: 'ar');
    final translatedDescription =
        await translateText(article.description, to: 'ar');
    final translatedContent = await translateText(article.content, to: 'ar');

    return article.copyWith(
      title: translatedTitle,
      description: translatedDescription,
      content: translatedContent,
    );
  }

  String _extractTranslation(dynamic data) {
    if (data is! List || data.isEmpty) return '';
    final firstPart = data.first;
    if (firstPart is! List) return '';

    final buffer = StringBuffer();
    for (final item in firstPart) {
      if (item is List && item.isNotEmpty && item.first is String) {
        buffer.write(item.first as String);
      }
    }
    return buffer.toString().trim();
  }

  bool _shouldSkipTranslation(String text) {
    if (text.startsWith('http')) return true;
    return !RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(text);
  }
}
