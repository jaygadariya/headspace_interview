import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsRepository {
  static const String apiKey = '8746339c565045778d8eeda89d87b812';
  static const String baseUrl = 'https://newsapi.org/v2/everything?q=tesla&apiKey=$apiKey';

  int _currentPage = 1;
  bool _hasMoreData = true;

  Future<List<Article>> fetchNews({String? from, String? to, int page = 1}) async {
    if (!_hasMoreData) return [];
    String url = '$baseUrl';
    if (from != null) {
      url = url + "&from=$from&to=$to";
    } else {
      url = url + "&page=$page&pageSize=20";
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Article> articles = (data['articles'] as List).map((json) => Article.fromJson(json)).toList();

      if (articles.isEmpty) {
        _hasMoreData = false;
      } else {
        _currentPage = page;
      }

      return articles;
    } else if (response.statusCode.toString().isNotEmpty) {
      print(json.decode(response.body)['message']);
      throw Exception(json.decode(response.body)['message']);
    } else {
      throw Exception('Unknown error occurred');
    }
  }

  int get currentPage => _currentPage;

  bool get hasMoreData => _hasMoreData;
}
