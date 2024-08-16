import '../expression.dart';
import '../monadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class VirusVariable extends Variable {
  VirusVariable(super.letter) {
    values = {1, 2, 3, 4, 5, 6, 7, 8, 9};
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
  void initVariablePuzzle(List<int>? possibleValues) {
    final puzzleMonadics = [
      Monadic('kv', kv, Iterable<int>),
    ];
    Scanner.addMonadics(puzzleMonadics);
    super.initVariablePuzzle(possibleValues);
    staticVariables = variables;
  }
}

Iterable<int> kv(int value) sync* {
  var kValues = VirusPuzzle.staticVariables['K']!.values!;
  var vValues = VirusPuzzle.staticVariables['V']!.values!;
  var strValue = value.toString();
  for (var k in kValues) {
    if (!strValue.contains(k.toString())) continue;
    for (var v in vValues) {
      if (v != k && !strValue.contains(v.toString())) {
        var strResult = strValue.replaceAll(RegExp(k.toString()), v.toString());
        yield int.parse(strResult);
      }
    }
  }
}
