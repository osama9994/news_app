import 'package:flutter/material.dart';
import 'package:news_app/features/categories/model/category_model.dart';


class CategoriesData {
  static const List<CategoryModel> categories = [
    CategoryModel(
      title: "Business",
      icon: Icons.business_center,
      color: Colors.blue,
    ),
    CategoryModel(
      title: "Entertainment",
      icon: Icons.movie,
      color: Colors.purple,
    ),
    CategoryModel(
      title: "Health",
      icon: Icons.health_and_safety,
      color: Colors.red,
    ),
    CategoryModel(
      title: "Science",
      icon: Icons.science,
      color: Colors.green,
    ),
    CategoryModel(
      title: "Sports",
      icon: Icons.sports_soccer,
      color: Colors.orange,
    ),
    CategoryModel(
      title: "Technology",
      icon: Icons.computer,
      color: Colors.teal,
    ),
  ];
}