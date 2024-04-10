import '../partners/clue.dart';
import '../puzzle.dart';

import '../variable.dart';

class PartnersPuzzle
    extends VariablePuzzle<PartnersClue, PartnersEntry, Variable> {
  PartnersPuzzle() : super([]);
  PartnersPuzzle.fromGridString(List<String> gridString)
      : super.fromGridString([], gridString);
}
