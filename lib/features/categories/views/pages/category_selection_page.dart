import 'package:flutter/material.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/categories/views/widgets/category_item_button.dart';

class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({super.key});

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            onTap: () {
              Navigator.pop(context);
            },
            iconData: Icons.arrow_back,
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
            onTap: () {},
            iconData: Icons.notifications_none_rounded,
            hasPaddingBewteen: true,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Select a Category',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CategoryItemButton(
              title: 'Business',
              icon: Icons.business_center,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.categoryNews,
                  arguments: "business",
                );
              },
            ),
            CategoryItemButton(
              title: 'Entertainment',
              icon: Icons.movie,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.categoryNews,
                  arguments: "entertainment",
                );
              },
            ),
            CategoryItemButton(
              title: 'Health',
              icon: Icons.health_and_safety,
              onTap: () {
                 Navigator.pushNamed(
                  context,
                  AppRoutes.categoryNews,
                  arguments: "Health",
                );
              },
            ),
            CategoryItemButton(
              title: 'Science',
              icon: Icons.science,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.categoryNews,
                  arguments: "Science",
                );
              },
            ),
            CategoryItemButton(
              title: 'Sports',
              icon: Icons.sports_soccer,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.categoryNews,
                  arguments: "Sports",
                );
              },
            ),
            CategoryItemButton(
              title: 'Technology',
              icon: Icons.computer,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.categoryNews,
                  arguments: "Technology",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
