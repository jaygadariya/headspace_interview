import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/news_bloc/news_bloc.dart';
import '../../bloc/news_bloc/news_event.dart';
import '../../models/article.dart';

class NewsItem extends StatelessWidget {
  final NewsArticle article;

  const NewsItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                child: article.urlToImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16.0),
                          topLeft: Radius.circular(16.0),
                        ),
                        child: Image.network(
                          article.urlToImage,
                          errorBuilder: (context, url, error) => SizedBox.shrink(),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              ExpansionTile(
                shape: Border(),
                title: Text(article.title),
                subtitle: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(article.publishedAt),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(article.description),
                  )
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 5,
              child: IconButton(
                icon: Icon(article.isSaved ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () {
                  if (article.isSaved) {
                    context.read<NewsBloc>().add(UnsaveArticleEvent(article: article));
                  } else {
                    context.read<NewsBloc>().add(SaveArticleEvent(article: article));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
