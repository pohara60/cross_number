import '../expression.dart';
import '../monadic.dart';
import '../polyadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class VirusVariable extends Variable {
  VirusVariable(super.letter) {
    values = initXValues();
  }
  String get letter => name;
}

class VirusPuzzle extends VariablePuzzle<VirusClue, VirusEntry, VirusVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  VirusPuzzle({String name = ''}) : super(null, name: name);
  VirusPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);

  static var staticVariables = <String, Variable>{};

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    final puzzleMonadics = [
      Monadic('kv', kv, Iterable<int>),
    ];
    Scanner.addMonadics(puzzleMonadics);
    final puzzlePolyadics = [
      Polyadic('kv', kvFunc, int),
      Polyadic('inversekv', inversekvFunc, Iterable<int>,
          order: NodeOrder.UNKNOWN),
    ];
    Scanner.addPolyadics(puzzlePolyadics);
    super.initVariablePuzzle(possibleValues);
    staticVariables = variables;
  }
}

Iterable<int> kv(dynamic value) sync* {
  var xValues = VirusPuzzle.staticVariables['X']!.values!;
  var strValue = (value as int).toString();
  for (var x in xValues) {
    var k = x ~/ 10;
    var v = x % 10;
    if (!strValue.contains(k.toString())) continue;
    if (v != k && !strValue.contains(v.toString())) {
      var strResult = strValue.replaceAll(RegExp(k.toString()), v.toString());
      yield int.parse(strResult);
    }
  }
}

Set<int> initXValues() {
  var digits = {1, 2, 3, 4, 5, 6, 7, 8, 9};
  var x = <int>{};
  for (var k in digits) {
    for (var v in digits) {
      if (k != v) x.add(k * 10 + v);
    }
  }
  return x;
}

int kvFunc(List<dynamic> args) {
  assert(args.length == 2);
  int value = args[0];
  int x = args[1];
  var strValue = value.toString();
  var k = x ~/ 10;
  var v = x % 10;
  if (strValue.contains(k.toString()) &&
      v != k &&
      !strValue.contains(v.toString())) {
    var strResult = strValue.replaceAll(RegExp(k.toString()), v.toString());
    return int.parse(strResult);
  }
  return value;
}

Iterable<int> inversekvFunc(List<dynamic> args) sync* {
  assert(args.length == 2);
  int value = args[0];
  var x = args[1];
  // Invert KV
  x = (x % 10) * 10 + x ~/ 10;
  var strValue = value.toString();
  var k = x ~/ 10;
  var v = x % 10;
  if (strValue.contains(k.toString()) &&
      v != k &&
      !strValue.contains(v.toString())) {
    var strResult = strValue.replaceAll(RegExp(k.toString()), v.toString());
    yield int.parse(strResult);
  }
  // Original may not have had K, but had V, so always return value
  yield value;
}
