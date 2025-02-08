abstract class NewsEvent {}

class FetchNews extends NewsEvent {
  final int page;
  final bool fetchLatestNews;
  FetchNews({this.page = 1, this.fetchLatestNews = false});
}
