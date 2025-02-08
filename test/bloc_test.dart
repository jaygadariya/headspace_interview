import 'package:flutter_test/flutter_test.dart';
import 'package:headspace_interview/bloc/news_bloc/news_bloc.dart';
import 'package:headspace_interview/repository/news_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsRepository {}

void main() {
  late NewsBloc newsBloc;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    newsBloc = NewsBloc(mockNewsService);
  });

  tearDown(() {
    newsBloc.close();
  });
}
