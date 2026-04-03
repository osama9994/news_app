import 'package:flutter/material.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/models/article_model.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/core/views/widgets/app_drawer.dart';
import 'package:news_app/features/home/views/widget/recommendation_list_widget.dart';

class RecommendationNewsPage extends StatelessWidget {
  final List<Article> articles;

  const RecommendationNewsPage({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = context.tr;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(tr.text('recommendationNews')),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            onTap: () => Navigator.pop(context),
            iconData: Icons.arrow_back,
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: RecommendationListWidget(articles: articles),
          ),
        ),
      ),
    );
  }
}
