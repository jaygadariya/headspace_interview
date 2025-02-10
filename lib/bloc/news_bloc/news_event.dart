import 'package:equatable/equatable.dart';
import 'package:headspace_interview/models/article.dart';

abstract class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchNewsEvent extends NewsEvent {
  final int page;
  final bool fetchLatest;
  FetchNewsEvent({required this.page, this.fetchLatest = false});
  @override
  List<Object> get props => [page, fetchLatest];
}

class SaveArticleEvent extends NewsEvent {
  final NewsArticle article;
  SaveArticleEvent({required this.article});
  @override
  List<Object> get props => [article];
}

class UnsaveArticleEvent extends NewsEvent {
  final NewsArticle article;
  UnsaveArticleEvent({required this.article});
  @override
  List<Object> get props => [article];
}

class LoadSavedArticlesEvent extends NewsEvent {}
