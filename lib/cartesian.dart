int cartesianCount<T>(List<List<T>> inputs) {
  return inputs.fold(
      1, (previousValue, element) => previousValue * element.length);
}

Iterable<List<T>> cartesian<T>(List<List<T>> inputs,
    [bool duplicates = false]) sync* {
  if (inputs.isEmpty) {
    yield <T>[];
    return;
  }
  var indices = List<int>.filled(inputs.length, 0);
  int cursor = inputs.length - 1;
  outer:
  do {
    var set = <T>{};
    var result = <T>[];

    for (int i = 0; i < indices.length; i++) {
      var value = inputs[i][indices[i]];
      if (!duplicates && !set.add(value)) break;
      result.add(value);
    }

    // Short results are because of duplicate detection
    if (result.length == indices.length) {
      //yield [for (int i = 0; i < indices.length; i++) inputs[i][indices[i]]];
      yield result;
    }
    do {
      int next = indices[cursor] += 1;
      if (next < inputs[cursor].length) {
        cursor = inputs.length - 1;
        break;
      }
      indices[cursor] = 0;
      cursor--;
      if (cursor < 0) break outer;
    } while (true);
  } while (true);
}
