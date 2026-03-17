import 'package:flutter/material.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/home/views/widget/custom_carousel_slider.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';

class BreakingNewsPage extends StatelessWidget {
  final List<Article> articles;

 BreakingNewsPage({super.key, required this.articles});
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context); 

  return Scaffold(
     key: _scaffoldKey,
    backgroundColor: theme.scaffoldBackgroundColor, // ✅ خلفية الشاشة
   appBar: AppBar(
      // ✅ 2. تغيير اللون الأبيض إلى لون الثيم
      backgroundColor: theme.appBarTheme.backgroundColor, 
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AppBarButton(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          iconData: Icons.menu,
       
        ),
      ),
      actions: [
        AppBarButton(
          onTap: () => Navigator.pushNamed(context, AppRoutes.search),
          iconData: Icons.search,
          hasPaddingBewteen: true,
        ),
        const SizedBox(width: 12),
        AppBarButton(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          iconData: Icons.notifications_none_rounded,
          hasPaddingBewteen: true,
        ),
        const SizedBox(width: 12),
      ],
    ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomCarouselSlider(articles: articles),
              const SizedBox(height: 16),
              RecommendationListWidget(articles: articles),
            ],
          ),
        ),
      ),
    );
  }
}