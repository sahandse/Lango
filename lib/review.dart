/// Adaptive interval scheduling (not FSRS).
int nextInterval(int previous, int rating) {
  if (rating == 0) return 0;
  if (rating == 1) return previous < 1 ? 1 : (previous * 1.2).ceil().clamp(1,365).toInt();
  if (rating == 3) return previous < 1 ? 3 : (previous * 2).clamp(1,365).toInt();
  return previous < 1 ? 7 : (previous * 3).clamp(1,365).toInt();
}
