import 'package:flutter_test/flutter_test.dart';
import 'package:lango/speech_match.dart';

void main() {
  test('Punctuation, whitespace and apostrophes normalize', () {
    expect(transcriptSimilarity('¿Hola, mundo?', 'hola   mundo', 'es-ES'), 100);
    expect(transcriptSimilarity('J’habite ici.', "j'habite ici", 'fr-FR'), 100);
  });
  test('Turkish casing preserves dotted and dotless I', () {
    expect(transcriptSimilarity('İSTASYON', 'istasyon', 'tr-TR'), 100);
    expect(transcriptSimilarity('IRMAK', 'ırmak', 'tr-TR'), 100);
    expect(transcriptSimilarity('IRMAK', 'irmak', 'tr-TR'), lessThan(100));
  });
  test('Empty and different transcripts never receive full credit', () {
    expect(transcriptSimilarity('', '', 'en-US'), 0);
    expect(transcriptSimilarity('water', '', 'en-US'), 0);
    expect(transcriptSimilarity('water', 'later', 'en-US'), 80);
    expect(transcriptSimilarity('abc', 'xyz', 'en-US'), 0);
  });
}
