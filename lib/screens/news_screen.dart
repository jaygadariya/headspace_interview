import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headspace_interview/screens/widgets/news_item.dart';

import '../bloc/news_bloc/news_bloc.dart';
import '../bloc/news_bloc/news_event.dart';
import '../bloc/news_bloc/news_state.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLatestNews();
    _scrollController.addListener(_onScroll);
  }

  fetchLatestNews() async {
    //await Future.delayed(Duration(seconds: 30));
    //context.read<NewsBloc>().add(FetchNewsEvent(page: 1, fetchLatest: true));
    //fetchLatestNews();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0 && !_isLoading) {
      _isLoading = true;
      _page++;
      context.read<NewsBloc>().add(FetchNewsEvent(page: _page));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: BlocConsumer<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsLoaded) {
            _isLoading = false;
          }
        },
        builder: (context, state) {
          if (state is NewsLoading && _page < 1) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NewsLoaded) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.articles.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == state.articles.length) {
                  return CircularProgressIndicator();
                }
                final article = state.articles[index];
                return NewsItem(article: article);
              },
            );
          } else if (state is NewsError) {
            return Center(child: Text(state.message));
          } else if (state is SavedArticlesLoaded) {
            return ListView.builder(
              itemCount: state.savedArticles.length,
              itemBuilder: (context, index) {
                final article = state.savedArticles[index];
                return NewsItem(article: article);
              },
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
        ],
        currentIndex: 0,
        onTap: (int index) {
          if (index == 1) {
            context.read<NewsBloc>().add(LoadSavedArticlesEvent());
          } else {
            context.read<NewsBloc>().add(FetchNewsEvent(page: 1));
          }
        },
      ),
    );
  }
}
