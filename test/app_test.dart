import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:headspace_interview/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Favorite button toggles correctly', (WidgetTester tester) async {
    await tester.pumpWidget(NewsScreen());
    await tester.pumpAndSettle();

    final favoriteButton = find.byIcon(Icons.favorite_border);
    expect(favoriteButton, findsWidgets);

    await tester.tap(favoriteButton.first);
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsWidgets);
  });
}
