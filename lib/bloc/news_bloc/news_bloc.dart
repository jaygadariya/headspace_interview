import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headspace_interview/bloc/news_bloc/news_event.dart';
import 'package:headspace_interview/bloc/news_bloc/news_state.dart';
import 'package:intl/intl.dart';

import '../../repository/news_repository.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository repository;
  String? from;

  NewsBloc(this.repository) : super(NewsState(articles: [], isLoading: false, hasMore: true)) {
    on<FetchNews>((event, emit) async {
      if (!state.hasMore && event.page > 1) return;

      emit(NewsState(articles: state.articles, isLoading: true, hasMore: state.hasMore));

      try {
        if (event.fetchLatestNews) {
          String toDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
          from = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.parse(from!));
          final articles = await repository.fetchNews(
            from: from,
            to: toDate,
          );
          from = DateTime.now().toString();
          emit(NewsState(articles: [...articles, ...state.articles], isLoading: false, hasMore: state.hasMore));
        } else {
          final articles = await repository.fetchNews(
            page: event.page,
          );
          from = DateTime.now().toString();
          final hasMore = repository.hasMoreData;

          emit(NewsState(articles: [...state.articles, ...articles], isLoading: false, hasMore: hasMore));
        }
      } catch (e) {
        emit(NewsState(articles: state.articles, isLoading: false, hasMore: state.hasMore));
      }
    });
  }
}
