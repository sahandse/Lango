import 'package:flutter_test/flutter_test.dart';
import 'package:lango/level_lessons.dart';
import 'package:lango/practice_lessons.dart';
import 'package:lango/ipa.dart';
import 'package:lango/vocabulary.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('All five languages have 12 distinct lessons and 48 phrase pairs', () {
    for (final language in names.keys) {
      final texts = <String>{};
      for (final level in ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']) {
        for (final catalog in [levelLessons, practiceLessons]) {
          final lesson = catalog[language]![level]!;
          expect(lesson.phrases.length, 4);
          expect(lesson.phrases.map((p) => p.meaning).toSet().length, 4);
          for (final phrase in lesson.phrases) {
            expect(phrase.meaning.trim(), isNotEmpty);
            expect(
              texts.add(phrase.text),
              isTrue,
              reason: 'Duplicate $language $level: ${phrase.text}',
            );
          }
        }
      }
      expect(texts.length, 48);
    }
  });
  test(
    'Offline content loads idempotently with aligned object translations',
    () async {
      await loadSentenceContent();
      final counts = {
        for (final entry in decks.entries) entry.key: entry.value.length,
      };
      await loadSentenceContent();
      expect({
        for (final entry in decks.entries) entry.key: entry.value.length,
      }, counts);
      final en = extraObjectVocabulary['en']!.map((w) => w.meaning).toSet();
      for (final deck in extraObjectVocabulary.values) {
        expect(deck.map((w) => w.meaning).toSet(), en);
      }
    },
  );
  test('IPA never silently substitutes an unsupported accent', () {
    expect(ipaFor('en-GB', 'water'), isNot(ipaFor('en-US', 'water')));
    expect(ipaFor('en-AU', 'water'), isNull);
    expect(ipaFor('fr-CA', 'bonjour'), isNull);
    expect(ipaFor('xx', 'unknown'), isNull);
    for (final entry in ipaEntries.entries) {
      expect(accents.values.expand((e) => e), contains(entry.key));
      expect(entry.value.values.every((ipa) => ipa.isNotEmpty), isTrue);
    }
  });
}
