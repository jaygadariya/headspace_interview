import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headspace_interview/bloc/news_bloc/news_bloc.dart';
import 'package:headspace_interview/bloc/news_bloc/news_event.dart';
import 'package:headspace_interview/bloc/news_bloc/news_state.dart';
import 'package:headspace_interview/db/db_helper.dart';
import 'package:headspace_interview/models/article.dart';
import 'package:headspace_interview/repository/news_repository.dart';
import 'package:mockito/mockito.dart';

class MockNewsApiService extends Mock implements NewsApiService {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

@GenerateMocks([NewsApiService, DatabaseHelper])
void main() {
  group('NewsBloc Tests', () {
    late NewsBloc newsBloc;
    late MockNewsApiService mockNewsApiService;
    late MockDatabaseHelper mockDatabaseHelper;

    setUp(() {
      mockNewsApiService = MockNewsApiService();
      mockDatabaseHelper = MockDatabaseHelper();
      newsBloc = NewsBloc(newsApiService: mockNewsApiService, databaseHelper: mockDatabaseHelper);
    });

    tearDown(() {
      newsBloc.close();
    });

    test('Initial state is NewsInitial', () {
      expect(newsBloc.state, equals(NewsInitial()));
    });

    blocTest<NewsBloc, NewsState>(
      'emits [NewsLoading, NewsLoaded] when FetchNewsEvent is added',
      build: () {
        when(mockNewsApiService.getNews(1, '', '')).thenAnswer((_) async => [
              NewsArticle(
                title: 'Test Article',
                description: 'Description',
                url: 'https://test.com',
                urlToImage: '',
                publishedAt: DateTime.now(),
                content: 'Content',
              )
            ]);
        return newsBloc;
      },
      act: (bloc) => bloc.add(FetchNewsEvent(page: 1)),
      expect: () => [
        isA<NewsLoading>(),
        isA<NewsLoaded>(),
      ],
    );
  });
}
