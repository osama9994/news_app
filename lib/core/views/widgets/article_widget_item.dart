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
 final bool isFavorite ;
  
  const ArticleWidgetItem({
    super.key,
    required this.article,
    this.isSmaller = false,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final parsedDate = DateTime.tryParse(
            article.publishedAt ?? DateTime.now().toIso8601String()) ??
        DateTime.now();
    final formattedDate = DateFormat.yMMMd(tr.localeCode).format(parsedDate);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRoutes.articleDetails,
          arguments: article),
      child: Row(
        children: [
          Stack(
            children: [
             
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? "",
                  width: isSmaller ? 140 : 170,
                  height: isSmaller ? 150 : 170,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover),
                  errorWidget: (context, url, error) => Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.cover),
                ),
              ),

              /// ❤️ Favorite Button
              PositionedDirectional(
                  top: 8,
                  end: 8,
                  child:
                      BlocBuilder<FavoriteActionsCubit, FavoriteActionsState>(
                    builder: (context, state) {
                      final cubit = context.read<FavoriteActionsCubit>();
                      final isFav = cubit.isFavorite(article);

                      return InkWell(
                        onTap: () => cubit.setFavorite(
                            article), // هذا سيصدر FavoriteActionsUpdated
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: Icon(
                            isFav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_outlined,
                            color: isFav ? Colors.red : Colors.black,
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),

          const SizedBox(width: 16),

          /// 📝 Article Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(formattedDate,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: AppColors.grey)),
                const SizedBox(height: 8),
                Text(
                  article.title ?? "",
                  maxLines: isSmaller ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(article.source?.name ?? tr.language.fallbackSourceName,
                    style: Theme.of(context).textTheme.labelLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
