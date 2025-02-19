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
  assert(inputs.every((element) => element.isNotEmpty));
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

Iterable<List<T>> cartesianDuplicateLimit<T>(
    List<List<T>> inputs, Map<int, int> duplicateLimit) sync* {
  if (inputs.isEmpty) {
    yield <T>[];
    return;
  }
  assert(inputs.every((element) => element.isNotEmpty));
  var indices = List<int>.filled(inputs.length, 0);
  int cursor = 0;
  var result = <T>[];
  outer:
  do {
    while (cursor < indices.length) {
      var value = inputs[cursor][indices[cursor]];
      var count = result.isEmpty
          ? 0
          : result
              .map((element) => element == value ? 1 : 0)
              .reduce((value, element) => value + element);

      var remaining = duplicateLimit[value]! - count;
      if (remaining < 1) {
        break;
      }
      result.add(value);
      cursor++;
    }

    // Short results are because of duplicate detection
    if (result.length == indices.length) {
      //yield [for (int i = 0; i < indices.length; i++) inputs[i][indices[i]]];
      yield result;
      result.removeLast();
      cursor--;
    }
    do {
      int next = indices[cursor] += 1;
      if (next < inputs[cursor].length) {
        break;
      }
      indices[cursor] = 0;
      cursor--;
      if (cursor < 0) break outer;
      result.removeLast();
    } while (true);
  } while (true);
}
