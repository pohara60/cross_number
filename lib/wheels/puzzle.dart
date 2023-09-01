import 'package:crossnumber/wheels/clue.dart';
import 'package:crossnumber/puzzle.dart';

import '../variable.dart';

class WheelsVariable extends ExpressionVariable {
  final int min;
  final int? max;
  WheelsVariable(String variable, {this.min = 1, this.max, valueDesc = ''})
      : super(variable, valueDesc) {
    if (max != null) {
      values = Set.from(List.generate(max! - min + 1, (index) => min + index));
    }
  }

  @override
  String toString() {
    var text = super.toString();
    text += ',min=${min}';
    text += ',max=${max}';
    return text;
  }
}

class WheelsPuzzle
    extends VariablePuzzle<WheelsClue, WheelsEntry, WheelsVariable> {
  WheelsPuzzle() : super([]);
  WheelsPuzzle.grid(List<String> gridString) : super.grid([], gridString);
}
