
class SearchBody {
  final String q;
  final String searchIn;
  final int page;
  final int pageSize;

  SearchBody({
    required this.q,
      this.searchIn="title",
       this.page=1
      ,  this.pageSize=15
      });


  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'q': q,
      'searchIn': searchIn,
      'page': page,
      'pageSize': pageSize,
    };
  }

  factory SearchBody.fromJson(Map<String, dynamic> map) {
    return SearchBody(
      q: map['q'] as String,
      searchIn: map['searchIn'] as String,
      page: map['page'] as int,
      pageSize: map['pageSize'] as int,
    );
  }

}
