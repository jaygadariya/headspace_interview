import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsApiService {
  final String apiKey = '8f9ab275d04b47778d277a91928fdb81';
  final String baseUrl = 'https://newsapi.org/v2/everything?q=tesla';

  Future<List<NewsArticle>> getNews(int page, String from, String to) async {
    String url = '$baseUrl&apiKey=$apiKey';
    if (from.isNotEmpty) {
      url = url + "&from=$from&to=$to";
    } else {
      url = url + "&page=$page&pageSize=20";
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final articles = jsonData['articles'] as List;
      return articles
          .map((article) => NewsArticle(
                title: article['title'] ?? '',
                description: article['description'] ?? '',
                url: article['url'] ?? '',
                urlToImage: article['urlToImage'] ?? '',
                publishedAt: DateTime.parse(article['publishedAt']),
                content: article['content'] ?? '',
              ))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
