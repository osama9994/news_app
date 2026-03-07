import 'package:flutter/material.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';

class RecommendationNewsPage extends StatelessWidget {
  final List<Article> articles; // تمرير Recommended News

  const RecommendationNewsPage({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommendation News"),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: RecommendationListWidget(articles: articles),
          ),
        ),
      ),
    );
  }
}