import 'package:flutter_test/flutter_test.dart';
import 'package:lango/personal_cards.dart';

void main() {
  test('Damaged personal storage does not break startup', () {
    for (final raw in [null, '', '{', '{}', '1', 'null']) {
      expect(readPersonalCards(raw), isEmpty);
    }
  });
  test('Valid personal cards survive malformed neighbours', () {
    final cards = readPersonalCards(
      '[null,{}, {"term":" Hallo ","meaning":"سلام"}, {"term":"hallo","meaning":"سلام"}, {"term":4,"meaning":"bad"}]',
    );
    expect(cards.length, 1);
    expect(cards.single.term, 'Hallo');
    expect(cards.single.example, '');
  });
}
