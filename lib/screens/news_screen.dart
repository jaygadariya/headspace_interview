import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headspace_interview/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:headspace_interview/bloc/favorite_bloc/favorite_event.dart';
import 'package:headspace_interview/bloc/favorite_bloc/favorite_state.dart';
import 'package:headspace_interview/bloc/news_bloc/news_bloc.dart';
import 'package:headspace_interview/bloc/news_bloc/news_event.dart';
import 'package:headspace_interview/bloc/news_bloc/news_state.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isAppActive = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _isAppActive = true;
    } else {
      _isAppActive = false;
    }
  }

  void _startAutoRefresh() {
    Future.delayed(Duration(minutes: 1), () {
      if (_isAppActive) {
        context.read<NewsBloc>()..add(FetchNews(fetchLatestNews: true));
      }
      _startAutoRefresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsBloc>()..add(FetchNews(page: _currentPage));
      context.read<FavoriteBloc>()..add(LoadFavorites());

      _scrollController.addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _currentPage++;
          context.read<NewsBloc>().add(FetchNews(page: _currentPage));
        }
      });
    });
    _startAutoRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News App')),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          return BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, favoriteState) {
              if (state.isLoading && state.articles.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: state.articles.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.articles.length) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final article = state.articles[index];
                  final isFavorite = favoriteState.favorites.any((fav) => fav.title == article.title);

                  return Card(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.network(
                            article.urlToImage,
                            errorBuilder: (context, _, e) {
                              return Container();
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(article.title),
                          subtitle: Text(article.description),
                          trailing: IconButton(
                            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                            color: isFavorite ? Colors.red : Colors.grey,
                            onPressed: () {
                              context.read<FavoriteBloc>()..add(ToggleFavorite(article));
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _launchInWebView(Uri.parse(article.url));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          ),
                          child: Text('Load More about this news', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
