class SearchBody {
  final String q;
  final String searchIn;
  final int page;
  final int pageSize;
  final String language;

  SearchBody({
    required this.q,
    required this.language,
    this.searchIn = "title",
    this.page = 1,
    this.pageSize = 15,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'q': q,
      'searchIn': searchIn,
      'page': page,
      'pageSize': pageSize,
      'language': language,
    };
  }

  factory SearchBody.fromJson(Map<String, dynamic> map) {
    return SearchBody(
      q: map['q'] as String,
      searchIn: map['searchIn'] as String,
      page: map['page'] as int,
      pageSize: map['pageSize'] as int,
      language: map['language'] as String,
    );
  }
}
