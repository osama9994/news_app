import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_state.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article article;
  const ArticleDetailsPage({super.key, required this.article});

  void _shareArticle() {
    final title = article.title ?? '';
    final url = article.url ?? '';
    final text = url.isNotEmpty ? '$title\n\n$url' : title;
    Share.share(text);
  }

  Future<void> _readMore(BuildContext context) async {
    final rawUrl = (article.url ?? '').trim();
    final uri = Uri.tryParse(rawUrl);

    if (rawUrl.isEmpty || uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No article link available.")),
      );
      return;
    }

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the article link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.sizeOf(context);

    final parsedDate = DateTime.parse(
      article.publishedAt ?? DateTime.now().toString(),
    );
    final formatedDate = DateFormat.yMMMd().format(parsedDate);

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
                  isDarkMode
                      ? Colors.black.withOpacity(0.8)
                      :Colors.black.withOpacity(0.8),
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
                    backgroundColor: Colors.black.withOpacity(0.35)
                  ),
                  Row(
                    children: [
                      // ✅ زر المشاركة يعمل الآن
                      AppBarButton(
                        onTap: _shareArticle,
                        iconData: Icons.share,
                        hasPaddingBewteen: true,
                        color: Colors.white,
                        backgroundColor:  Colors.black.withOpacity(0.35),
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
                            backgroundColor:  Colors.black.withOpacity(0.35),
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
                            "General",
                            style: theme.textTheme.bodyLarge!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                        "${article.isBreaking ? ' Breaking' : ' Trending'} . $formatedDate",
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
                          top: Radius.circular(36)),
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
                                      article.urlToImage ?? ""),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    article.source?.name ?? "UNKNOWN",
                                    style: theme.textTheme.headlineSmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              (article.description ?? "") +
                                  (article.content ?? ""),
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: isDarkMode
                                    ? Colors.white70
                                    : AppColors.black,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // ✅ زر المشاركة في الأسفل
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _shareArticle,
                                icon: const Icon(Icons.share_rounded),
                                label: const Text("Share Article"),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _readMore(context),
                                icon: const Icon(Icons.open_in_new_rounded),
                                label: const Text("Read more"),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
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