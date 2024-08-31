import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class SevenRulesVariable extends Variable {
  SevenRulesVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class SevenRulesPuzzle extends VariablePuzzle<SevenRulesClue, SevenRulesEntry, SevenRulesVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  SevenRulesPuzzle({String name = ''}) : super(null, name: name);
  SevenRulesPuzzle.fromGridString(List<String> gridString, {String name = ''})
      : super.fromGridString([], gridString, name: name);
}