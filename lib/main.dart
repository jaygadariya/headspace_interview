import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headspace_interview/screens/news_screen.dart';

import 'bloc/news_bloc/news_bloc.dart';
import 'bloc/news_bloc/news_event.dart';
import 'db/db_helper.dart';
import 'repository/news_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseHelper = DatabaseHelper();
  final newsApiService = NewsApiService();
  runApp(MyApp(
    newsApiService: newsApiService,
    databaseHelper: databaseHelper,
  ));
}

class MyApp extends StatelessWidget {
  final NewsApiService? newsApiService;
  final DatabaseHelper? databaseHelper;

  const MyApp({
    Key? key,
    this.newsApiService,
    this.databaseHelper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      home: BlocProvider<NewsBloc>(
        create: (context) => NewsBloc(
          newsApiService: newsApiService!,
          databaseHelper: databaseHelper!,
        )..add(FetchNewsEvent(page: 1)), // Initial fetch
        child: const NewsScreen(),
      ),
    );
  }
}
