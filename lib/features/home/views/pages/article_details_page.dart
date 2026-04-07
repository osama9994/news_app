import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_state.dart';
import 'package:news_app/core/localization/app_language.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/services/article_translation_service.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsPage extends StatefulWidget {
  final Article article;
  const ArticleDetailsPage({super.key, required this.article});

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  String? _translatedDescription;
  bool _isTranslating = false;
  bool _hasTranslatedDescription = false;

  void _shareArticle() {
    final title = widget.article.title ?? '';
    final url = widget.article.url ?? '';
    final text = url.isNotEmpty ? '$title\n\n$url' : title;
    Share.share(text);
  }

  Future<void> _readMore(BuildContext context) async {
    final rawUrl = (widget.article.url ?? '').trim();
    final uri = Uri.tryParse(rawUrl);
    final tr = context.tr;

    if (rawUrl.isEmpty || uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.text('noArticleLinkAvailable'))),
      );
      return;
    }

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.text('couldNotOpenArticleLink'))),
      );
    }
  }

  Future<void> _translateDescriptionToArabic() async {
    final description = widget.article.description?.trim() ?? '';
    if (description.isEmpty || _isTranslating || _hasTranslatedDescription) {
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    final translated = await ArticleTranslationService.instance.translateText(
      description,
      from: 'auto',
      to: 'ar',
    );

    if (!mounted) return;

    final hasTranslated = translated.trim().isNotEmpty && translated != description;

    setState(() {
      _translatedDescription = hasTranslated ? translated : null;
      _hasTranslatedDescription = hasTranslated;
      _isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);
    final tr = context.tr;
    final article = widget.article;
    final isEnglishMode = tr.language == AppLanguage.english;
    final hasDescription = (article.description ?? '').trim().isNotEmpty;
    final descriptionText =
        _hasTranslatedDescription && (_translatedDescription?.trim().isNotEmpty ?? false)
        ? _translatedDescription!
        : (article.description ?? '');

    final parsedDate = DateTime.parse(
      article.publishedAt ?? DateTime.now().toString(),
    );
    final formattedDate = DateFormat.yMMMd(tr.localeCode).format(parsedDate);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: article.urlToImage ?? "",
            width: double.infinity,
            height: size.height * 0.5,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/placeholder.png', fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.center,
                begin: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.06,
            left: 8,
            right: 8,
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarButton(
                    onTap: () => Navigator.pop(context),
                    iconData: Icons.arrow_back_outlined,
                    hasPaddingBewteen: true,
                    color: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.35),
                  ),
                  Row(
                    children: [
                      AppBarButton(
                        onTap: _shareArticle,
                        iconData: Icons.share,
                        hasPaddingBewteen: true,
                        color: Colors.white,
                        backgroundColor: Colors.black.withOpacity(0.35),
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<FavoriteActionsCubit, FavoriteActionsState>(
                        builder: (context, state) {
                          final cubit = context.read<FavoriteActionsCubit>();
                          final isFav = cubit.isFavorite(article);
                          return AppBarButton(
                            onTap: () => cubit.setFavorite(article),
                            iconData: isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_outlined,
                            hasPaddingBewteen: true,
                            color: isFav ? Colors.red : Colors.white,
                            backgroundColor: Colors.black.withOpacity(0.35),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: size.height * 0.28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            tr.text('general'),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${tr.articleStateLabel(article.isBreaking)} . $formattedDate",
                        style: theme.textTheme.labelLarge!
                            .copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(36),
                      ),
                      color: theme.cardColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                    article.urlToImage ?? "",
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    article.source?.name ??
                                        tr.language.fallbackSourceName,
                                    style: theme.textTheme.headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (isEnglishMode && hasDescription) ...[
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _isTranslating ||
                                          _hasTranslatedDescription
                                      ? null
                                      : _translateDescriptionToArabic,
                                  icon: _isTranslating
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(
                                          _hasTranslatedDescription
                                              ? Icons.check_rounded
                                              : Icons.translate_rounded,
                                        ),
                                  label: Text(
                                    _isTranslating
                                        ? tr.text('translating')
                                        : _hasTranslatedDescription
                                        ? tr.text('translatedToArabic')
                                        : tr.text('translateToArabic'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            Text(
                              descriptionText,
                              textAlign: _hasTranslatedDescription
                                  ? TextAlign.right
                                  : TextAlign.start,
                              textDirection: _hasTranslatedDescription
                                  ? ui.TextDirection.rtl
                                  : ui.TextDirection.ltr,
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : AppColors.black,
                              ),
                            ),
                            if ((article.content ?? '').trim().isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                article.content ?? "",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: isDarkMode
                                      ? Colors.white70
                                      : AppColors.black,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _shareArticle,
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
                        ),
                      ),
                    ),
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
