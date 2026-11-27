import 'dart:convert';

import 'vocabulary.dart';

/// Ignore malformed rows without losing the rest of a user's saved cards.
List<Word> readPersonalCards(String? raw) {
  if (raw == null || raw.length > 5000000) return [];
  try {
    final data = jsonDecode(raw);
    if (data is! List) return [];
    final seen = <String>{};
    return [
      for (final row in data)
        if (row is Map &&
            row['term'] is String &&
            row['meaning'] is String &&
            (row['term'] as String).trim().isNotEmpty &&
            (row['meaning'] as String).trim().isNotEmpty &&
            seen.add((row['term'] as String).trim().toLowerCase()))
          Word(
            (row['term'] as String).trim(),
            (row['meaning'] as String).trim(),
            row['example'] is String ? row['example'] as String : '',
          ),
    ];
  } on FormatException {
    return [];
  }
}
