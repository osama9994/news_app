import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/core/data/categories_data.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/views/widgets/app_bar_button.dart';
import 'package:news_app/features/categories/views/widgets/category_card.dart';


class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = CategoriesData.categories;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBarButton(
            onTap: () => Navigator.pop(context),
            iconData: Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Categories',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          AppBarButton(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
            iconData: Icons.search,
            color: Colors.black,
            hasPaddingBewteen: true,
          ),
          const SizedBox(width: 12),
          AppBarButton(
            onTap: () {},
            iconData: Icons.notifications_none_rounded,
            color: Colors.black,
            hasPaddingBewteen: true,
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
                  arguments: category.title.toLowerCase(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}