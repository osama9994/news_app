import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/home/models/top_headlines_api_response.dart';

class RecommendationListWidget extends StatelessWidget {
  final List<Article> articles;
  const RecommendationListWidget({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: articles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (_, index) {
        final article = articles[index];
        // final parsedDate=DateTime.parse(article.publishedAt??DateTime.now().toString());
        // final formattedDate=DateFormat.yMMMd(parsedDate).toString();
        final parsedDate = DateTime.parse(
          article.publishedAt ?? DateTime.now().toIso8601String(),
        );

        final formattedDate = DateFormat.yMMMd().format(parsedDate);

        return InkWell(
           onTap:() => Navigator.pushNamed(context,AppRoutes.articleDetails ,arguments: article),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage ?? "",
                  width: 160,
                  height: 170,
                  fit: BoxFit.cover,
          
                  placeholder: (context, url) => Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                  ),
          
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                  ),
                ),
          
                // CachedNetworkImage(
                //   imageUrl: article.urlToImage??"https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
                //   width: 160,
                //   height: 170,
                //   fit: BoxFit.cover,
                //   ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formattedDate,
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.copyWith(color: AppColors.grey2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.title ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article.source?.name ?? "",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
