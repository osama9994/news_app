// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// the things i will get from api
class NewApiResponse {
  final String status;
  final int totalResults;
  final List<Article>? articles;

  const NewApiResponse({
    required this.status,
    required this.totalResults,
    this.articles,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'totalResults': totalResults,
      'articles': articles!.map((x) => x.toMap()).toList(),
    };
  }

  factory NewApiResponse.fromJson(Map<String, dynamic> map) {
    return NewApiResponse(
      status: map['status'] as String,
      totalResults: map['totalResults'] as int,
      articles: map['articles'] != null
          ? List<Article>.from(
              (map['articles'] as List).map<Article?>(
                (x) => Article.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}

class Article {
  final Source? source;
  final String? auther;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final bool isFavorite;

 const Article({
     this.source,
     this.auther,
     this.title,
     this.description,
     this.url,
     this.urlToImage,
     this.publishedAt,
     this.content,
     this.isFavorite=false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source?.toMap(),
      'auther': auther,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: map['source'] != null ? Source.fromMap(map['source'] as Map<String,dynamic>) : null,
      auther: map['auther'] != null ? map['auther'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      urlToImage: map['urlToImage'] != null ? map['urlToImage'] as String : null,
      publishedAt: map['publishedAt'] != null ? map['publishedAt'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
    );
  }

 

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) => Article.fromMap(json.decode(source) as Map<String, dynamic>);

  Article copyWith({
    Source? source,
    String? auther,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
    bool? isFavorite,
  }) {
    return Article(
      source: source ?? this.source,
      auther: auther ?? this.auther,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Source {
  final String? id;
  final String? name;

 const Source({
   this.id,
   this.name
   });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

 
}
