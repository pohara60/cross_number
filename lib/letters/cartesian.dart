Iterable<List<T>> cartesian<T>(List<List<T>> inputs) sync* {
  if (inputs.isEmpty) {
    yield <T>[];
    return;
  }
  var indices = List<int>.filled(inputs.length, 0);
  int cursor = inputs.length - 1;
  outer:
  do {
    var result = [
      for (int i = 0; i < indices.length; i++) inputs[i][indices[i]]
    ];
    // Only lists without duplicates
    if (result.length == Set.from(result).length) {
      yield [for (int i = 0; i < indices.length; i++) inputs[i][indices[i]]];
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

void main(List<String> args) {
  var inputs = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8]
  ];
  for (var product in cartesian(inputs)) {
    print(product);
  }
}
