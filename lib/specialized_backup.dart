import 'dart:convert';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'specialized_vocabulary.dart';

class SpecializedBackup {
 final Map<String,dynamic> progress;
 final Set<String> stars;
 SpecializedBackup(this.progress,this.stars);
 factory SpecializedBackup.parse(String raw){
  if(raw.length>5000000)throw const FormatException('Backup too large');
  final data=jsonDecode(raw);
  if(data is! Map || data['version']!=1 || data['progress'] is! Map || data['stars'] is! List)throw const FormatException('Invalid backup');
  final allowed={for(final entry in specializedVocabulary.entries) for(final w in entry.value) '${entry.key}:${w.term}'};
  final progress=<String,dynamic>{};
  for(final e in (data['progress'] as Map).entries){
   if(e.key is! String || !allowed.contains(e.key) || e.value is! Map)throw const FormatException('Unknown card');
   final row=Map<String,dynamic>.from(e.value as Map);
   if(row['reviews'] is! int || (row['reviews'] as int)<1 || row['due'] is! int || row['fsrs'] is! Map)throw const FormatException('Invalid review');
   final card=fsrs.Card.fromMap(Map<String,dynamic>.from(row['fsrs'] as Map));
   if(card.due.millisecondsSinceEpoch!=row['due'])throw const FormatException('Invalid due date');
   progress[e.key as String]={'reviews':row['reviews'],'due':row['due'],'fsrs':card.toMap()};
  }
  final stars=<String>{};
  for(final key in data['stars'] as List){
   if(key is! String||!allowed.contains(key))throw const FormatException('Invalid favorite');
   stars.add(key);
  }
  return SpecializedBackup(progress,stars);
 }
}
