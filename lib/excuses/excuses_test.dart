class Variable {
  final String name;
  Set<int>? values;

  Variable({required this.name, this.values});
}

var variables = <String, Variable>{};

class Clue extends Variable {
  final String desc;
  final Set<int> diffs = {};
  int minDiff;
  int? maxDiff;

  Clue(
      {required super.name,
      required this.desc,
      this.minDiff = 0,
      this.maxDiff});
}

var clues = <String, Clue>{};

void main(List<String> args) {
  init();
}

void init() {
  var values1to5 = [1, 2, 3, 4, 5];
  var values6to26 = List.generate(21, (index) => 6 + index);
  for (var name in [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  ]) {
    if (['c', 'h', 'i', 'p', 'q'].contains(name)) {
      variables[name] = Variable(name: name, values: Set.from(values1to5));
    } else {
      variables[name] = Variable(name: name, values: Set.from(values6to26));
    }
  }
}
