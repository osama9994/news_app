// 

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/cubit/favorite_actions/favorite_actions_cubit.dart';
import 'package:news_app/core/cubit/favorite_actions/favorite_actions_state.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';

class ArticleWidgetItem extends StatelessWidget {
  final Article article;
  final bool isSmaller;

  const ArticleWidgetItem({
    super.key,
    required this.article,
    this.isSmaller = false,
  });

  @override
  Widget build(BuildContext context) {
    final tr       = context.tr;
    final theme    = Theme.of(context);
    final size     = isSmaller ? 140.0 : 170.0;
    final maxLines = isSmaller ? 2 : 3;

    final parsedDate = DateTime.tryParse(
          article.publishedAt ?? DateTime.now().toIso8601String(),
        ) ?? DateTime.now();
    final formattedDate = DateFormat.yMMMd(tr.localeCode).format(parsedDate);

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.articleDetails,
        arguments: article,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? '',
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (_, __, ___) => Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              PositionedDirectional(
                top: 8,
                end: 8,
                child: BlocBuilder<FavoriteActionsCubit, FavoriteActionsState>(
                  builder: (context, _) {
                    final cubit = context.read<FavoriteActionsCubit>();
                    final isFav = cubit.isFavorite(article);

                    return InkWell(
                      onTap: () => cubit.setFavorite(article),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_outlined,
                          color: isFav ? Colors.red : Colors.black,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  article.title ?? '',
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  article.source?.name ?? '',
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}