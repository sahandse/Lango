import 'package:flutter_test/flutter_test.dart';
import 'package:lango/level_lessons.dart';
void main(){
 test('Each supported language includes six distinct starter lessons',(){
 expect(levelLessons.keys.toSet(),{'en','de','fr','es','tr'});
 for(final lessons in levelLessons.values){
 expect(lessons.keys.toSet(),{'A1','A2','B1','B2','C1','C2'});
 for(final lesson in lessons.values){
 expect(lesson.phrases.length,4);
 expect(lesson.phrases.map((p)=>p.text).toSet().length,4);
 expect(lesson.phrases.map((p)=>p.meaning).toSet().length,4);
 expect(lesson.phrases.every((p)=>p.text.isNotEmpty&&p.meaning.isNotEmpty),isTrue);
 }
 }
 });
}
