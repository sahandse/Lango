import 'package:flutter_test/flutter_test.dart';
import 'package:lango/lens.dart';
import 'package:lango/vocabulary.dart';
void main(){
 test('Aliases map to known translations without guessing unknown labels',(){
 final en=[const Word('Bicycle','دوچرخه',''),const Word('Phone','تلفن','')];
 final de=[const Word('Fahrrad','دوچرخه',''),const Word('Telefon','تلفن','')];
 expect(matchLensWords(' BIKE ',en,de).single.term,'Fahrrad');
 expect(matchLensWords('mobile-phone',en,de).single.term,'Telefon');
 expect(matchLensWords('unknown',en,de),isEmpty);
 });
 test('Every extra object deck has 36 entries',(){
 expect(extraObjectVocabulary.length,5);
 for(final deck in extraObjectVocabulary.values){expect(deck.length,36);}
 });
}
