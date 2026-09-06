// import 'package:flutter/material.dart';
// import 'package:news_app/features/categories/model/category_model.dart';


// class CategoriesData {
//   static const List<CategoryModel> categories = [
//     CategoryModel(
//       title: "business",
//       icon: Icons.business_center,
//       color: Colors.blue,
//     ),
//     CategoryModel(
//       title: "entertainment",
//       icon: Icons.movie,
//       color: Colors.purple,
//     ),
//     CategoryModel(
//       title: "health",
//       icon: Icons.health_and_safety,
//       color: Colors.red,
//     ),
//     CategoryModel(
//       title: "science",
//       icon: Icons.science,
//       color: Colors.green,
//     ),
//     CategoryModel(
//       title: "sports",
//       icon: Icons.sports_soccer,
//       color: Colors.orange,
//     ),
//     CategoryModel(
//       title: "technology",
//       icon: Icons.computer,
//       color: Colors.teal,
//     ),
//   ];
// }


import 'package:flutter/material.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/categories/model/category_model.dart';

class CategoriesData {
  static const List<CategoryModel> categories = [
    CategoryModel(
      title: "business",
      icon: Icons.business_center,
      color: AppColors.categoryBusiness,
    ),
    CategoryModel(
      title: "entertainment",
      icon: Icons.movie,
      color: AppColors.categoryEntertainment,
    ),
    CategoryModel(
      title: "health",
      icon: Icons.health_and_safety,
      color: AppColors.categoryHealth,
    ),
    CategoryModel(
      title: "science",
      icon: Icons.science,
      color: AppColors.categoryScience,
    ),
    CategoryModel(
      title: "sports",
      icon: Icons.sports_soccer,
      color: AppColors.categorySports,
    ),
    CategoryModel(
      title: "technology",
      icon: Icons.computer,
      color: AppColors.categoryTechnology,
    ),
  ];
}