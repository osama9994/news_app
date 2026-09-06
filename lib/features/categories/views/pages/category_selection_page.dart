import 'package:flutter/material.dart';
import 'package:news_app/core/data/categories_data.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/categories/views/widgets/category_card.dart';

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoriesData.categories;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final tr = context.tr;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            onTap: () => Navigator.pop(context),
            iconData: Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          tr.text('categories'),
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          AppBarButton(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
            iconData: Icons.search,
            color: isDarkMode ? Colors.white : Colors.black,
            
          ),
          const SizedBox(width: 12),
          AppBarButton(
            onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
            iconData: Icons.notifications_none_rounded,
            color: isDarkMode ? Colors.white : Colors.black,
           
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.categoryNews,
                  arguments: category.title,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
