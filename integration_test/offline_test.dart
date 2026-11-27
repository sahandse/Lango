import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lango/main.dart' as app;
import 'package:lango/vocabulary.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Offline startup, five dictionaries, saved favorite and themes', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Isolated CI emulator only.
    await app.main();
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    expect(find.text('Lango'), findsOneWidget);
    await binding.takeScreenshot('home-light');
    for (final language in names.entries) {
      await tester.tap(find.byType(DropdownButtonFormField<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text(language.value).last);
      await tester.pumpAndSettle();
      expect(prefs.getString('language'), language.key);
      await tester.tap(find.text('واژه‌نامه').last);
      await tester.pumpAndSettle();
      expect(find.text(decks[language.key]!.first.term), findsWidgets);
      expect(tester.takeException(), isNull);
    }
    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();
    expect(prefs.getStringList('favorites'), isNotEmpty);
    await binding.takeScreenshot('dictionary-offline');
    await tester.tap(find.text('خانه').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pumpAndSettle();
    expect(prefs.getBool('dark'), true);
    await tester.tapAt(const Offset(10, 100));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('home-dark');
    // Recreate the app using persisted preferences, without a network connection.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    await app.main();
    await tester.pumpAndSettle();
    expect(prefs.getString('language'), 'tr');
    expect(prefs.getBool('dark'), true);
    expect(prefs.getStringList('favorites'), isNotEmpty);
    expect(tester.takeException(), isNull);
  });
}
