// import 'dart:convert';
// import 'package:hive/hive.dart';

// part 'article_model.g.dart';

// @HiveType(typeId:0)
// class Article  extends HiveObject{
//   @HiveField(0)
//   final Source? source;
//   @HiveField(1)
//   final String? auther;
//   @HiveField(2)
//   final String? title;
//   @HiveField(3)
//   final String? description;
//   @HiveField(4)
//   final String? url;
//   @HiveField(5)
//   final String? urlToImage;
//   @HiveField(6)
//   final String? publishedAt;
//   @HiveField(7)
//   final String? content;
//   @HiveField(8)
//   final bool isFavorite;

//   Article({
//      this.source,
//      this.auther,
//      this.title,
//      this.description,
//      this.url,
//      this.urlToImage,
//      this.publishedAt,
//      this.content,
//      this.isFavorite=false,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'source': source?.toMap(),
//       'auther': auther,
//       'title': title,
//       'description': description,
//       'url': url,
//       'urlToImage': urlToImage,
//       'publishedAt': publishedAt,
//       'content': content,
//     };
//   }

//   factory Article.fromMap(Map<String, dynamic> map) {
//     return Article(
//       source: map['source'] != null ? Source.fromMap(map['source'] as Map<String,dynamic>) : null,
//       auther: map['auther'] != null ? map['auther'] as String : null,
//       title: map['title'] != null ? map['title'] as String : null,
//       description: map['description'] != null ? map['description'] as String : null,
//       url: map['url'] != null ? map['url'] as String : null,
//       urlToImage: map['urlToImage'] != null ? map['urlToImage'] as String : null,
//       publishedAt: map['publishedAt'] != null ? map['publishedAt'] as String : null,
//       content: map['content'] != null ? map['content'] as String : null,
//     );
//   }

 

//   String toJson() => json.encode(toMap());

//   factory Article.fromJson(String source) => Article.fromMap(json.decode(source) as Map<String, dynamic>);

//   Article copyWith({
//     Source? source,
//     String? auther,
//     String? title,
//     String? description,
//     String? url,
//     String? urlToImage,
//     String? publishedAt,
//     String? content,
//     bool? isFavorite,
//   }) {
//     return Article(
//       source: source ?? this.source,
//       auther: auther ?? this.auther,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       url: url ?? this.url,
//       urlToImage: urlToImage ?? this.urlToImage,
//       publishedAt: publishedAt ?? this.publishedAt,
//       content: content ?? this.content,
//       isFavorite: isFavorite ?? this.isFavorite,
//     );
//   }
// }

// @HiveType(typeId: 1) 
// class Source extends HiveObject {
//   @HiveField(0)
//   final String? id;
//   @HiveField(1)
//   final String? name;

//   Source({
//    this.id,
//    this.name
//    });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//     };
//   }

//   factory Source.fromMap(Map<String, dynamic> map) {
//     return Source(
//       id: map['id'] != null ? map['id'] as String : null,
//       name: map['name'] != null ? map['name'] as String : null,
//     );
//   }

 
// }
import 'dart:convert';
import 'package:hive/hive.dart';
part 'article_model.g.dart'; // ❌ مش موجود!

@HiveType(typeId:0)
class Article extends HiveObject{
  @HiveField(0)
  final Source? source;
  @HiveField(1)
  final String? auther;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? url;
  @HiveField(5)
  final String? urlToImage;
  @HiveField(6)
  final String? publishedAt;
  @HiveField(7)
  final String? content;
  @HiveField(8)
  final bool isFavorite;
  // ✅ جديد
  @HiveField(9)
  final String? category;
  @HiveField(10)
  final bool isBreaking;

  Article({
    this.source,
    this.auther,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.isFavorite = false,
    this.category,           // ✅ جديد
    this.isBreaking = false, // ✅ جديد
  });

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
    String? category,   // ✅ جديد
    bool? isBreaking,   // ✅ جديد
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
      category: category ?? this.category,     // ✅ جديد
      isBreaking: isBreaking ?? this.isBreaking, // ✅ جديد
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source?.toMap(),
      'auther': auther,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'category': category,     // ✅ جديد
      'isBreaking': isBreaking, // ✅ جديد
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: map['source'] != null ? Source.fromMap(map['source']) : null,
      auther: map['auther'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt: map['publishedAt'],
      content: map['content'],
      category: map['category'],                        // ✅ جديد
      isBreaking: map['isBreaking'] ?? false,           // ✅ جديد
    );
  }

  String toJson() => json.encode(toMap());
  factory Article.fromJson(dynamic source) {
    if (source is String) return Article.fromMap(json.decode(source));
    if (source is Map<String, dynamic>) return Article.fromMap(source);
    throw Exception('Invalid source type');
  }
}

// Add Source class with fromMap method
@HiveType(typeId: 1)
class Source extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;

  Source({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'],
      name: map['name'],
    );
  }
}
