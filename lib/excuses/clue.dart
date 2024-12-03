import 'package:crossnumber/expression.dart';
import 'package:crossnumber/set.dart';

import '../clue.dart';
import '../variable.dart';

/// A Puzzle clue
class ExcusesClue extends ExpressionClue {
  /// List of referenced primes
  List<String> get letterReferences => variableNameReferences;
  addLetterReference(String letter) => addVariableReference(letter);

  final String? a;
  final String? b;
  final String? c;
  final String? n;
  final String? isLetter;
  final exps = <ExpressionEvaluator>[];

  ExcusesClue(
      {required super.name,
      super.type = VariableType.C,
      required super.length,
      required this.a,
      required this.b,
      required this.c,
      required this.n,
      required this.isLetter,
      super.valueDesc,
      super.addDesc,
      super.solve,
      super.entryNames}) {
    if (a != null) {
      exps.add(ExpressionEvaluator(a!));
      exps.add(ExpressionEvaluator(b!));
      exps.add(ExpressionEvaluator(c!));
      exps.add(ExpressionEvaluator(n!));
    }
  }

  int minDiff = 0;
  int? maxDiff;
  var diffs = <int>{};

  @override
  String toString() {
    var text = super.toString();
    var diffStr = diffs.toShortString();
    if (a != null) {
      text +=
          ',\n\tentry=${entry!.name},a=$a,b=$b,c=$c,n=$n,isLetter=$isLetter,\n\tdiffs=$diffStr,minDiff=$minDiff,maxDiff=$maxDiff';
    }
    return text;
  }
}

class ExcusesEntry extends ExcusesClue with EntryMixin {
  ExcusesEntry({
    required super.name,
    super.type = VariableType.E,
    required super.length,
    super.valueDesc,
    super.solve,
    super.entryNames,
    super.a,
    super.b,
    super.c,
    super.n,
    super.isLetter = "",
  }) {
    initEntry(this);
  }
}
