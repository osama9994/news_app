import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/localization/app_strings.dart';
import 'package:news_app/core/localization/language_cubit/language_cubit.dart';
import 'package:news_app/core/localization/language_cubit/language_state.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';
import 'package:news_app/core/views/widgets/empty_state_widget.dart';
import 'package:news_app/features/categories/views/widgets/interests_shimmer.dart';
import 'package:news_app/features/search/search_cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _doSearch(BuildContext context) {
    final text = _searchController.text.trim();
    final tr = context.tr;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.text('pleaseEnterSearchTerm'))),
      );
      return;
    }
    BlocProvider.of<SearchCubit>(context).search(text);
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<SearchCubit>(context);
    final tr = context.tr;

    return BlocListener<LanguageCubit, LanguageState>(
      listener: (context, state) {
        searchCubit.applyCurrentLanguage();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr.text('search')),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  if (value.trim().isEmpty) return;
                  searchCubit.search(value.trim());
                },
                decoration: InputDecoration(
                  hintText: tr.text('searchForNews'),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                    bloc: searchCubit,
                    buildWhen: (_, current) =>
                        current is Searching ||
                        current is SearchResultsLoaded ||
                        current is SearchResultError,
                    builder: (context, state) {
                      if (state is Searching) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: Icon(Icons.arrow_forward_rounded),
                          ),
                        );
                      }
                      return IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded),
                        onPressed: () => _doSearch(context),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tr.text('filterByCategory'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: SearchCubit.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = SearchCubit.categories[index];
                    final isSelected = _selectedCategory == category;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        searchCubit.selectCategory(category);
                        if (_searchController.text.trim().isNotEmpty) {
                          searchCubit.search(_searchController.text.trim());
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.primary : AppColors.grey2,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tr.category(category),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  bloc: searchCubit,
                  buildWhen: (_, current) =>
                      current is Searching ||
                      current is SearchResultsLoaded ||
                      current is SearchResultError,
                  builder: (context, state) {
                    if (state is Searching) {
                      return InterestsShimmer();
                    }

                    if (state is SearchResultsLoaded) {
                      final articles = state.articles;

                      if (articles.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                tr.text('noArticlesFound'),
                                style: const TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => _doSearch(context),
                                icon: const Icon(Icons.refresh),
                                label: Text(tr.text('retrySearch')),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.favorites,
                                ),
                                child: Text(
                                  tr.text('goToOfflineFavorites'),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: articles.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (_, index) => ArticleWidgetItem(
                          article: articles[index],
                          isSmaller: true,
                        ),
                      );
                    }

                    if (state is SearchResultError) {
                      return EmptyStateWidget(
                        icon: Icons.search_off,
                        title: tr.text('noArticlesFound'),
                        buttonText: tr.text('retrySearch'),
                        onButtonPressed: () => _doSearch(context),
                        extraButton: TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, AppRoutes.favorites),
                          child: Text(
                            tr.text('goToFavorites'),
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.newspaper_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tr.text('searchAnyNewsTopic'),
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
