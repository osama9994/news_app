import 'package:flutter/material.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/home/views/widget/custom_carousel_slider.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';


class BreakingNewsPage extends StatelessWidget {
  final List<Article> articles; // تمرير Breaking News

  const BreakingNewsPage({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Breaking News"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            onTap: () => Navigator.pop(context),
            iconData: Icons.arrow_back,
          ),
        ),
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