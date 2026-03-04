import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/categories/category_cubit/category_cubit.dart';
import 'package:news_app/features/categories/category_cubit/category_state.dart';

class CategoryNewsPage extends StatelessWidget {
  final String category;

  const CategoryNewsPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit()..getCategoryNews(category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.toUpperCase()),
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is CategoryLoaded) {
              final articles = state.articles;

              if (articles.isEmpty) {
                return const Center(
                  child: Text("No News Found"),
                );
              }

              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];

                  return ListTile(
                    title: Text(article.title ?? ""),
                    subtitle: Text(article.source?.name ?? ""),
                  );
                },
              );
            }

            if (state is CategoryError) {
              return Center(
                child: Text(state.message),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}