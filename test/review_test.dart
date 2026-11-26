import 'package:flutter_test/flutter_test.dart';
import 'package:lango/review.dart';
import 'package:lango/vocabulary.dart';
void main(){
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Review intervals adapt and stay bounded',(){
    expect(nextInterval(0,0),0);
    expect(nextInterval(0,1),1);
    expect(nextInterval(3,3),6);
    expect(nextInterval(300,7),365);
  });
  test('Every deck contains unique words',() async {
    await loadSentenceContent();
    for(final deck in decks.values){
      expect(deck.length,greaterThan(10));
      expect(deck.map((w)=>w.term).toSet().length,deck.length);
    }
  });
}
