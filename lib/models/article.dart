import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;
  final bool isSaved;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    this.isSaved = false,
  });

  NewsArticle copyWith({bool? isSaved}) {
    return NewsArticle(
      title: this.title,
      description: this.description,
      url: this.url,
      urlToImage: this.urlToImage,
      publishedAt: this.publishedAt,
      content: this.content,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [title, description, url, urlToImage, publishedAt, content, isSaved];
}
