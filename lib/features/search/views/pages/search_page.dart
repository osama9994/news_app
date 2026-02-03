
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/views/widgets/article_widget_item.dart';
import 'package:news_app/features/search/search_cubit/search_cubit.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final searchCubit=BlocProvider.of<SearchCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration:  InputDecoration(
                hintText: "Search by title",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                  bloc: searchCubit,
                  buildWhen: (previous, current) =>
                    current is Searching ||
                    current is SearchResultsLoaded ||
                    current is SearchResultError,
                  builder: (context, state) {
                    if(state is Searching){
                      return TextButton(
                      onPressed: null,
                      child: const Text("Search"),
                    );
                    }
                    return TextButton(
                      onPressed: () async => await searchCubit.search(_searchController.text),
                      child: const Text("Search"),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                bloc: searchCubit,
                buildWhen: (previous, current) =>
                 current is Searching||
                current is SearchResultsLoaded||
                current is SearchResultError,
                builder: (context, state) {
                  if(state is Searching){
                   return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                  }
                else if(state is SearchResultsLoaded){
                  final articles=state.articles;
                  if(articles.isEmpty){
                    return const Center(
                      child: Text("No articles found"),
                    );
              
                  }else{
                     return ListView.separated(
                      itemCount: articles.length,
                      itemBuilder: (_, index) {
                        final article=articles[index];
                         return ArticleWidgetItem(article: article,isSmaller: true,);

                      }, separatorBuilder: (BuildContext context, int index)=>const SizedBox( height: 16,),
                      );
              
                  }
                  }
                  else {
                    return Center(child: Text("Search for articles"),);
                  }
              
                },
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}