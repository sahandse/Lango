/// Transcript comparison only. This does not assess phonemes, accent or fluency.
String normalizeTranscript(String value, String locale) {
  var text = value.trim().replaceAll('’', "'").replaceAll('ʼ', "'");
  if (locale.toLowerCase().startsWith('tr')) {
    text = text.replaceAll('I', 'ı').replaceAll('İ', 'i');
  }
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'''[.,!?¿¡:;"“”«»]'''), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

int transcriptSimilarity(String expected, String actual, String locale) {
  final x = normalizeTranscript(expected, locale).runes.toList();
  final y = normalizeTranscript(actual, locale).runes.toList();
  if (x.isEmpty || y.isEmpty) return 0;
  var previous = List<int>.generate(y.length + 1, (i) => i);
  for (var i = 0; i < x.length; i++) {
    final row = <int>[i + 1];
    for (var j = 0; j < y.length; j++) {
      var best = row[j] + 1;
      if (previous[j + 1] + 1 < best) best = previous[j + 1] + 1;
      final substitution = previous[j] + (x[i] == y[j] ? 0 : 1);
      if (substitution < best) best = substitution;
      row.add(best);
    }
    previous = row;
  }
  final length = x.length > y.length ? x.length : y.length;
  return ((1 - previous.last / length) * 100).round().clamp(0, 100);
}
