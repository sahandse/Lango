import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lango/fsrs_review.dart';
void main(){
  test('FSRS state survives JSON and a second review',(){
    final first=scheduleReview(null,3,42);
    expect(first['reviews'],1);
    expect(first['due'],greaterThan(0));
    final restored=Map<String,dynamic>.from(jsonDecode(jsonEncode(first)) as Map);
    final second=scheduleReview(restored,0,42);
    expect(second['reviews'],2);
    expect(second['fsrs'],isA<Map>());
  });
}
