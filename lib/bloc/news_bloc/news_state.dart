import 'package:equatable/equatable.dart';
import 'package:headspace_interview/models/article.dart';

abstract class NewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;

  NewsLoaded({required this.articles});

  NewsLoaded copyWith({List<NewsArticle>? articles}) {
    return NewsLoaded(articles: articles ?? this.articles);
  }

  @override
  List<Object> get props => [articles];
}

class NewsError extends NewsState {
  final String message;

  NewsError({required this.message});

  @override
  List<Object> get props => [message];
}

class SavedArticlesLoaded extends NewsState {
  final List<NewsArticle> savedArticles;

  SavedArticlesLoaded({required this.savedArticles});

  @override
  List<Object> get props => [savedArticles];
}
