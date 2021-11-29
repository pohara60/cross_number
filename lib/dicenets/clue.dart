import 'package:crossnumber/clue.dart';

/// A [DiceNetsPuzzle] clue
class DiceNetsClue extends Clue {
  DiceNetsClue({
    required name,
    required length,
    valueDesc,
    solve,
  }) : super(name: name, length: length, valueDesc: valueDesc, solve: solve);

  void initDigits() {
    // possible digits are 1..6
    digits = [];
    for (var d = 0; d < this.length; d++) {
      digits.add(Set.from(List.generate(6, (index) => index + 1)));
    }
  }
}
