import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lango/curriculum.dart';
import 'package:lango/practice_lessons.dart';

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
  for (final language in ['en', 'de', 'fr', 'es', 'tr']) {
    for (final mode in ['meaning', 'writing', 'order']) {
      testWidgets('$language $mode persists only its own lesson completion', (
        tester,
      ) async {
        final prefs = await SharedPreferences.getInstance();
        final lesson = practiceLessons[language]!['A1']!;
        await tester.pumpWidget(
          MaterialApp(
            home: LevelLessonPage(
              prefs: prefs,
              language: language,
              level: 'A1',
              lessonId: ':practice',
              lesson: lesson,
            ),
          ),
        );
        await tester.ensureVisible(
          find.byType(DropdownButtonFormField<String>),
        );
        await tester.tap(find.byType(DropdownButtonFormField<String>));
        await tester.pumpAndSettle();
        final labels = {
          'meaning': 'درک معنی',
          'writing': 'نوشتن از روی معنی',
          'order': 'ترتیب واژه‌ها',
        };
        await tester.tap(find.text(labels[mode]!).last);
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('شروع تمرین'));
        await tester.tap(find.text('شروع تمرین'));
        await tester.pumpAndSettle();
        for (var i = 0; i < 4; i++) {
          final phrase = lesson.phrases.singleWhere(
            (p) => find
                .text(mode == 'meaning' ? p.text : p.meaning)
                .evaluate()
                .isNotEmpty,
          );
          if (mode == 'meaning') {
            await tester.ensureVisible(find.text(phrase.meaning));
            await tester.tap(find.text(phrase.meaning));
          } else if (mode == 'writing') {
            await tester.enterText(find.byType(TextField), phrase.text);
            await tester.ensureVisible(find.text('بررسی'));
            await tester.tap(find.text('بررسی'));
          } else {
            for (final token in phrase.text.split(RegExp(r'\s+'))) {
              final chip = find.widgetWithText(ActionChip, token).last;
              await tester.ensureVisible(chip);
              await tester.tap(chip);
              await tester.pumpAndSettle();
            }
            await tester.ensureVisible(find.text('بررسی ترتیب'));
            await tester.tap(find.text('بررسی ترتیب'));
          }
          await tester.pumpAndSettle();
          await tester.ensureVisible(find.text('ادامه'));
          await tester.tap(find.text('ادامه'));
          await tester.pumpAndSettle();
        }
        final key =
            'lesson:$language:A1:practice${mode == 'meaning' ? '' : ':$mode'}';
        expect(prefs.getBool(key), true);
        expect(prefs.getInt('$key:best'), 4);
        expect(prefs.getBool('lesson:$language:A1'), isNull);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
