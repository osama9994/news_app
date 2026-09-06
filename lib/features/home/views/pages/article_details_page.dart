import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/article_translation_service.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/features/home/views/widget/article_app_bar.dart';
import 'package:news_app/features/home/views/widget/article_content_card.dart';
import 'package:news_app/features/home/views/widget/article_header_info.dart';
import 'package:news_app/features/home/views/widget/article_hero_image.dart';


class ArticleDetailsPage extends StatefulWidget {
  final Article article;
  const ArticleDetailsPage({super.key, required this.article});

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  String? _translatedDescription;
  bool _isTranslating = false;
  bool _hasTranslated = false;

  Future<void> _translateToArabic() async {
    final description = widget.article.description?.trim() ?? '';
    if (description.isEmpty || _isTranslating || _hasTranslated) return;

    setState(() => _isTranslating = true);

    final translated = await ArticleTranslationService.instance.translateText(
      description,
      from: 'auto',
      to: 'ar',
    );

    if (!mounted) return;

    final isValid = translated.trim().isNotEmpty && translated != description;

    setState(() {
      _translatedDescription = isValid ? translated : null;
      _hasTranslated = isValid;
      _isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final tr = context.tr;
    final article = widget.article;

    final formattedDate = DateFormat.yMMMd(tr.localeCode).format(
      DateTime.tryParse(article.publishedAt ?? '') ?? DateTime.now(),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ArticleHeroImage(
            imageUrl: article.urlToImage ?? '',
            height: size.height * 0.5,
          ),
          const _DarkGradientOverlay(),
          Positioned(
            top: size.height * 0.06,
            left: 8,
            right: 8,
            child: ArticleAppBar(
              article: article,
              onBack: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ArticleHeaderInfo(
                  article: article,
                  formattedDate: formattedDate,
                  tr: tr,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ArticleContentCard(
                    article: article,
                    translatedDescription: _translatedDescription,
                    isTranslating: _isTranslating,
                    hasTranslated: _hasTranslated,
                    onTranslate: _translateToArabic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkGradientOverlay extends StatelessWidget {
  const _DarkGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.center,
          colors: [
            Colors.black.withAlpha(8),
            Colors.black.withAlpha(55),
          ],
        ),
      ),
    );
  }
}