
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:news_app/core/views/widgets/article_widget_item.dart';
// import 'package:news_app/features/search/search_cubit/search_cubit.dart';


// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     final searchCubit=BlocProvider.of<SearchCubit>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Search"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             TextField(
//               controller: _searchController,
//               decoration:  InputDecoration(
//                 hintText: "Search by title",
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: BlocBuilder<SearchCubit, SearchState>(
//                   bloc: searchCubit,
//                   buildWhen: (previous, current) =>
//                     current is Searching ||
//                     current is SearchResultsLoaded ||
//                     current is SearchResultError,
//                   builder: (context, state) {
//                     if(state is Searching){
//                       return TextButton(
//                       onPressed: null,
//                       child: const Text("Search"),
//                     );
//                     }
//                     return TextButton(
//                       onPressed: () async => await searchCubit.search(_searchController.text),
//                       child: const Text("Search"),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: BlocBuilder<SearchCubit, SearchState>(
//                 bloc: searchCubit,
//                 buildWhen: (previous, current) =>
//                  current is Searching||
//                 current is SearchResultsLoaded||
//                 current is SearchResultError,
//                 builder: (context, state) {
//                   if(state is Searching){
//                    return const Center(
//                                 child: CircularProgressIndicator.adaptive(),
//                               );
//                   }
//                 else if(state is SearchResultsLoaded){
//                   final articles=state.articles;
//                   if(articles.isEmpty){
//                     return const Center(
//                       child: Text("No articles found"),
//                     );
              
//                   }else{
//                      return ListView.separated(
//                       itemCount: articles.length,
//                       itemBuilder: (_, index) {
//                         final article=articles[index];
//                          return ArticleWidgetItem(article: article,isSmaller: true,);

//                       }, separatorBuilder: (BuildContext context, int index)=>const SizedBox( height: 16,),
//                       );
              
//                   }
//                   }
//                   else {
//                     return Center(child: Text("Search for articles"),);
//                   }
              
//                 },
//               ),
//             ),
        
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';
import 'package:news_app/features/search/search_cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _doSearch(BuildContext context) {
    final text = _searchController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a search term")),
      );
      return;
    }
    BlocProvider.of<SearchCubit>(context).search(text);
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = BlocProvider.of<SearchCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── Search Field ──
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.trim().isEmpty) return;
                searchCubit.search(value.trim());
              },
              decoration: InputDecoration(
                hintText: "Search for news...",
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

            // ── Category Chips ──
            const Text(
              "Filter by category",
              style: TextStyle(
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
                      // ✅ إذا في نص ابحث مباشرة
                      if (_searchController.text.trim().isNotEmpty) {
                        searchCubit.search(_searchController.text.trim());
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey2,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
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

            // ── Results ──
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                bloc: searchCubit,
                buildWhen: (_, current) =>
                    current is Searching ||
                    current is SearchResultsLoaded ||
                    current is SearchResultError,
                builder: (context, state) {
                  if (state is Searching) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  if (state is SearchResultsLoaded) {
                    final articles = state.articles;
                    if (articles.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 12),
                            Text(
                              "No articles found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: articles.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 16),
                      itemBuilder: (_, index) => ArticleWidgetItem(
                        article: articles[index],
                        isSmaller: true,
                      ),
                    );
                  }

                  if (state is SearchResultError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 12),
                          Text(state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  // ── Initial State ──
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.newspaper_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          "Search for any news topic",
                          style: TextStyle(color: Colors.grey),
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
    );
  }
}