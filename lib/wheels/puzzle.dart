import '../wheels/clue.dart';
import '../puzzle.dart';

import '../variable.dart';

class WheelsVariable extends ExpressionVariable {
  WheelsVariable(String variable,
      {int min = 1, int? max, String valueDesc = '', SolveFunction? solve})
      : super(variable, valueDesc, min: min, max: max, solve: solve) {
    if (max != null) {
      values = Set.from(List.generate(max - min + 1, (index) => min + index));
    }
  }
}

class WheelsPuzzle
    extends VariablePuzzle<WheelsClue, WheelsEntry, WheelsVariable> {
  WheelsPuzzle() : super(null);
  WheelsPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString(null, gridString);
}
