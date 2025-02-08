import 'package:headspace_interview/models/article.dart';

abstract class FavoriteEvent {}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final Article article;
  ToggleFavorite(this.article);
}
