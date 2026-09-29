/// Mode helpers for numeric collections.
class Mode {
  Mode._();

  /// Returns every value that appears most frequently.
  ///
  /// A multimodal collection returns more than one value.
  /// An empty collection throws [ArgumentError].
  static List<num> of(Iterable<num> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) {
      throw ArgumentError('Cannot compute mode of an empty collection.');
    }

    final counts = <num, int>{};
    var maxCount = 0;
    for (final v in list) {
      final next = (counts[v] ?? 0) + 1;
      counts[v] = next;
      if (next > maxCount) maxCount = next;
    }

    return counts.entries
        .where((e) => e.value == maxCount)
        .map((e) => e.key)
        .toList(growable: false);
  }

  /// First / primary mode (the most frequent value that appears first).
  static num primary(Iterable<num> values) => of(values).first;

  /// `true` when every value appears the same number of times
  /// (no unique peak — including a fully unique list).
  static bool isUniform(Iterable<num> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) return true;
    final counts = <num, int>{};
    for (final v in list) {
      counts[v] = (counts[v] ?? 0) + 1;
    }
    final first = counts.values.first;
    return counts.values.every((c) => c == first);
  }
}
