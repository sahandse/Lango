import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lango/main.dart';
import 'package:lango/vocabulary.dart';
import 'package:lango/lango_theme.dart';
import 'package:lango/curriculum.dart';
import 'package:lango/practice_lessons.dart';
import 'package:lango/games.dart';
import 'package:lango/specialized_page.dart';
import 'package:lango/learning_sources.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tts'),
          (call) async => 1,
        );
  });
  Widget shell(Widget page, Brightness brightness, double scale) => MaterialApp(
    theme: langoTheme(brightness),
    locale: const Locale('fa'),
    supportedLocales: const [Locale('fa'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    ),
    home: page,
  );
  for (final size in [
    const Size(320, 568),
    const Size(800, 600),
    const Size(1280, 800),
  ]) {
    for (final brightness in Brightness.values) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
          'Main tabs, settings and cards $size $brightness text $scale',
          (tester) async {
            await tester.binding.setSurfaceSize(size);
            addTearDown(() => tester.binding.setSurfaceSize(null));
            final prefs = await SharedPreferences.getInstance();
            await loadSentenceContent();
            final logo = base64Decode(
              (await rootBundle.loadString('assets/brand/logo.webp.b64'))
                  .trim(),
            );
            await tester.pumpWidget(
              shell(
                Study(
                  prefs: prefs,
                  dark: brightness == Brightness.dark,
                  onTheme: () {},
                  logo: logo,
                ),
                brightness,
                scale,
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            for (final label in ['یادگیری', 'واژه‌نامه', 'پیشرفت', 'خانه']) {
              await tester.tap(find.text(label).last);
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull, reason: label);
            }
            await tester.tap(find.byIcon(Icons.settings_outlined));
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull, reason: 'settings');
          },
        );
      }
    }
  }
  for (final brightness in Brightness.values) {
    testWidgets(
      'Secondary pages in narrow landscape and large text $brightness',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(568, 320));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final prefs = await SharedPreferences.getInstance();
        await loadSentenceContent();
        for (final page in <Widget>[
          CurriculumPage(prefs: prefs, language: 'fr'),
          LevelLessonPage(
            prefs: prefs,
            language: 'tr',
            level: 'C2',
            lesson: practiceLessons['tr']!['C2']!,
          ),
          GamesPage(words: decks['en']!, prefs: prefs, language: 'en'),
          SpecializedPage(prefs: prefs),
          const LearningSources(),
        ]) {
          await tester.pumpWidget(shell(page, brightness, 2));
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: page.runtimeType.toString(),
          );
          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
        }
      },
    );
  }
  testWidgets('Correcting one mistake preserves the other mistake', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'mistakes': ['en:Hello', 'en:Book'],
    });
    final prefs = await SharedPreferences.getInstance();
    final logo = base64Decode(
      (await rootBundle.loadString('assets/brand/logo.webp.b64')).trim(),
    );
    await tester.pumpWidget(
      shell(
        Study(prefs: prefs, dark: false, onTheme: () {}, logo: logo),
        Brightness.light,
        1,
      ),
    );
    await tester.tap(find.text('پیشرفت'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('دفترچه اشتباهات (2)'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.ensureVisible(find.text('بررسی پاسخ'));
    await tester.tap(find.text('بررسی پاسخ'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('کلمه بعدی'));
    await tester.tap(find.text('کلمه بعدی'));
    await tester.pumpAndSettle();
    expect(prefs.getStringList('mistakes'), ['en:Book']);
    expect(tester.takeException(), isNull);
  });
}
