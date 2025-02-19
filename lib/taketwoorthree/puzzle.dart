import 'package:basics/basics.dart';

import '../expression.dart';
import '../generators.dart';
import '../polyadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class TakeTwoOrThreeVariable extends Variable {
  TakeTwoOrThreeVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class TakeTwoOrThreePuzzle extends VariablePuzzle<TakeTwoOrThreeClue,
    TakeTwoOrThreeEntry, TakeTwoOrThreeVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  TakeTwoOrThreePuzzle({String name = ''}) : super(null, name: name);
  TakeTwoOrThreePuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    final puzzlePolyadics = [
      Polyadic('remove', removePrefixSuffix, int, order: NodeOrder.UNKNOWN),
    ];
    Scanner.addPolyadics(puzzlePolyadics);
    super.initVariablePuzzle(possibleValues);
  }
}

int removePrefixSuffix(List<dynamic> args) {
  assert(args.length == 5);
  int value1 = ExpressionEvaluator.checkInteger(args[0]);
  if (value1 % 2 != 1) throw ExpressionInvalid('Value is not odd $value1');
  int value2 = ExpressionEvaluator.checkInteger(args[1]);
  if (value2 % 2 != 1) throw ExpressionInvalid('Value is not odd $value2');
  if (value1 >= value2) {
    throw ExpressionInvalid('Values are not ascending $value1>=$value2');
  }
  int value3 = ExpressionEvaluator.checkInteger(args[2]);
  if (value3 % 2 != 1) throw ExpressionInvalid('Value is not odd $value3');
  if (value2 >= value3) {
    throw ExpressionInvalid('Values are not ascending $value2>=$value3');
  }
  String prefix = args[3];
  String suffix = args[4];
  int value = value1 + value2 + value3;
  if ((value - 3) % 16 != 0) throw ExpressionInvalid('Sum is not 16s+3 $value');
  var s = (value - 3) ~/ 16;
  if (!isTriangular(s)) throw ExpressionInvalid('Sum s is not triangular $s');
  if (prefix == '' && suffix == '') return value;
  var strValue = value.toString();
  if ((prefix == '' || strValue.startsWith(prefix)) &&
      (suffix == '' || strValue.endsWith(suffix))) {
    var strResult = strValue.slice(
        start: prefix.length, end: strValue.length - suffix.length);
    return int.parse(strResult);
  }
  throw ExpressionInvalid(
      'Value $strValue does not have prefix/suffix $prefix/$suffix');
}
