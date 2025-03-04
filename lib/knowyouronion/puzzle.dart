import 'package:crossnumber/generators.dart';

import '../expression.dart';
import '../monadic.dart';
import '../polyadic.dart';
import 'clue.dart';
import '../puzzle.dart';
import '../variable.dart';

// Numbers < 200 that are a power of a prime number

class KnowYourOnionVariable extends Variable {
  KnowYourOnionVariable(super.letter) {
    values = {};
  }
  String get letter => name;
}

class KnowYourOnionPuzzle extends VariablePuzzle<KnowYourOnionClue,
    KnowYourOnionEntry, KnowYourOnionVariable> {
  // Puzzle has Letter variables that are restricted to values 1..9
  KnowYourOnionPuzzle({String name = ''}) : super(null, name: name);
  KnowYourOnionPuzzle.fromGridString(List<String> gridString,
      {String name = ''})
      : super.fromGridString([], gridString, name: name);

  @override
  void initVariablePuzzle(List<int>? possibleValues,
      {bool variableListInitialized = false}) {
    final puzzleMonadics = [
      Monadic(
        'xyzxy',
        xyzxy,
        Iterable<int>,
        order: NodeOrder.UNKNOWN,
      ),
    ];
    Scanner.addMonadics(puzzleMonadics);
    final puzzlePolyadics = [
      Polyadic('producttwothreedigitprimes', productTwoThreeDigitPrimes, int),
    ];
    Scanner.addPolyadics(puzzlePolyadics);
    super.initVariablePuzzle(possibleValues);
  }
}

Iterable<int> xyzxy(dynamic value) sync* {
  var xyz = value as int;
  // XYZ yields XYXXY
  var xy = xyz ~/ 10;
  var z = xyz % 10;
  var xyzxyz = xy * 1000 + z * 100 + xy;
  yield xyzxyz;
  // ZXY yields XYXXY
  var zxy = value;
  z = zxy ~/ 100;
  xy = zxy % 100;
  var x = xy ~/ 10;
  if (x > 0) {
    xyzxyz = xy * 1000 + z * 100 + xy;
    yield xyzxyz;
  }
}

int productTwoThreeDigitPrimes(List<dynamic> args) {
  assert(args.length == 2);
  int value1 = args[0];
  int value2 = args[1];
  var diff = value2 - value1;
  if (diff < 0) diff = -diff;
  if (value1 > 99 &&
      value1 < 1000 &&
      value2 > 99 &&
      value2 < 1000 &&
      diff < 100 &&
      isPrime(value1) &&
      isPrime(value2)) {
    return value1 * value2;
  }

  throw ExpressionInvalid('Non-prime or non-three-digit value');
}
