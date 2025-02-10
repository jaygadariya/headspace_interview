import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../db/db_helper.dart';
import '../../models/article.dart';
import '../../repository/news_repository.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsApiService newsApiService;
  final DatabaseHelper databaseHelper;
  String? from;
  String? toDate;

  NewsBloc({required this.newsApiService, required this.databaseHelper}) : super(NewsInitial()) {
    on<FetchNewsEvent>((event, emit) async {
      if (event.page < 1 && event.fetchLatest == false) {
        emit(NewsLoading());
      }
      try {
        if (event.fetchLatest == true) {
          toDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
          from = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(from!));
        }
        final articles = event.fetchLatest ? await newsApiService.getNews(event.page, from!, toDate!) : await newsApiService.getNews(event.page, '', '');
        final articlesWithSavedStatus = await Future.wait(articles.map((article) async {
          final savedArticle = await databaseHelper.getArticle(article.title);
          return article.copyWith(isSaved: savedArticle != null);
        }).toList());

        if (event.page > 1 || event.fetchLatest == true) {
          final currentState = state as NewsLoaded;
          emit(NewsLoading());
          if (event.fetchLatest) {
            currentState.articles.insertAll(0, articlesWithSavedStatus);
          } else {
            currentState.articles.insertAll(currentState.articles.length, articlesWithSavedStatus);
            from = DateTime.now().toString();
          }
          emit(NewsLoaded(articles: currentState.articles));
        } else {
          from = DateTime.now().toString();
          emit(NewsLoaded(articles: articlesWithSavedStatus));
        }
      } catch (e) {
        emit(NewsError(message: e.toString()));
      }
    });

    on<SaveArticleEvent>((event, emit) async {
      await databaseHelper.saveArticle(event.article);
      final savedArticle = event.article.copyWith(isSaved: true);
      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;
        final updatedArticles = currentState.articles.map((NewsArticle article) => article.title == event.article.title ? savedArticle : article).toList();
        emit(NewsLoaded(articles: updatedArticles));
      }
      if (state is SavedArticlesLoaded) {
        final currentState = state as SavedArticlesLoaded;
        final updatedArticles = currentState.savedArticles.map((NewsArticle article) => article.title == event.article.title ? savedArticle : article).toList();
        emit(SavedArticlesLoaded(savedArticles: updatedArticles));
      }
    });
    on<UnsaveArticleEvent>((event, emit) async {
      await databaseHelper.unsaveArticle(event.article.title);
      final unsavedArticle = event.article.copyWith(isSaved: false);

      if (state is NewsLoaded) {
        final currentState = state as NewsLoaded;
        final updatedArticles = currentState.articles.map((article) => article.title == event.article.title ? unsavedArticle : article).toList();
        emit(NewsLoaded(articles: updatedArticles));
      }
      if (state is SavedArticlesLoaded) {
        final currentState = state as SavedArticlesLoaded;
        final updatedArticles = currentState.savedArticles.map((article) => article.title == event.article.title ? unsavedArticle : article).toList();
        emit(SavedArticlesLoaded(savedArticles: updatedArticles));
      }
    });

    on<LoadSavedArticlesEvent>((event, emit) async {
      emit(NewsLoading());
      try {
        final savedArticles = await databaseHelper.getSavedArticles();
        emit(SavedArticlesLoaded(savedArticles: savedArticles));
      } catch (e) {
        emit(NewsError(message: e.toString()));
      }
    });
  }
}
