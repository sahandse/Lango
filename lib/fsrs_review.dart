import 'package:fsrs/fsrs.dart' as fsrs;

final _scheduler = fsrs.Scheduler();

Map<String,dynamic> scheduleReview(Map<String,dynamic>? previous,int rating,int id) {
  final stored=previous?['fsrs'];
  final original=stored is Map ? fsrs.Card.fromMap(Map<String,dynamic>.from(stored)) : fsrs.Card(cardId:id);
  final selected=switch(rating){0=>fsrs.Rating.again,1=>fsrs.Rating.hard,3=>fsrs.Rating.good,_=>fsrs.Rating.easy};
  final result=_scheduler.reviewCard(original,selected);
  return {'reviews':(previous?['reviews'] as int? ?? 0)+1,'due':result.card.due.millisecondsSinceEpoch,'fsrs':result.card.toMap()};
}
