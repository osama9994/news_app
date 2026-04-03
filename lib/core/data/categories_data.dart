import 'package:flutter/material.dart';
import 'package:news_app/features/categories/model/category_model.dart';


class CategoriesData {
  static const List<CategoryModel> categories = [
    CategoryModel(
      title: "business",
      icon: Icons.business_center,
      color: Colors.blue,
    ),
    CategoryModel(
      title: "entertainment",
      icon: Icons.movie,
      color: Colors.purple,
    ),
    CategoryModel(
      title: "health",
      icon: Icons.health_and_safety,
      color: Colors.red,
    ),
    CategoryModel(
      title: "science",
      icon: Icons.science,
      color: Colors.green,
    ),
    CategoryModel(
      title: "sports",
      icon: Icons.sports_soccer,
      color: Colors.orange,
    ),
    CategoryModel(
      title: "technology",
      icon: Icons.computer,
      color: Colors.teal,
    ),
  ];
}
