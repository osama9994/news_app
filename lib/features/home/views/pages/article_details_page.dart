import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_cubit.dart';
import 'package:news_app/core/cubit/favorite%20actions/favorite_actions_state.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article article;
  const ArticleDetailsPage({super.key, required this.article});

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
    // ✅ التأكد من أن خلفية الـ Scaffold تتبع الثيم
    backgroundColor: theme.scaffoldBackgroundColor,
    extendBodyBehindAppBar: true,
    body: Stack(
      children: [
        // الصورة والخلفية المتدرجة (تبقى كما هي لأنها تحت النصوص البيضاء)
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
                // ✅ في الوضع المظلم، نزيد تعتيم الخلفية لتتناسق مع السواد
                // ignore: deprecated_member_use
                isDarkMode ? Colors.black.withOpacity(0.9) : Colors.black.withOpacity(0.8),
                // ignore: deprecated_member_use
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
        ),
        // الأزرار العلوية (ستعمل تلقائياً لأننا عدلنا AppBarButton سابقاً)
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
                  color: Colors.white, // نثبته أبيض هنا لأنه فوق صورة داكنة
                  // ignore: deprecated_member_use
                  backgroundColor: Colors.black.withOpacity(0.35),
                ),
                Row(
                  children: [
                    AppBarButton(
                      onTap: () {},
                      iconData: Icons.share,
                      hasPaddingBewteen: true,
                      color: Colors.white,
                      // ignore: deprecated_member_use
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
                          // ignore: deprecated_member_use
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
        // محتوى المقال
        Padding(
          padding: EdgeInsets.only(top: size.height * 0.28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نصوص العنوان (تبقى بيضاء لأنها فوق التدرج الأسود للصورة)
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
                      "${article.isBreaking ? 'Breaking' : 'Trending'} . $formatedDate",
                      style: theme.textTheme.labelLarge!.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ✅ الجزء الأبيض السفلي (الحاوية البيضاء) - يجب أن تصبح داكنة
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                    // ✅ تغيير اللون من AppColors.white إلى لون سطح الثيم
                    color: theme.cardColor, 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView( // أضفت Scroll للحماية من تجاوز الشاشة
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: CachedNetworkImageProvider(
                                    article.urlToImage ?? ""),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                article.source?.name ?? "UNKNOWN",
                                style: theme.textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  // ✅ إزالة التثبيت اليدوي للون ليعمل تلقائياً من الثيم
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            (article.description ?? "") + (article.content ?? ""),
                            style: theme.textTheme.titleMedium!.copyWith(
                              // ✅ تغيير من AppColors.black إلى لون نص الثيم الافتراضي
                              color: isDarkMode ? Colors.white70 : AppColors.black,
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
