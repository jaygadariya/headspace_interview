import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headspace_interview/repository/news_repository.dart';
import 'package:headspace_interview/screens/news_screen.dart';

import 'bloc/favorite_bloc/favorite_bloc.dart';
import 'bloc/news_bloc/news_bloc.dart';
import 'db/db_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewsBloc(NewsRepository()),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(DatabaseHelper()),
        ),
      ],
      child: MaterialApp(
        home: NewsScreen(),
      ),
    );
  }
}
