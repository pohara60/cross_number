import '../partners/clue.dart';
import '../puzzle.dart';

import '../variable.dart';

class PartnersPuzzle
    extends VariablePuzzle<PartnersClue, PartnersEntry, Variable> {
  PartnersPuzzle() : super([]);
  PartnersPuzzle.grid(List<String> gridString) : super.grid([], gridString);
}
