import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/article.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'news_app.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE articles(title TEXT PRIMARY KEY, description TEXT, url TEXT, urlToImage TEXT, publishedAt TEXT, content TEXT, isSaved INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveArticle(NewsArticle article) async {
    final db = await database;
    await db.insert('articles', {
      'title': article.title,
      'description': article.description,
      'url': article.url,
      'urlToImage': article.urlToImage,
      'publishedAt': article.publishedAt.toIso8601String(),
      'content': article.content,
      'isSaved': 1,
    });
  }

  Future<void> unsaveArticle(String title) async {
    final db = await database;
    await db.delete('articles', where: 'title = ?', whereArgs: [title]);
  }

  Future<List<NewsArticle>> getSavedArticles() async {
    final db = await database;
    final maps = await db.query('articles');
    return maps
        .map((map) =>
            NewsArticle(title: map['title'] as String, description: map['description'] as String, url: map['url'] as String, urlToImage: map['urlToImage'] as String, publishedAt: DateTime.parse(map['publishedAt'] as String), content: map['content'] as String, isSaved: (map['isSaved'] as int) == 1))
        .toList();
  }

  Future<NewsArticle?> getArticle(String title) async {
    final db = await database;
    final maps = await db.query('articles', where: 'title = ?', whereArgs: [title]);
    if (maps.isNotEmpty) {
      final map = maps.first;
      return NewsArticle(title: map['title'] as String, description: map['description'] as String, url: map['url'] as String, urlToImage: map['urlToImage'] as String, publishedAt: DateTime.parse(map['publishedAt'] as String), content: map['content'] as String, isSaved: (map['isSaved'] as int) == 1);
    }
    return null;
  }
}
