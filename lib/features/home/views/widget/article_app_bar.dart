import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/cubit/favorite_actions/favorite_actions_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/core/cubit/favorite_actions/favorite_actions_cubit.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';

class ArticleAppBar extends StatelessWidget {
  final Article article;
  final VoidCallback onBack;

  const ArticleAppBar({
    super.key,
    required this.article,
    required this.onBack,
  });

  void _share() {
    final title = article.title ?? '';
    final url = article.url ?? '';
    Share.share(url.isNotEmpty ? '$title\n\n$url' : title);
  }

  // ignore: unused_element
  Future<void> _readMore(BuildContext context) async {
    final rawUrl = (article.url ?? '').trim();
    final uri = Uri.tryParse(rawUrl);
    final tr = context.tr;

    if (rawUrl.isEmpty || uri == null || !uri.hasScheme) {
      _showSnackBar(context, tr.text('noArticleLinkAvailable'));
      return;
    }

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      _showSnackBar(context, tr.text('couldNotOpenArticleLink'));
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBarButton(
          onTap: onBack,
          iconData: Icons.arrow_back_outlined,
          hasPaddingBewteen: true,
          color: Colors.white,
          backgroundColor: Colors.black.withAlpha(70),
        ),
        Row(
          children: [
            AppBarButton(
              onTap: _share,
              iconData: Icons.share,
              hasPaddingBewteen: true,
              color: Colors.white,
              backgroundColor: Colors.black.withAlpha(70),
            ),
            const SizedBox(width: 12),
            BlocBuilder<FavoriteActionsCubit, FavoriteActionsState>(
              builder: (context, _) {
                final cubit = context.read<FavoriteActionsCubit>();
                final isFav = cubit.isFavorite(article);
                return AppBarButton(
                  onTap: () => cubit.setFavorite(article),
                  iconData: isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_outlined,
                  hasPaddingBewteen: true,
                  color: isFav ? Colors.red : Colors.white,
                  backgroundColor: Colors.black.withAlpha(70),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}