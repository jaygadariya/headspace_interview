import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headspace_interview/bloc/favorite_bloc/favorite_event.dart';
import 'package:headspace_interview/bloc/favorite_bloc/favorite_state.dart';

import '../../db/db_helper.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final DatabaseHelper dbHelper;

  FavoriteBloc(this.dbHelper) : super(FavoriteState(favorites: [])) {
    on<LoadFavorites>((event, emit) async {
      final articles = await dbHelper.getSavedArticles();
      emit(FavoriteState(favorites: articles));
    });

    on<ToggleFavorite>((event, emit) async {
      bool isSaved = await dbHelper.isArticleSaved(event.article.title);
      if (isSaved) {
        await dbHelper.removeArticle(event.article.title);
      } else {
        await dbHelper.saveArticle(event.article);
      }
      final articles = await dbHelper.getSavedArticles();
      emit(FavoriteState(favorites: articles));
    });
  }
}
