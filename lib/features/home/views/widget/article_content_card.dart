import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleContentCard extends StatelessWidget {
  final Article article;
  final String? translatedDescription;
  final bool isTranslating;
  final bool hasTranslated;
  final VoidCallback onTranslate;

  const ArticleContentCard({
    super.key,
    required this.article,
    required this.translatedDescription,
    required this.isTranslating,
    required this.hasTranslated,
    required this.onTranslate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tr = context.tr;

    final hasDescription = (article.description ?? '').trim().isNotEmpty;
    final displayedDescription = hasTranslated && (translatedDescription?.isNotEmpty ?? false)
        ? translatedDescription!
        : (article.description ?? '');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        color: theme.cardColor,
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SourceRow(article: article, tr: tr, theme: theme),
            const SizedBox(height: 24),
            if (hasDescription) ...[
              _TranslateButton(
                isTranslating: isTranslating,
                hasTranslated: hasTranslated,
                onTranslate: onTranslate,
                tr: tr,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              displayedDescription,
              textAlign: hasTranslated ? TextAlign.right : TextAlign.start,
              textDirection: hasTranslated ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              style: theme.textTheme.titleMedium!.copyWith(
                color: isDark ? Colors.white70 : AppColors.black,
              ),
            ),
            if ((article.content ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                article.content!,
                style: theme.textTheme.titleMedium!.copyWith(
                  color: isDark ? Colors.white70 : AppColors.black,
                ),
              ),
            ],
            const SizedBox(height: 24),
            _ActionButtons(article: article, tr: tr),
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final Article article;
  final dynamic tr;
  final ThemeData theme;

  const _SourceRow({
    required this.article,
    required this.tr,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = (article.urlToImage ?? '').trim();
    final imageUri = Uri.tryParse(imageUrl);
    final hasSafeImageUrl = imageUri != null &&
        (imageUri.scheme == 'http' || imageUri.scheme == 'https');

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage:
              hasSafeImageUrl ? CachedNetworkImageProvider(imageUrl) : null,
          child: hasSafeImageUrl ? null : const Icon(Icons.newspaper_rounded),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            article.source?.name ?? tr.language.fallbackSourceName,
            style: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _TranslateButton extends StatelessWidget {
  final bool isTranslating;
  final bool hasTranslated;
  final VoidCallback onTranslate;
  final dynamic tr;

  const _TranslateButton({
    required this.isTranslating,
    required this.hasTranslated,
    required this.onTranslate,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: (isTranslating || hasTranslated) ? null : onTranslate,
        icon: isTranslating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                hasTranslated
                    ? Icons.check_rounded
                    : Icons.translate_rounded,
              ),
        label: Text(
          isTranslating
              ? tr.text('translating')
              : hasTranslated
              ? tr.text('translatedToArabic')
              : tr.text('translateToArabic'),
        ),
      ),
    );
  }
}
class _ActionButtons extends StatelessWidget {
  final Article article;
  final dynamic tr;

  const _ActionButtons({required this.article, required this.tr});

  void _share() {
    final title = article.title ?? '';
    final url = article.url ?? '';
    Share.share(url.isNotEmpty ? '$title\n\n$url' : title);
  }

  Future<void> _readMore(BuildContext context) async {
    final rawUrl = (article.url ?? '').trim();
    final uri = Uri.tryParse(rawUrl);
    final tr = context.tr;
    final hasSafeScheme =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (rawUrl.isEmpty || !hasSafeScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.text('noArticleLinkAvailable'))),
      );
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.text('couldNotOpenArticleLink'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _share,
            icon: const Icon(Icons.share_rounded),
            label: Text(tr.text('shareArticle')),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _readMore(context),
            icon: const Icon(Icons.open_in_new_rounded),
            label: Text(tr.text('readMore')),
          ),
        ),
      ],
    );
  }
}
