import 'package:headspace_interview/models/article.dart';

class NewsState {
  final List<Article> articles;
  final bool isLoading;
  final bool hasMore;

  NewsState({required this.articles, required this.isLoading, required this.hasMore});
}
