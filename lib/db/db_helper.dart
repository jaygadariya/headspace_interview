import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/article.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'news.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS favorites(
            title TEXT PRIMARY KEY,
            description TEXT,
            urlToImage TEXT,
            url TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveArticle(Article article) async {
    final db = await database;
    await db.insert('favorites', article.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Article>> getSavedArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return maps.map((map) => Article.fromJson(map)).toList();
  }

  Future<void> removeArticle(String title) async {
    final db = await database;
    await db.delete('favorites', where: 'title = ?', whereArgs: [title]);
  }

  Future<bool> isArticleSaved(String title) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites', where: 'title = ?', whereArgs: [title]);
    return maps.isNotEmpty;
  }
}
